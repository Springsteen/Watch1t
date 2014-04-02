class AddSerieIdColumnToSeasons < ActiveRecord::Migration
  def change
  	add_column :seasons, :serie_id, :integer
  end
end
