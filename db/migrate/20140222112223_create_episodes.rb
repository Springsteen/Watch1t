class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
    	t.string :title
    	t.date :air_date
    	t.timestamps
    end
  end
end
