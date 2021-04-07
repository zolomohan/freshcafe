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
        order_items_data = JSON.parse(order_params)
        items_valid_messages = helpers.are_items_valid(order_items_data)
        if items_valid_messages.count != 0
            flash[:list] = items_valid_messages
            redirect_to root_path
        else
            order = Order.new(user: current_user, user_email: current_user.email)
            order.save

            total_price = 0
            order_items_data.each do |item| 
                item_db = Item.find(item["id"])
                item_db.quantity = item_db.quantity - item["quantity"].to_i
                item_db.save
                total_price = total_price + (item_db.price * item["quantity"].to_i)
                order_item = OrderItem.new(name: item_db.name, price: item_db.price, quantity: item["quantity"], order_id: order.id, item_id: item["id"])
                order_item.save
            end

            order.total_price = total_price
            order.save

            helpers.clear_cart
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
end