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

	Author.create(authors_hash)

	erb(:"authors/index", { locals: { authors: Author.all() } })
end

get("/authors/:id/posts") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/show", { locals: { author: author } })
end

get("/authors/:id/edit") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/edit", { locals: { author: author, posts: Post.all() } })
end

put("/authors/:id/") do
	authors_hash = {
		name: params["name"],
		post_id: params["post_id"],
		tag_id: params["tag_id"],
		subscriber_id: params["subscriber_id"]
	}

	author = Author.find_by({id: params[:id]})
	author.update(authors_hash)

	erb(:"authors/show", { locals: { author: author } })
end	
	
delete ("/authors/:id/") do
	author = Author.find_by({id: params[:id]})
	author.destroy

	redirect "/authors"
end

get("/posts") do
	erb(:"posts/index", { locals: { posts: Post.all() } })
end

get("/feed") do
	erb(:"posts/feed", { locals: { posts: Post.all(), authors: Author.all() } })
	end

get("/posts/new") do
	erb(:"posts/new", { locals: { authors: Author.all() } })
end

post("/posts") do

	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_id: params["image_id"],
		created_at: params["created_at"]
	}

	Post.create(posts_hash)

	erb(:"posts/index", { locals: { posts: Post.all() } })
end

get("/posts/:id") do
	post = Post.find_by("id", params[:id])
	erb(:"posts/show", { locals: { post: post } })
end

get("/posts/:id/edit") do
	post = Post.find_by({id: params[:id]})
	erb(:"posts/edit", { locals: { post: post, authors: Author.all() } })
end

put("/posts/:id/") do
	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_id: params["image_id"],
		created_at: params["created_at"]
	}

	post = Post.find_by({id: params[:id]})
	post.update(posts_hash)

	erb(:"posts/show", { locals: { post: post } })
end

delete ("/posts/:id") do
	post = Post.find_by({id: params[:id]})
	post.destroy

	redirect "/posts"
end

get("/tags") do
	erb(:"tags/index", { locals: { tags: Tag.all() } })
end

post("/tags") do

	tags_hash = {
		name: params["name"]
	}

	Tag.create(tags_hash)

	erb(:"tags/index", { locals: { tags: Tag.all() } })
end

get("/tags/:id/posts") do
	tag = Tag.find_by("id", params[:id])

	erb(:"tags/show", { locals: { tag: tag } })
end