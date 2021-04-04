class Item < ApplicationRecord
    has_many :item_categories
    has_many :category, through: :item_categories
end
