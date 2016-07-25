class ChangeIntervals < ActiveRecord::Migration
  def change
    remove_column :intervals, :event_id
    add_column :intervals, :interval_number, :integer
  end
end
