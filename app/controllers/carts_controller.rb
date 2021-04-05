class CartsController < ApplicationController
  before_action :require_login

  def show
    get_cart_items
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
end
