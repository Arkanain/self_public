class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    user = warden.authenticate!(auth_options)
    sign_in(:user, user)

    cookies[:auth_token] = current_user.authentication_token

    redirect_to root_path
  end

  # DELETE /resource/sign_out
  def destroy
    cookies.delete(:auth_token)

    sign_out(:user)

    redirect_to root_path
  end
end
