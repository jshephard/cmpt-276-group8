class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Includes basic functions like logged_in?, etc.
  include SessionsHelper

  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'You must be logged in to access this page.'
    end
  end

  def require_logged_out
    if logged_in?
      redirect_to root_path
    end
  end

  def require_promoter
    unless logged_in?
      redirect_to login_path, alert: 'You must be logged in to access this page.'
    else
      unless current_user.is_promoter? or current_user.is_administrator?
        redirect_to root_path, alert: 'You cannot access this page.'
      end
    end
  end

  def require_admin
    unless logged_in?
      redirect_to login_path, alert: 'You must be logged in to access this page.'
    else
      unless current_user.is_administrator?
        redirect_to root_path, alert: 'You cannot access this page.'
      end
    end
  end

  def require_verified
    if logged_in?
      if !current_user.is_validated?
        redirect_to root_path, alert: 'You must verify your email address before accessing this page.'
      end
    else
      redirect_to login_path, alert: 'You must be logged in to access this page.'
    end
  end

  def set_page
    @page = params[:page].nil? ? 1 : params[:page]
  end
end
