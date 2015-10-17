class UsersController < ApplicationController
  before_filter :require_logged_out, only: [:new, :create]
  before_filter :require_login, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]

  # GET /users
  def index
    if logged_in? and current_user.is_administrator?
      page = params[:page].nil? ? 1 : params[:page]
      @users = User.page(page)
    end
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
        redirect_to users_path
      end
    elsif @user.id != current_user.id
      flash.now[:error] = 'You do not have permission to view this page.'
      redirect_to root
    end
  end

  # PATCH/PUT /users/[id]
  def update
    promoter_save = true
    admin_save = true

    unless current_user.is_administrator?
      if @user.id != current_user.id
        respond_to do |format|
          flash.now[:message] = 'You do not have permission to view this page.'
          format.html { render edit  }
          format.json { render json: { :message => 'You do not have permission to view this page.' },
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
    else
      if params[:user][:is_promoter] == '1'
        if !@user.is_promoter?
          promoter = Promoter.new(user_id: @user.id)
          promoter_save = promoter.save()
        end
      elsif params[:user][:is_promoter] == '0'
        Promoter.where(user_id: @user.id).destroy_all
      end

      if params[:user][:is_administrator] == '1'
        if !@user.is_administrator?
          admin = Administrator.new(user_id: @user.id)
          admin_save = admin.save()
        end
      elsif params[:user][:is_administrator] == '0' and @user.id != current_user.id
        # Administrators cannot remove themselves from power
        Administrator.where(user_id: @user.id).destroy_all
      end
    end

    respond_to do |format|
      if @user.update(user_params) and promoter_save and admin_save
        flash.now[:message] = 'Successfully edited.'
        format.html { render 'edit' , flash }
        format.json { render json: { :message => 'Successfully edited.' } }
      else
        flash.now[:message] = 'There was an error while saving the edits.'
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

    # Used to set @user for some of the functions that require it
    def set_user
      @user = current_user
      if params[:id] # users can go to /profile as well
        @user = User.find_by(id: params[:id])
      end
    end
end
