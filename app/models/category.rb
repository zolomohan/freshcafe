class Category < ApplicationRecord
    has_many :item_categories
    has_many :items, through: :item_categories
    has_one_attached :main_image
end
