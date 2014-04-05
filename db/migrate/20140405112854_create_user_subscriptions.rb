class CreateUserSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.integer :user_id, :null =>false
      t.integer :serie, :null=>false
      t.timestamps
    end
  end
end
