json.extract! item, :id, :name, :price, :description, :created_at, :updated_at
json.url item_url(item, format: :json)
