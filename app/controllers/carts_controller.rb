class CartsController < ApplicationController
  before_action :require_login

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
    item = Item.find(params[:id])
    current = $redis.get "#{current_user_cart}#{params[:id]}"
    if (current.to_i + 1) > item.quantity
      flash[:notice] = "Can't order more than #{current} for now. Limited Stock!"
      redirect_to root_path
      return
    end
    $redis.set "#{current_user_cart}#{params[:id]}", current.to_i + 1
    redirect_to root_path
  end

  def decrease_quantity
    current = $redis.get "#{current_user_cart}#{params[:id]}"
    if current.to_i > 1
      $redis.set "#{current_user_cart}#{params[:id]}", current.to_i - 1
      redirect_to root_path
    end
  end
end
