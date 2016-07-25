class AddProgramToEvent < ActiveRecord::Migration
  def change
    add_column :events, :program, :text
  end
end
