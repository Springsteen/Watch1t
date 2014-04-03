class AddSeasonIdColumnToEpisodes < ActiveRecord::Migration
  def change
  	add_column :episodes, :season_id, :integer
  	add_column :episodes, :episode, :integer
  end
end
