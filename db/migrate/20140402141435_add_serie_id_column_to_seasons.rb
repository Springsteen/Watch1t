class AddSerieIdColumnToSeasons < ActiveRecord::Migration
  def change
  	add_column :seasons, :serie_id, :integer
  	add_column :seasons, :season, :integer
  end
end
