class CartsController < ApplicationController
  before_action :require_login

  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_items = Item.find(cart_ids)
    @quantities = cart_ids.map {|item| $redis.get current_user_cart+item}
    @items = cart_ids.each_with_index.map {|id, index| {:item => @cart_items[index], :quantity => @quantities[index]} }
  end

  def add
    $redis.sadd current_user_cart, params[:id]
    $redis.set "#{current_user_cart}#{params[:id]}", 1
    redirect_to root_path
  end

  def remove
    $redis.srem current_user_cart, params[:id]
    redirect_to root_path
  end

  def increase_quantity
    current = $redis.get "#{current_user_cart}#{params[:id]}"
    $redis.set "#{current_user_cart}#{params[:id]}", current.to_i + 1
    redirect_to cart_path
  end

  def decrease_quantity
    current = $redis.get "#{current_user_cart}#{params[:id]}"
    if current.to_i > 0
      $redis.set "#{current_user_cart}#{params[:id]}", current.to_i - 1
      redirect_to cart_path
    end
  end

  private
  def current_user_cart
    "cart#{current_user.id}"
  end
end
