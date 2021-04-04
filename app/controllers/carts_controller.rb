class CartsController < ApplicationController
  before_action :require_login

  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_items = Item.find(cart_ids)
  end

  def add
    $redis.sadd current_user_cart, params[:id]
    redirect_to root_path
  end

  def remove
    $redis.srem current_user_cart, params[:id]
    redirect_to root_path
  end

  private
  def current_user_cart
    "cart#{current_user.id}"
  end
end
