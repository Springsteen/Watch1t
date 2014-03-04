require "imdb"
require "csv"
class SeriesSearch
	
	def find criteria, begin_year, output_file_name
		puts "Searching ..."
		imdb_output = search_imdb(criteria, begin_year)
		puts "Chechking which of the movies are series ..."
		series = search_for_series(imdb_output)
		series
	end

private

	def search_imdb input, year_after
		parsed = Array.new
		Imdb::Search.new(input).movies.each do |e|
			if !(e.year.nil?) and (e.year.to_i > year_after.to_i) and (Time.now.year > e.year) and (e.title =~ /#{input}/)
				parsed << e
			end
		end
		parsed
	end

	def search_for_series input
		series = Array.new
		pre_s = Array.new

		input.each do |elem|
			pre_s << Imdb::Serie.new(elem.id)
		end

		pre_s.each do |elem|
			series << elem if !(elem.seasons.empty?)
		end

		series
	end

	def write_csv input, csv_name
		CSV.open("#{csv_name}","w") do |csv|
			input.each do |e|
				csv << [e.id,e.title]
			end
		end
	end

end

