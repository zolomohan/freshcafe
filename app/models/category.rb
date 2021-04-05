class Category < ApplicationRecord
    has_many :item_categories
    has_many :items, through: :item_categories
    has_one_attached :main_image

    validates :name, presence: true, length: {minimum: 3, maximum: 20}
    validates :main_image, presence: true
end
