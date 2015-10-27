class ChangeDescriptionsToText < ActiveRecord::Migration
  def self.up
    change_column :events, :Description, :text
  end
  
  def self.down
    change_column :events, :Description, :string
  end
end
