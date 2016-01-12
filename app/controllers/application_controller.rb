class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # For ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_user
  before_action :authenticate_user!

  private

  def check_user
    if cookies[:auth_token]
      unless current_user
        user = User.where(authentication_token: cookies[:auth_token]).first

        sign_in(:user, user)
      end
    else
      sign_out(:user)
    end
  end
end