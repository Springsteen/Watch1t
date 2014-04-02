class Serie < ActiveRecord::Base

	has_many :seasons

	def self.search(search)
		search_condition = "%" + search + "%"
		find(:all, :conditions => ['title LIKE ?', search_condition])
	end

	def self.update(id)
		old_serie = find(id)
		new_serie = Imdb::Serie.new(id)

		old_serie[:title] = new_serie.title
		old_serie[:year] = new_serie.year
		old_serie[:updated_at] = Time.now
		old_serie.save

		old_serie
	end
end
