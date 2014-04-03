class AddColumnToSeasons < ActiveRecord::Migration
  def change
    add_column :episodes, :torrent_link, :string
  	add_column :episodes, :subs_link, :string
  end
end
