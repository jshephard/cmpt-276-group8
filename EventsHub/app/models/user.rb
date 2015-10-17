class User < ActiveRecord::Base
  # Don't use these directly. Instead, call is_admin? or is_promoter?
  # Used to avoid hitting DB multiple times
  attr_accessor :admin, :promoter

  has_secure_password
  before_save { email.downcase! }
  before_save { username.downcase! }
  # Todo valid username regex (i.e. only a-zA-Z0-9, - and _)
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 5, maximum: 20 }

  # This regular expression checks for the presence of either: a number, a capital, or a symbol
  VALID_PASSWORD_REGEX = /((?=.*\d)|(?=.*[A-Z])|(?=.*[!@#\$%^&*()-_+={}\[\]|\\:;"'<,>.?\/~`]).)/
  validates :password, presence: true, length: { minimum: 8 }, on: :create, format: { with: VALID_PASSWORD_REGEX,
                      message: 'must contain either a digit, a capital letter or a symbol.'}
  validates :password, length: { minimum: 8 }, on: :update, allow_blank: true,
            format: { with: VALID_PASSWORD_REGEX, message: 'must contain either a digit, a capital letter or a symbol.'}

  #todo some more validations here, e.g. maximum length
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true #todo validate format?

  #Regex from http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
  VALID_EMAIL_REGEX = /.+@.+\..+/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 254 }

  # Creates a session token that will help remember the current session
  def remember
    self.session_token = SecureRandom.urlsafe_base64
    update_attribute(:session_token, session_token)
  end

  # Forgets the session token
  def forget
    update_attribute(:session_token, nil)
  end

  def is_promoter?
    # Avoid hitting DB multiple times using ||= which only sets if promoter is nil
    self.promoter ||= Promoter.find_by(user_id: id)
    return !self.promoter.nil?
  end

  def is_administrator?
    # Avoid hitting DB multiple times using ||= which only sets if admin is nil
    self.admin ||= Administrator.find_by(user_id: id)
    return !self.admin.nil?
  end
end
