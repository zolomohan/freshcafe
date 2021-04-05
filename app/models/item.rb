class Item < ApplicationRecord
    has_many :item_categories
    has_many :category, through: :item_categories
    has_one_attached :main_image
    
    def cart_action(current_user_id)
        if $redis.sismember "cart#{current_user_id}", id
            "Remove from"
        else
            "Add to"
        end
    end
end
