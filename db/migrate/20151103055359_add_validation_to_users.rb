class AddValidationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_validation_token, :string
    add_column :users, :email_validation_token, :string
  end
end
