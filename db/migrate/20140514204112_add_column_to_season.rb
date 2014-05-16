class AddColumnToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :torrent_link, :string
  end
end
