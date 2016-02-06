class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # For ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_user

  private

  def check_user
    if cookies[:auth_token]
      user = User.where(authentication_token: cookies[:auth_token]).first
      sign_in(:user, user)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.all { render nothing: true, status: :forbidden }
      format.html { render file: "#{Rails.root}/public/403.html", status: 403, layout: false }
    end
  end
end