class AddAddressToEvents < ActiveRecord::Migration
  def change
    add_column :events, :Address, :string
  end
end
