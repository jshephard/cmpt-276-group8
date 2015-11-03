class AddValidationTimeoutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_validation_timeout, :datetime
  end
end
