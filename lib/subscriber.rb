require 'active_record'

class Subscriber < ActiveRecord::Base

	end

def subscribe (subscribers, title)
  subscribers.each do |subscriber|
  response = HTTParty.post "https://sendgrid.com/api/mail.send.json", 
    :body => {
    "api_user" => "bdargan",
    "api_key" => "*******",
    "to" => "#{subscriber.email}",
    "toname"=> "#{subscriber.name}",
    "from" => "brenda@brendadargan.com",
    "subject" => "Sloth Central is updated!",
    "text" => "Hi #{subscriber.name}! Here's a new blog post for you to enjoy on Sloth Central: '#{title}.' Visit Sloth Central for all your sloth news needs."
      	};
  	end
end	