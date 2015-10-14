class User < ActiveRecord::Base
  has_secure_password
  before_save { email.downcase! }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 5, maximum: 20 }

  # This regular expression checks for the presence of either: a number, a capital, or a symbol
  VALID_PASSWORD_REGEX = /((?=.*\d)|(?=.*[A-Z])|(?=.*[!@#\$%^&*()-_+={}\[\]|\\:;"'<,>.?\/~`]).)/
  validates :password, presence: true, length: { minimum: 8 }, on: :create,
            format: { with: VALID_PASSWORD_REGEX,
                      message: 'must contain either a digit, capital letter or a symbol.'}

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true #validate format?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 254 }

end
