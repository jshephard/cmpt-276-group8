module SessionsHelper
  # Will set @current_user if the user is logged in
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])

      if user.session_token.eql? cookies[:session_token]
        login(user)
        @current_user = user
      end
    end
  end

  # Creates a session for the user
  def login(user)
    session[:user_id] = user.id
  end

  # Creates cookies to remember the user
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:session_token] = user.session_token
  end

  def logged_in?
    !current_user.nil?
  end

  # Logs user out, deleting the session and cookies.
  def logout
    if logged_in?
      current_user.forget
      cookies.delete(:user_id)
      cookies.delete(:session_token)
      session.delete(:user_id)
      @current_user = nil
    end
  end
end
