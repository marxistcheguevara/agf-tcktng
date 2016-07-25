class AddPermissionsToCashiers < ActiveRecord::Migration
  def change
    add_column :cashiers, :sell, :boolean
    add_column :cashiers, :bron, :boolean
    add_column :cashiers, :invitation, :boolean
    add_column :cashiers, :discount, :boolean
  end
end
