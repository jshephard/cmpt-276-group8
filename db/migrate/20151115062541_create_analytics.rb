class CreateAnalytics < ActiveRecord::Migration
  def change
    create_table :analytics do |t|

      t.timestamps null: false
    end
  end
end
