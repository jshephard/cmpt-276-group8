class UsersController < ApplicationController
  before_filter :require_logged_out, only: [:new, :create, :forgot_password, :request_password]
  before_filter :require_logged_out, only: [:forgot_password, :request_password], unless: :require_admin
  before_filter :require_login, only: [:edit, :update, :destroy]
  before_filter :require_admin, only: [:index]
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  before_action :set_page, only: [:index]

  # GET /users
  def index
    if request.format.json?
      @users = User.page(@page)
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
        redirect_to users_path, alert: 'User does not exist.'
      end
    elsif @user.id != current_user.id
      redirect_to root_path, alert: 'You do not have permission to view this page.'
    end
  end

  # PATCH/PUT /users/[id]
  def update
    promoter_save = true
    admin_save = true

    if current_user.is_administrator?
      # Update promoter status
      if params[:user][:is_promoter] == '1'
        unless @user.is_promoter?
          promoter = Promoter.new(user_id: @user.id)
          promoter_save = promoter.save()
        end
      elsif params[:user][:is_promoter] == '0'
        Promoter.where(user_id: @user.id).destroy_all
      end

      # Update administrator status
      if params[:user][:is_administrator] == '1'
        if !@user.is_administrator?
          admin = Administrator.new(user_id: @user.id)
          admin_save = admin.save()
        end
      elsif params[:user][:is_administrator] == '0' and @user.id != current_user.id
        # Administrators cannot remove themselves from power
        Administrator.where(user_id: @user.id).destroy_all
      end

      # Update email validation status
      if params[:user][:is_validated] == '1'
        @user.reset_email_validation
      elsif params[:user][:is_validated] == '0'
        @user.set_email_validation
        UserMailer.validate_email(@user).deliver_now
      end
    else
      if @user.id != current_user.id
        respond_to do |format|
          format.html { redirect_to root_path, alert: 'You do not have permission to view this page.'  }
          format.json { render json: { :message => 'You do not have permission to view this page.' },
                               status: :unprocessable_entity }
        end
        return
      elsif !current_user.authenticate(params[:user][:old_password]) and !user_params[:password].blank?
        respond_to do |format|
          flash.now[:alert] = 'The old password you provided is incorrect.'
          format.html { render 'edit' }
          format.json { render json: { :message => 'The old password you provided is incorrect.' },
                               status: :unprocessable_entity }
        end
        return
      end
    end

    respond_to do |format|
      if @user.update(user_params) and promoter_save and admin_save
        flash.now[:notice] = 'Successfully edited.'
        format.html { render 'edit' }
        format.json { render json: { :message => 'Successfully edited.' } }
      else
        flash.now[:alert] = 'There was an error while saving the edits.'
        format.html { render 'edit' }
        format.json { render json: { :errors => @user.errors, :messages => @user.errors.full_messages},
                             status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.validate_email(@user).deliver_now

        login(@user) #Automatically log in the user
        format.html { redirect_to root_path, notice: 'User successfully created.' }
        format.json { render json: { :message => 'User successfully created', :redirect => root_path } }
      else
        flash.now[:alert] = 'There was an error signing up.'
        format.html { render 'new' }
        format.json { render json: { :errors => @user.errors, :messages => @user.errors.full_messages},
                             status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id
  def destroy
    message = ''
    path = root_path
    fail = false
    if current_user.is_administrator?
      # Administrators cannot delete their own accounts
      if @user.id == current_user.id
        message = 'Administrators cannot delete their own accounts.'
        path = users_path
        fail = true
      end
    else
      # Normal users can delete their account
      if @user.id == current_user.id
        logout
      else
        message = 'You do not have permission to view this page.'
        fail = true
      end
    end

    if fail
      respond_to do |format|
        format.html { redirect_to path, alert: message }
        format.json { render json: { :message => message, :redirect => path  } }
      end
    else
      @user.destroy

      # Use proper route
      if logged_in? and current_user.is_administrator?
        path = users_path
      end

      respond_to do |format|
          format.html { redirect_to path, notice: 'User was successfully deleted.' }
          format.json { render json: { :message => 'User was successfully deleted.', :redirect => path  } }
      end
    end
  end

  def forgot_password
    if params[:token]
      @user = User.find_by(password_validation_token: params[:token])

      respond_to do |format|
        # Check if the password reset email has not timed out
        if @user and @user.password_validation_timeout > DateTime.now and @user.password_validation_token != ''
          password = SecureRandom.urlsafe_base64[0..10]
          @user.password = password
          if @user.save
            UserMailer.new_password(@user, password).deliver_now
            @user.reset_password_validation
            format.html { redirect_to root_path, notice: 'Sent an email containing the new password for the account.' }
            format.json { render json: { :message => 'Sent an email containing the new password for the account.' }  }
          else
            format.html { render 'forgot_password', notice: 'Error occurred while resetting password.' }
            format.json { render json: { :message => 'Error occurred while resetting password.'},
                                 status: :unprocessable_entity  }
          end
        else
          format.html { render 'forgot_password', notice: 'Link out of date.' }
          format.json { render json: { :message => 'Link out of date.'}, status: :unprocessable_entity  }
        end
      end
    end
  end

  def request_password
    @user = User.find_by(email: params[:email])

    respond_to do |format|
      if @user
        UserMailer.validate_password(@user).deliver_now
        format.html { render 'forgot_password', notice: 'Sent an email containing a link to reset your password.' }
        format.json { render json: { :message => 'Sent an email containing a link to reset your password.' }  }
      else
        format.html { render 'forgot_password', notice: 'No account associated with this email.' }
        format.json { render json: { :message => 'No account associated with this email.'}, status: :unprocessable_entity  }
      end
    end
  end

  def validate_email
    @user = User.find_by(email_validation_token: params[:token])

    respond_to do |format|
      if @user
        @user.reset_email_validation
        format.html { redirect_to root_path, notice: 'Email was successfully validated.' }
        format.json { render json: { :message => 'Email was successfully validated.', :redirect => root_path  } }
      else
        format.html { redirect_to root_path, notice: 'Validation link invalid.' }
        format.json { render json: { :message => 'Validation link invalid.', :redirect => root_path  },
                             status: :unprocessable_entity }
      end
    end
  end

  def show
    if !@user.nil?
      #Retrieve latest 5 events posted by user
      @events = Event.where(user_id: @user.id).where('"EndDate" > ?', DateTime.now)

      if !logged_in?
        # Only show public events to guests
        @events = @events.where('"id_private" = ?', false).order(:created_at).limit(5)
      elsif current_user.is_administrator? or @user.id == current_user.id
        # Show all events to administrators and the user itself
        @events = @events.order(:created_at).limit(5)
      else
        # Only show private events to friends
        @events = @events.where('"id_private" = ?', false)

        # Show private events for friends
        @events = @events.union(Event.where(user_id: @user.id).joins('INNER JOIN "friendships" ON "friendships"."approved" = \'t\' AND "friendships"."user_id" = ' + current_user.id.to_s).
              where('"friendships"."user_id" = "events"."user_id" OR "friendships"."friend_id" = "events"."user_id"').
              where('"id_private" = ?', true))
        @events = @events.union(Event.where(user_id: @user.id).joins('INNER JOIN "friendships" ON "friendships"."approved" = \'t\' AND "friendships"."user_id" = "events"."user_id"').
              where('"friendships"."user_id" = ? OR "friendships"."friend_id" = ?', current_user.id, current_user.id).
              where('"id_private" = ?', true))

        @events = @events.order(:created_at).limit(5)
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

    def require_admin
      logged_in? && current_user.is_administrator?
    end
end
