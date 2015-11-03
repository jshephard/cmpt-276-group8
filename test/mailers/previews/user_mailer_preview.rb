# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def validate_email
    UserMailer.validate_email(User.first)
  end

  def validate_password
    UserMailer.validate_password(User.first)
  end

  def new_password
    UserMailer.new_password(User.first, SecureRandom.urlsafe_base64)
  end
end
