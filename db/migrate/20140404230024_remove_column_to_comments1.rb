class RemoveColumnToComments1 < ActiveRecord::Migration
  def change
    remove_column :comments, :epizode, :integer
    remove_column :comments, :season, :integer
  end
end
