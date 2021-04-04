class AddPermissionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :clerk, :boolean, default: false
  end
end
