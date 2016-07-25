class AddNameSurnameToCashiers < ActiveRecord::Migration
  def change
    add_column :cashiers, :name, :string
    add_column :cashiers, :surname, :string
  end
end
