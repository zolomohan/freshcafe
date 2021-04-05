class AddDeliveredToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :delivered, :boolean, default: false
  end
end
