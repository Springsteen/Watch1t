class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.string :title
    	t.string :episodes
    	t.timestamps
    end
  end
end
