class VideoSearch 

    def find criteria
        criteria.to_s
        a = YoutubeSearch.search(criteria).first
        asd = String.new
        a.each do |e|
            if e.to_s =~ /video_id/
                asd = e.to_s.split
                asd = asd.last
                asd.gsub!("\""," ")
                asd.gsub!("]"," ")
                asd.gsub!(" ","")
            end
        end
        asd
    end

end