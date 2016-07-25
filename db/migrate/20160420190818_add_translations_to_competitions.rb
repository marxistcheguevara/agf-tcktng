class AddTranslationsToCompetitions < ActiveRecord::Migration
  def up
    Competition.create_translation_table! :name => :string, :program => :text
  end
  def down
    Competition.drop_translation_table!
  end
end