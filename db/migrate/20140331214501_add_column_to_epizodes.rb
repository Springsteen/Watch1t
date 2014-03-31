class AddColumnToEpizodes < ActiveRecord::Migration
  def change
  
    add_column :episodes, :torrent, :string, :limit => 200
  end
end
