class Item < ApplicationRecord
    has_many :item_categories
    has_many :category, through: :item_categories
    has_one_attached :main_image

    validates :main_image, presence: true
    validates :name, presence: true, length: {minimum: 3, maximum: 30}
    validates :description, presence: true
    validates :price, presence: true
    
    def cart_action(current_user_id)
        if $redis.sismember "cart#{current_user_id}", id
            "Remove from"
        else
            "Add to"
        end
    end
end
