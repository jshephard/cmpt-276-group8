require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: 'john_doe123', password: '1password', password_confirmation: '1password',
                      email: 'john.doe@dotcom.com', first_name: 'John', last_name: 'Doe', date_of_birth: '1990-10-01')
  end

  test 'valid user can be saved' do
    assert @user.valid?
    assert @user.save
  end

  test 'no duplicate usernames' do
    dupe = @user.dup
    dupe.username = dupe.username.upcase
    dupe.email = 'dupe.john.doe@dotcom.com'
    @user.save
    assert dupe.invalid?
  end

  test 'no duplicate emails' do
    dupe = @user.dup
    dupe.username = 'dupe_john_doe_123'
    dupe.email = @user.email.upcase
    @user.save
    assert dupe.invalid?
  end

  test 'username presence' do
    @user.username = ' ' * 6
    assert @user.invalid?
  end

  test 'username below minimum length' do
    @user.username = 'a' * 4
    assert @user.invalid?
  end

  test 'username above maximum length' do
    @user.username = 'a' * 21
    assert @user.invalid?
  end

  test 'username becomes downcase after save' do
    username = 'JOHNDOE'
    @user.username = username.downcase
    @user.save
    assert_equal username.downcase, @user.reload.username
  end
  
  test 'username may only contain a-zA-Z0-9 and -_' do
    @user.username = 'John Doe'
    assert @user.invalid?
    @user.username = 'john$doe'
    assert @user.invalid?
    @user.username = 'john!doe'
    assert @user.invalid?
    @user.username = 'john\ndoe'
    assert @user.invalid?
  end

  test 'password presence' do
    @user.password = ' ' * 8
    assert @user.invalid?
  end

  test 'password below minimum length' do
    @user.password = 'a1b2Ac#'
    assert @user.invalid?
  end

  test 'invalid password formats' do
    @user.password = 'abcabcbac'
    @user.password_confirmation = @user.password
    assert @user.invalid?
  end

  test 'valid password formats' do
    @user.password = '1abcdefg'
    @user.password_confirmation = @user.password
    assert @user.valid?
    @user.password = '@abcdefg'
    @user.password_confirmation = @user.password
    assert @user.valid?
    @user.password = 'Aabcdefg'
    @user.password_confirmation = @user.password
    assert @user.valid?
  end

  test 'email presence' do
    @user.email = ' ' * 6
    assert @user.invalid?
  end

  test 'invalid email formats' do
    @user.email = 'in#vali$d@email'
    assert @user.invalid?
    @user.email = 'invalid@email'
    assert @user.invalid?
    @user.email = '@email.com'
    assert @user.invalid?
    @user.email = '.com'
    assert @user.invalid?
    @user.email = '@.'
    assert @user.invalid?
  end

  test 'valid email formats' do
    @user.email = 'john.doe@emai.com'
    assert @user.valid?
    @user.email = 'johndoe123@emai.com'
    assert @user.valid?
    @user.email = 'jd@dotcom.com'
    assert @user.valid?
  end

  test 'email becomes downcase after save' do
    email = 'AaBbCc.123@gMaIl.CoM'
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.reload.email
  end

  test 'first name presence' do
    @user.first_name = ' ' * 6
    assert @user.invalid?
  end

  test 'last name presence' do
    @user.last_name = ' ' * 6
    assert @user.invalid?
  end

  test 'date of birth presence' do
    @user.date_of_birth = ' ' * 6
    assert @user.invalid?
  end
end
