class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
    	t.string :title
    	t.string :year 
    	t.timestamps
    end
  end
end
