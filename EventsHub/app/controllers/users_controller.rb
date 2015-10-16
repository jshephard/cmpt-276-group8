class UsersController < ApplicationController
  #before_filter :require_admin, only: [:edit]
  before_filter :require_logged_out, only: [:new, :create]

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

    respond_to do |format|
      if @user.save then
        flash.now[:message] = 'User successfully created.'
        format.html { render 'index' , flash }
        format.json { render json: { :message => 'User successfully created', :redirect => users_path } }
      else
        flash.now[:message] = 'There was an error signing up.'
        format.html { render 'new' , flash }
        format.json { render json: { :errors => @user.errors, :messages => @user.errors.full_messages},
                             status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :first_name, :last_name,
                                   :date_of_birth, :email)
    end
end
