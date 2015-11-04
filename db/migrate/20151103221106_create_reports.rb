class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :users, index: true, foreign_key: true
      t.references :events, index: true, foreign_key: true
      t.text :description

      t.timestamps null: false
    end
  end
end
