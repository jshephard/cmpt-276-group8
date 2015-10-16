class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Includes basic functions like logged_in?, etc.
  include SessionsHelper

  def require_login
    unless logged_in?
      flash.now[:error] = 'You must be logged in to access this page.'
      redirect_to login_path
    end
  end

  def require_logged_out
    if logged_in?
      redirect_to root
    end
  end

  def require_promoter
    unless logged_in?
      flash.now[:error] = 'You must be logged in to access this page.'
      redirect_to login_path
    else
      unless current_user.is_promoter? or current_user.is_administrator?
        flash.now[:error] = 'You cannot access this page.'
        redirect_to root
      end
    end
  end

  def require_admin
    unless logged_in?
      flash.now[:error] = 'You must be logged in to access this page.'
      redirect_to login_path
    else
      unless current_user.is_administrator?
        flash.now[:error] = 'You cannot access this page.'
        redirect_to root
      end
    end
  end
end
