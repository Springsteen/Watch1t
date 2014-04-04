class User < ActiveRecord::Base
  def self.update_links()
    episodes = Episode.where(torrent_link:nil)
    episodes.each do |e|
      serie_air_date = e.air_date.to_s.gsub('-', '').to_i
      time_now = Time.now.to_s.split(' ')[0].gsub('-', '').to_i
      if(time_now > serie_air_date)
        serial_name = Serie.find(Season.find(e.season_id).serie_id).title
        season = Season.find(e.season_id).season
        episode = e.episode
        result = ZamundaParser.get_links(serial_name,season,episode)
        Episode.find(e.id).update(:torrent_link => result[0],:subs_link => result[1])
      end
    end
  end 
end
