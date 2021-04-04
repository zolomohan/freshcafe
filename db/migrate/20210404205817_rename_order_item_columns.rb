class RenameOrderItemColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :order_items, :item_name, :name
    rename_column :order_items, :item_quantity, :quantity
    rename_column :order_items, :item_price, :price
  end
end
