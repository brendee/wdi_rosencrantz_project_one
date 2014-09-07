require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require_relative './lib/connection'
require_relative './lib/author'
require_relative './lib/post'
require_relative './lib/tag'
require_relative './lib/image'

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
		subscriber_id: params["subscriber_id"]
	}

	all_authors = Author.create(authors_hash)
	all_authors.save

	erb(:"authors/index", { locals: { authors: Author.all() } })
end

get("/authors/:id/posts") do
	author = Author.find_by({id: params[:id]})
	post = Post.where({author_id: params[:id]})

	erb(:"authors/show", { locals: { author: author, posts: post } })

	# erb(:"authors/show", { locals: { author: author, post: post, posts: Post.all() } })
end

get("/authors/:id/edit") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/edit", { locals: { author: author, posts: Post.all() } })
end

put("/authors/:id") do
	authors_hash = {
		name: params["name"],
		subscriber_id: params["subscriber_id"]
	}

	author = Author.find_by({id: params[:id]})
	author.update(authors_hash)

	erb(:"authors/show", { locals: { author: author, posts: Post.all() } })
end	
	
delete ("/authors/:id") do
	author = Author.find_by({id: params[:id]})
	author.destroy

	redirect "/authors"
end

get("/posts") do
	erb(:"posts/index", { locals: { posts: Post.all() } })
end

get("/posts/new") do
	erb(:"posts/new", { locals: { authors: Author.all() } })
end

post("/posts") do

	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag"],
		author_id: params["author_id"],
		image_url: params["image_url"],
		created_at: params["created_at"]
	}

	all_posts = Post.create(posts_hash)
	all_posts.save

	erb(:"posts/index", { locals: { posts: Post.all() } })
end

get("/posts/:id") do
	post = Post.find_by(id: params[:id])
	author = Author.find_by({id: post.author_id})

	erb(:"posts/show", { locals: { post: post, author: author, authors: Author.all() } })
end

# Feed of all blog posts
get("/feed") do

	erb(:"posts/feed", { locals: { posts: Post.all(), authors: Author.all() } })
	end


get("/posts/:id/edit") do
	post = Post.find_by({id: params[:id]})
	erb(:"posts/edit", { locals: { post: post, authors: Author.all() } })
end

put("/posts/:id") do
	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_url: params["image_url"],
		created_at: params["created_at"]
	}

	post = Post.find_by({id: params[:id]})
	post.update(posts_hash)
	author = Author.find_by({id: post.author_id})

	erb(:"posts/show", { locals: { post: post, author: author, authors: Author.all() } })
end

delete ("/posts/:id") do
	post = Post.find_by({id: params[:id]})
	post.destroy

	redirect "/posts"
end

# TAGS 
get("/tags") do
	erb(:"tags/index", { locals: { tags: Tag.all() } })
end


post("/tags") do
	tags_hash = {
		tag: params["tag"],
	}

	all_tags = Tag.create(tags_hash)
	all_tags.save

	erb(:"tags/index", { locals: { tags: Tag.all() } })
end


get("/tags/:id/posts") do
	tag = Tag.find_by(id: params[:id])
	post = Post.where({tag: params[:id]})

	erb(:"tags/show", { locals: { tag: tag, post: post } })
end


get("/tags/:id/edit") do
	tag = Tag.find_by({id: params[:id]})
	erb(:"tags/edit", { locals: { tag: tag } })
end

put("/tags/:id") do
	tags_hash = {
		tag: params["tag"]
	}

	tag = Tag.find_by({id: params[:id]})
	tag.update(tags_hash)

	erb(:"tags/index", { locals: { tag: tag, tags: Tag.all() } })
end	


delete ("/tags/:id") do
	tag = Tag.find_by({id: params[:id]})
	tag.destroy

	redirect "/tags"
end