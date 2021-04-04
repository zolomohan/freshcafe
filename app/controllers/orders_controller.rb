class OrdersController < ApplicationController
    def create
        order = Order.new(user: current_user)
        order.save
        order_items_data = JSON.parse(order_params)
        first = order_items_data[0]
        order_items_data.each do |item| 
            order_item = OrderItem.new(name: item["name"], price: item["price"], quantity: item["quantity"], order_id: order.id, item_id: item["id"])
            order_item.save
        end
        item_ids = $redis.smembers current_user_cart
        redis_keys = item_ids.map {|id| "#{current_user_cart}#{id}"}
        redis_keys.push(current_user_cart)
        debugger
        $redis.del(redis_keys)
        redirect_to cart_path
    end

    private
    def order_params
        params.require(:items)
    end

    def current_user_cart
        "cart#{current_user.id}"
    end
end