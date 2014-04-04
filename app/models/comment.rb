class Comment < ActiveRecord::Base
  def self.show(serie,season=nil,episode=nil)
    return Comment.where(serie_id: serie,season_id:season,episode_id:episode,).order("created_at desc")
  end
end
