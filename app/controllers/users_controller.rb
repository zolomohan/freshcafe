class UsersController < ApplicationController
    before_action :require_login
    before_action :require_admin
    
    def index
        @users = User.all
    end

    private
    def set_user
        @user = User.find(params[:id])
    end
end
