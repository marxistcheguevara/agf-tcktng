class AddIsActivetoEvent < ActiveRecord::Migration
  def change
    add_column :events, :IsActive, :boolean
  end
end
