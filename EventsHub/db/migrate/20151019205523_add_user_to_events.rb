class AddUserToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :user, index: true
    end
  end
end
