class UsersController < ApplicationController
    before_action :set_user_post, except: [:index, :show]
    before_action :set_user, only: [:show]
    before_action :require_login
    before_action :require_admin, except: [:show]
    
    def index
        @users = User.all
    end

    def show
        @user_orders = @user.orders.paginate(page: params[:page], per_page: 12)
    end

    def make_admin
        @user.admin = true
        @user.clerk = true
        if @user.save
            flash[:success] = "#{@user.email} is an admin."
            redirect_to users_path
        else
            render :index
        end
    end

    def remove_admin
        @user.admin = false
        if @user.save
            flash[:success] = "#{@user.email} is not an admin anymore."
            redirect_to users_path
        else
            render :index
        end
    end

    def make_clerk
        @user.clerk = true
        if @user.save
            flash[:success] = "#{@user.email} is an admin."
            redirect_to users_path
        else
            render :index
        end
    end

    def remove_clerk
        @user.clerk = false
        if @user.save
            flash[:success] = "#{@user.email} is not an admin anymore."
            redirect_to users_path
        else
            render :index
        end
    end

    private
    def set_user
        @user = User.find(params[:id])
    end

    def set_user_post
        @user = User.find(params.require(:id))
    end

end
