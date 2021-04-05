class OrdersController < ApplicationController
    def index
        @orders = Order.all
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
        redirect_to orders_path(order.id)
    end

    private
    def order_params
        params.require(:items)
    end

    def current_user_cart
        "cart#{current_user.id}"
    end
end