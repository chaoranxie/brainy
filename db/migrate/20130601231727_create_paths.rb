class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :name
      t.string :creator
      t.date :created_at

      t.timestamps
    end
  end
end
