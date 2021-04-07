class OrdersController < ApplicationController
    before_action :require_login
    before_action :require_clerk, only: [:index, :pending, :mark_delivered, :mark_not_delivered]
    before_action :require_admin, only: [:report]

    def index
        @delivered_orders = Order.where(delivered: true).paginate(page: params[:page], per_page: 10)
    end

    def pending
        @pending_orders = Order.where(delivered: false).paginate(page: params[:page], per_page: 10)
    end

    def report
        if !params[:from] || !params[:to]
            @orders = []
        else
            @from = Date.strptime(params[:from], '%Y-%m-%d')
            @to = Date.strptime(params[:to], '%Y-%m-%d')
            @orders = Order.where(created_at: @from..@to).paginate(page: params[:page], per_page: 10)
        end
    end

    def show
        @order = Order.find(params[:id])
    end

    def create
        order = Order.new(user: current_user, user_email: current_user.email)
        order_items_data = JSON.parse(order_params)
        order.total_price = order_items_data.reduce(0) {|sum, item| sum + (item["price"] * item["quantity"].to_i) }
        
        # Check for Invalid Items
        are_all_items_valid = true
        order_items_data.each do |item|
            item_db = Item.find(item["id"])
            if !item_db.active
                are_all_items_valid = false
                break
            end

            item_db.category.each do |category|
                if !category.active
                    are_all_items_valid = false
                    break
                end
            end

            if !are_all_items_valid
                break
            end
        end

        if !are_all_items_valid
            flash[:notice] = "Some Items in your cart are not availble."
            redirect_to root_path
        else
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
    end

    def mark_delivered
        order_id = params.require(:order_id)
        order = Order.find(order_id)
        order.delivered = true
        if order.save
            flash[:success] = "Order Delivered Successfully"
            redirect_to ontroller: 'orders', action: 'show', id: order.id
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
            redirect_to ontroller: 'orders', action: 'show', id: order.id
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