class AddProgramToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :program, :text
  end
end
