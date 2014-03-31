class AddColumnToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :torrent, :string, :limit => 200
  end
end
