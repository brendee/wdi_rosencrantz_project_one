require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require_relative './lib/connection'
require_relative './lib/author'
require_relative './lib/post'
require_relative './lib/tag'

after do 
	ActiveRecord::Base.connection.close
end

get("/") do
	erb(:index)
end

get("/authors") do
	erb(:"authors/index", { locals: { authors: Author.all() } })
end

get("/authors/new") do
	erb(:"authors/new", { locals: { posts: Post.all() } })
end

post("/authors") do
	authors_hash = {
		name: params["name"],
		post_id: params["post_id"],
		tag_id: params["tag_id"],
		subscriber_id: params["subscriber_id"]
	}

	Author.create(author_hash)

	erb(:"authors/index", { locals: { posts: Author.all() } })
end

get("/authors/:id/posts") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/show", { locals: { author: author } })
end

get("/authors/:id/edit") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/edit", { locals: { author: author, posts: Post.all() } })
end

put("/authors/:id/edit") do
	authors_hash = {
		name: params["name"],
		post_id: params["post_id"],
		tag_id: params["tag_id"],
		subscriber_id: params["subscriber_id"]
	}

	author = Author.find_by({id: params[:id]})
	author.destroy

	redirect "/authors"
end

get("/posts") do
	erb(:"posts/index", { locals: { posts: Post.all() } })
end

get("/posts/new") do
	erb(:"posts/new", { locals: { authors. Author.all() } })
end

get("/posts/:id") do
	post = Post.find_by("id", params[:id])
	author = post.author

	erb(:"posts/show", { locals: { post: post, author: author } })
end

post("/posts") do

	post_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_id: params["image_id"],
	}

	Post.create(post_hash)

	erb(:"posts/index", { locals: { posts: Post.all() } })
end