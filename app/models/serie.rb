class Serie < ActiveRecord::Base

	has_many :seasons

	def self.search(search)
		return if search.blank?
		search_condition = "%" + search + "%"
		find(:all, :conditions => ['title LIKE ?', search_condition])
	end

end
