class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :sector_id
      t.integer :row
      t.integer :column
      t.integer :real_sector_id
      t.string :real_row
      t.integer :real_column

      t.timestamps null: false
    end
  end
end
