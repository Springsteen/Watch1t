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