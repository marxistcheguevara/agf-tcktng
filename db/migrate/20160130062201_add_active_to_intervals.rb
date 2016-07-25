class AddActiveToIntervals < ActiveRecord::Migration
  def change
    add_column :intervals, :active, :boolean
  end
end
