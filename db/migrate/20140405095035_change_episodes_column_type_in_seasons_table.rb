class ChangeEpisodesColumnTypeInSeasonsTable < ActiveRecord::Migration
  def change
  	def up
   		change_column :seasons, :episodes, :integer
  	end

  	def down
   		change_column :seasons, :episodes, :string
  	end
  end
end
