class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name
      t.string :class_name
      t.string :identificator

      t.timestamps null: false
    end
  end
end
