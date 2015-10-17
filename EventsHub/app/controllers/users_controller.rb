class UsersController < ApplicationController
  before_filter :require_logged_out, only: [:new, :create]
  before_filter :require_login, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]

  # GET /users
  def index
  end

  # GET /register or /users/new
  def new
    @user = User.new
  end

  # GET /profile or /users/[id]/edit
  def edit
    if current_user.is_administrator?
      if @user.nil?
        flash.now[:error] = 'User does not exist.'
      end
    elsif @user.id != current_user.id
      flash.now[:error] = 'You do not have permission to view this page.'
      redirect_to root
    end
  end

  def update
    unless current_user.is_administrator?
      if @user.id != current_user.id
        respond_to do |format|
          flash.now[:message] = 'There was an error while save the edits.'
          format.html { render edit  }
          format.json { render json: { :message => 'There was an error while saving the edits.' },
                               status: :unprocessable_entity }
        end
        return
      elsif !current_user.authenticate(params[:user][:old_password]) and !user_params[:password].blank?
        respond_to do |format|
          flash.now[:message] = 'The old password you provided is incorrect.'
          format.html { render 'edit' , flash }
          format.json { render json: { :message => 'The old password you provided is incorrect.' },
                               status: :unprocessable_entity }
        end
        return
      end
    end

    respond_to do |format|
      if @user.update(user_params)
        flash.now[:message] = 'Successfully edited.'
        format.html { render 'edit' , flash }
        format.json { render json: { :message => 'Successfully edited.' } }
      else
        flash.now[:message] = 'There was an error while save the edits.'
        format.html { render 'edit' , flash }
        format.json { render json: { :errors => @user.errors, :messages => @user.errors.full_messages},
                             status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save then
        login(@user) #Automatically log in the user
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

    def set_user
      @user = current_user
      if params[:id] # users can go to /profile as well
        @user = User.find_by(id: params[:id])
      end
    end
end
