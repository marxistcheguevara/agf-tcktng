class AddIsActivetoCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :IsActive, :boolean
  end
end
