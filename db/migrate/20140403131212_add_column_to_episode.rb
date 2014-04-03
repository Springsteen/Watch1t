class AddColumnToEpisode < ActiveRecord::Migration
  def change
  	add_column :episodes, :episode, :integer
  end
end
