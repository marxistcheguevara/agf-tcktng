class AddDatetimeToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :datetime, :datetime
  end
end
