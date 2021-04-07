module OrdersHelper
    def are_items_valid(items)
        error_messages = []
        items.each do |item|
            item_db = Item.find(item["id"])
            if !item_db.active
                error_messages.push("#{item_db.name} is not avalable")
            end

            if item_db.quantity < item["quantity"].to_i
                error_messages.push("Only #{pluralize(item_db.quantity, item_db.name)} #{item_db.quantity > 1 ? "are" : "is"} availble.")
            end

            item_db.category.each do |category|
                if !category.active
                    error_messages.push("#{item_db.name} is not avalable")
                    break
                end
            end
        end
        error_messages
    end
end