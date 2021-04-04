class OrdersController < ApplcationController
    def create
        @order = Order.new(order_params)
        
    end

    private
    def order_params
        
    end
end