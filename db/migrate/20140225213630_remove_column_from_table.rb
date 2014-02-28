class RemoveColumnFromTable < ActiveRecord::Migration
  def change
    remove_column :users, :created_date, :datetime
  end
end
