class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :datetime
      t.string :description
      t.string :image_url
      t.integer :competition_id

      t.timestamps null: false
    end
  end
end
