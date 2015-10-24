class SessionsController < ApplicationController
  before_filter :require_logged_out, except: [:destroy]
  before_filter :require_login, only: [:destroy]

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by(username: session_params[:username].downcase)

    if user && user.authenticate(session_params[:password])
      if session_params[:remember_me]
        remember(user)
      end
      login(user)

      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Logged in successfully.' }
        format.json { render :json => { :redirect => root_path, :message => 'Logged in successfully.' } }
      end
    else
      flash.now[:alert] = 'Username and/or password is incorrect.'
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: { :message => flash.now[:alert] }, status: :unprocessable_entity }
      end
    end
  end

  # GET /logout
  def destroy
    logout
    redirect_to login_path
  end

  private
    def session_params
      params.require(:session).permit(:username, :password, :remember_me)
    end
end
