class AddEventToInterval < ActiveRecord::Migration
  def change
    add_column :intervals, :event_id, :integer
  end
end
