module CartsHelper
    def clear_cart
        item_ids = $redis.smembers current_user_cart
        redis_keys = item_ids.map {|id| "#{current_user_cart}#{id}"}
        redis_keys.push(current_user_cart)
        $redis.del(redis_keys)
    end

    def current_user_cart
        "cart#{current_user.id}"
    end
end
