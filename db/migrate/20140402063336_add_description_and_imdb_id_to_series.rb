class AddDescriptionAndImdbIdToSeries < ActiveRecord::Migration
  def change
  	add_column :series, :description, :text
  	add_column :series, :imdb_id, :integer
  end
end
