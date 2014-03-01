require "imdb"
require "csv"

class CSVExamine 

	def read csv_name
		series = Array.new
		CSV.foreach("#{csv_name}") do |row|
			 row = row.to_s
			 row = row.split(",")[0]
			 row = row.gsub("\"","")
			 row = row.gsub("[","")
			 
			 serie = Imdb::Serie.new(row.split(",")[0])

			 series << serie if !serie.plot.nil? 
		end
		series
	end

end 

a = CSVExamine.new

series = a.read("walking_dead.csv")

series.each do |e|
	puts e.plot
	puts e.season(1).episodes.size 
	e.season(1).episodes.each do |a|
		puts a.title
	end
end

#b = Imdb::Serie.new("1520211")
#puts b.title
#array.season(1).episodes.each do |e|
#	puts e.air_date
#end 