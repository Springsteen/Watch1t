class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	  t.string :user, :limit => 10, :null =>false
	  t.binary :password, :null =>false
	  t.string :email, :null =>false
	  t.boolean :email_check, :null =>false
	  t.string :secret_question, :null =>false
	  t.string :secret_answer, :null=>false
	  t.string :skype
	  t.string :country
	  t.datetime :created_date, :null =>false
	  t.integer :block_code, :null =>false
      t.timestamps
    end
  end
end
