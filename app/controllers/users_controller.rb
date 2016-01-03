class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def create
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def update
    @user.update_attributes(params[:user])

    if @user.valid?
      redirect_to users_path
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