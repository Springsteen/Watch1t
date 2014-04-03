class AddColumnToSeason < ActiveRecord::Migration
  def change
  	add_column :seasons, :season, :integer
  end
end
