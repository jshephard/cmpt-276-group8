class UserMailer < ApplicationMailer
  def validate_email(user)
    @user = user
    @user.set_email_validation
    @url = validate_url + '?token=' + @user.email_validation_token
    mail(to: @user.email, subject: 'Welcome to the Events Hub!')
  end

  def validate_password(user)
    @user = user
    @user.set_password_validation
    @url = forget_url + '?token=' + @user.password_validation_token
    mail(to: @user.email, subject: 'Events Hub: Forgotten Password')
  end

  def new_password(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'Events Hub: New Password')
  end
end
