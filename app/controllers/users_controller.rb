class UsersController < ApplicationController
  load_and_authorize_resource

  def create
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user.update_without_password(params[:user])

    if @user.valid?
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      format.js do
        @user.destroy

        @users = User.all

        render layout: false
      end
    end
  end
end