class AddColumnToComments < ActiveRecord::Migration
  def change
    remove_column :comments, :serie, :string
    add_column :comments, :serie_id, :integer
  end
end
