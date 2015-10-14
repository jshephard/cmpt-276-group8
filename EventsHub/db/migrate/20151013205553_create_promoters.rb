class CreatePromoters < ActiveRecord::Migration
  def change
    create_table :promoters do |t|
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
