module OrdersHelper
    def are_all_items_valid(items)
        are_valid = true
        items.each do |item|
            item_db = Item.find(item["id"])

            if item_db.quantity < item["quantity"].to_i
                are_valid = false
            end

            if !item_db.active
                are_valid = false
                break
            end

            item_db.category.each do |category|
                if !category.active
                    are_valid = false
                    break
                end
            end

            if !are_valid
                break
            end
        end
    end
end