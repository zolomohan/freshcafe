class AddActiveToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :active, :boolean, default: true
  end
end
