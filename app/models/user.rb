class User < ActiveRecord::Base
  # Don't use these directly. Instead, call is_admin? or is_promoter?
  # Used to avoid hitting DB multiple times
  attr_accessor :admin, :promoter
  
  # has_one only requires to actually have one if validated. We only want this so that if a user is deleted
  # their entries within those tables are deleted as well.
  has_one :promoter, dependent: :destroy
  has_one :administrator, dependent: :destroy
  has_many :events
  has_many :reports, dependent: :destroy
  
  #friendship stuff :)
  has_many :friendships
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :active_friends, -> { where(friendships: { approved: true}) }, :through => :friendships, :source => :friend
  has_many :passive_friends, -> { where(friendships: { approved: true}) }, :through => :passive_friendships, :source => :user
  has_many :pending_friends, -> { where(friendships: { approved: false}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { approved: false}) }, :through => :passive_friendships, :source => :user

  has_secure_password
  before_save { email.downcase! }
  before_save { username.downcase! }
  
  # Username may only contain a-z,0-9, - and _
  VALID_USERNAME_REGEX = /\A[a-z0-9\-_]+\z/i
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 5, maximum: 20 },
            format: { with: VALID_USERNAME_REGEX, message: 'may only contain letters, numbers, - and _.' }

  # This regular expression checks for the presence of either: a number, a capital, or a symbol
  VALID_PASSWORD_REGEX = /((?=.*\d)|(?=.*[A-Z])|(?=.*[!@#\$%^&*()-_+={}\[\]|\\:;"'<,>.?\/~`]).)/
  validates :password, presence: true, length: { minimum: 8 }, on: :create, format: { with: VALID_PASSWORD_REGEX,
                      message: 'must contain either a digit, a capital letter or a symbol.'}
  # This validates when a user attempts to update their profile. Here, if the password is blank it doesn't update.
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

  # Gotta make some friends
  def friends
    active_friends | passive_friends
  end
  
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

  def set_email_validation
    self.email_validation_token = SecureRandom.urlsafe_base64
    update_attribute(:email_validation_token, email_validation_token)
  end

  def reset_email_validation
    self.email_validation_token = ''
    update_attribute(:email_validation_token, email_validation_token)
  end

  def is_validated?
    (email_validation_token == '' || email_validation_token == nil)
  end

  def set_password_validation
    self.password_validation_token = SecureRandom.urlsafe_base64
    self.password_validation_timeout = 3.days.from_now
    update_attribute(:password_validation_token, password_validation_token)
  end

  def reset_password_validation
    self.password_validation_token = ''
    update_attribute(:password_validation_token, password_validation_token)
  end
end
