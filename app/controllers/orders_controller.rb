class OrdersController < ApplicationController
    before_action :require_login
    before_action :require_clerk, only: [:index, :mark_delivered, :mark_not_delivered]
    before_action :require_admin, only: [:report]

    def index
        @orders = Order.where(created_at: 3.days.ago..DateTime.now)
    end

    def report
        @from = Date.strptime(params[:from], '%Y-%m-%d')
        @to = Date.strptime(params[:to], '%Y-%m-%d')
        @orders = Order.where(created_at: @from..@to)
    end

    def show
        @order = Order.find(params[:id])
    end

    def create
        order = Order.new(user: current_user)
        order_items_data = JSON.parse(order_params)
        order.total_price = order_items_data.reduce(0) {|sum, item| sum + (item["price"] * item["quantity"].to_i) }
        order.save
        order_items_data.each do |item| 
            order_item = OrderItem.new(name: item["name"], price: item["price"], quantity: item["quantity"], order_id: order.id, item_id: item["id"])
            order_item.save
        end
        item_ids = $redis.smembers current_user_cart
        redis_keys = item_ids.map {|id| "#{current_user_cart}#{id}"}
        redis_keys.push(current_user_cart)
        $redis.del(redis_keys)
        redirect_to controller: 'orders', action: 'show', id: order.id
    end

    def mark_delivered
        order_id = params.require(:order_id)
        order = Order.find(order_id)
        order.delivered = true
        if order.save
            flash[:success] = "Order Delivered Successfully"
            redirect_to orders_path
        else
            render :index
        end
    end

    def mark_not_delivered
        order_id = params.require(:order_id)
        order = Order.find(order_id)
        order.delivered = false
        if order.save
            flash[:success] = "Order marked as Not Delivered"
            redirect_to orders_path
        else
            render :index
        end
    end

    private
    def order_params
        params.require(:items)
    end

    def current_user_cart
        "cart#{current_user.id}"
    end
end