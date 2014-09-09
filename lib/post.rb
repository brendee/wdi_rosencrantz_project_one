require 'active_record'

class Post < ActiveRecord::Base

	def get_author_name
		name = Author.find_by({id: self.author_id}).name

		return name
	end

end