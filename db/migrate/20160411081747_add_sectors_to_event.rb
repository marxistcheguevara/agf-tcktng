class AddSectorsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :sectors, :string
  end
end
