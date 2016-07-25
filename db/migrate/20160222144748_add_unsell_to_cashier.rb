class AddUnsellToCashier < ActiveRecord::Migration
  def change
    add_column :cashiers, :unsell, :boolean
  end
end
