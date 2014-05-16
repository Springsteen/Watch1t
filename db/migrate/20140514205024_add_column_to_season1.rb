class AddColumnToSeason1 < ActiveRecord::Migration
  def change
    add_column :seasons, :subs_link, :string
  end
end
