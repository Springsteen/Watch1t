class Season < ActiveRecord::Base

	belongs_to :serie
	has_many :episodes

end
