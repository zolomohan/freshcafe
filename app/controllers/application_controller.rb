class ApplicationController < ActionController::Base
  helper_method :require_login, :require_admin, :require_clerk, :current_user_cart, :get_cart_items

  def get_cart_items
    cart_ids = $redis.smembers current_user_cart
    @cart_items = Item.find(cart_ids)
    @quantities = cart_ids.map {|item| $redis.get current_user_cart+item}
    @items = cart_ids.each_with_index.map {|id, index| {:item => @cart_items[index], :quantity => @quantities[index]} }
  end

  def require_login
    if !user_signed_in?
      flash[:notice] = "You must be Logged in to perform this action."
      redirect_to login_path
    end
  end

  def require_clerk
    if !current_user.admin? && !current_user.clerk?
      flash[:notice] = "You are not Authorized to perform this action."
      redirect_to root_path
    end
  end

  def require_admin
    if !current_user.admin?
      flash[:notice] = "You are not Authorized to perform this action."
      redirect_to root_path
    end
  end

  def current_user_cart
    "cart#{current_user.id}"
  end
end
