class AddColumnToSeries < ActiveRecord::Migration
  def change
    # add_column :table_name, :column_name, :column_type
    add_column :series, :torrent, :string, :limit => 200
  end
end
