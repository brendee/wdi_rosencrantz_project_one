require 'active_record'

class Post < ActiveRecord::Base
  def authors
    Author.where({post_id: self.id})
  end
end