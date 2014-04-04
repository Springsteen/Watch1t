class ZamundaParser
  def self.get_links(serie,season,episode)
    website="http://zamunda.net/"
    found = {'torrent_link'=>Array.new,'subs' => Array.new}
    page_counter = 0;
    begin
      next_page = "http://zamunda.net/browse.php?c33=1&c7=1&search="+serie+"&incldead=1&field=name&page="+page_counter.to_s
      agent = Mechanize.new
      zamunda = agent.get(next_page)
      login = zamunda.form_with(:action => "takelogin.php")
      login.field_with(:name => "username").value = "watch1tteam"
      login.field_with(:name => "password").value = "PowerPassword1"
      zamunda_body = login.submit.body
      nokogiri_doc = Nokogiri::HTML(zamunda_body)
      nokogiri_doc.css("table.test>tr:not(:first-child)>td[align=\"left\"]").each do |row|
        subs = Nokogiri::HTML(row.to_s).css("a+img")
        if(subs.to_s =~ /(subtitles|субтитри)/)
          subs = website+Nokogiri::HTML(row.to_s).css("a:first-child").first.attr('href')
        elsif(subs.to_s =~ /(audio|озвучение)/)
          subs = "with bg audio"
        else
          subs = nil
        end
        found['torrent_link'] << website+Nokogiri::HTML(row.to_s).css("a:nth-child(2n)").first.attr('href')
        found['subs'] << subs
      end
      page_counter += 1
    end while(found['torrent_link'].count >= page_counter*20)
    torrent_links = get_torrent_links(found['torrent_link'],serie,season,episode)
    if(!torrent_links.empty?)
      film_number = get_film_number_with_subs(found['subs'],torrent_links)
      if(!film_number.nil?)
        if(found['subs'][film_number] != "with bg audio")
          subs_link = get_subs_link(found['subs'][film_number]) 
        end
      else
        subs_link = nil
        film_number = torrent_links[0]
      end
      torrent_link = found['torrent_link'][film_number]
    else
      torrent_link = nil
      subs_link = nil
    end
    return [torrent_link,subs_link]
  end
private
  def self.get_torrent_links(torrent_links,serie,season,episode=nil)
    links = Array.new()
    torrent_links.each_with_index do |link,counter|
        if(link.downcase =~ /(season|s)(0|\s|)#{season}/) && (link.downcase =~ /(episode|e)(0|00|\s|)#{episode}/ || episode.nil?)
          if(link.downcase =~ /(720p|1080p)/)
            links.insert(0,counter)
          else
            links << counter
          end
        end
    end 
    return links
  end
  def self.get_film_number_with_subs(subs_links,torrent_links_numbers)
    found_subs_number = nil  
    torrent_links_numbers.each do |number|
      if(!subs_links[number].nil?)
        found_subs_number = number
        break
      end
    end 
    return found_subs_number
  end
  def self.get_subs_link(serie_page)
    agent = Mechanize.new
    zamunda = agent.get(serie_page)
    login = zamunda.form_with(:action => "takelogin.php")
    login.field_with(:name => "username").value = "watch1tteam"
    login.field_with(:name => "password").value = "PowerPassword1"
    zamunda_body = login.submit.body
    nokogiri_doc = Nokogiri::HTML(zamunda_body)
    return nokogiri_doc.css("table.mainouter table.test div[align=\"center\"] td.bottom>a:last-child").last.attr('href')
  end
end

