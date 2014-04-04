class AddColumnToComments1 < ActiveRecord::Migration
  def change
    remove_column :comments, :episode, :integer
    add_column :comments, :episode_id, :integer
    remove_column :comments, :season, :integer
    add_column :comments, :season_id, :integer
  end
end
