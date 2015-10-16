class SessionsController < ApplicationController
  # GET /login
  def new
    if logged_in?
      redirect_to users_path
    end
  end

  # POST /login
  def create
    user = User.find_by(username: session_params[:username].downcase)

    if user && user.authenticate(session_params[:password])
      if session_params[:remember_me]
        remember(user)
      end
      login(user)

      redirect_to users_path
    else
      flash.now[:error] = 'Username and/or password is incorrect.'
      render 'new'
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
