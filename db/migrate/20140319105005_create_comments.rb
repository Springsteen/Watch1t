class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user, :limit => 10, :null =>false
      t.string :content, :null => false
      t.timestamps
    end
  end
end
