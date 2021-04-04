class ApplicationController < ActionController::Base
    helper_method :require_login, :require_admin
    def require_login
        if !user_signed_in?
          flash[:notice] = "You must be Logged in to perform this action."
          redirect_to login_path
        end
      end
  
      def require_admin
        if !current_user.admin?
          flash[:notice] = "You are not Authorized to perform this action."
          redirect_to root_path
        end
      end
end
