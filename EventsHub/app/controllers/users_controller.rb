class UsersController < ApplicationController
  #before_filter :require_admin, only: [:edit]

  # GET /users
  def index
  end

  # GET /register or /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save then
      render 'index'
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :first_name, :last_name,
                                   :date_of_birth, :email)
    end
end
