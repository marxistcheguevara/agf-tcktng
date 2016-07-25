class FixSeatColumns < ActiveRecord::Migration
  def change
    change_column :seats, :real_row, :string
    change_column :seats, :real_column, :string
    change_column :seats, :real_sector_id, :string
  end
end
