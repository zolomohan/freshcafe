class CreateOrderItem < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :item_id
      t.string :item_name
      t.integer :item_price
      t.integer :item_quantity
      t.timestamps
    end
  end
end
