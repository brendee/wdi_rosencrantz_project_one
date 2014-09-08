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

# AUTHORS

# Index page with navigation
get("/") do
	erb(:index)
end

# List of all authors linked to author profile page
get("/authors") do
	erb(:"authors/index", { locals: { authors: Author.all() } })
end

# Add new author form
get("/authors/new") do
	erb(:"authors/new", { locals: { posts: Post.all() } })
end

# Captures new author data into hash, sends user back to list of authors
post("/authors") do
	authors_hash = {
		name: params["name"],
		subscriber_id: params["subscriber_id"]
	}

	all_authors = Author.create(authors_hash)
	all_authors.save

	erb(:"authors/index", { locals: { authors: Author.all() } })
end

# Specific author profile page
get("/authors/:id/posts") do
	author = Author.find_by({id: params[:id]})
	post = Post.where({author_id: params[:id]})

	erb(:"authors/show", { locals: { author: author, posts: post } })
end

# Edit author name page
get("/authors/:id/edit") do
	author = Author.find_by({id: params[:id]})
	erb(:"authors/edit", { locals: { author: author, posts: Post.all() } })
end

# Sends updated information into the author hash
put("/authors/:id") do
	authors_hash = {
		name: params["name"],
		subscriber_id: params["subscriber_id"]
	}

	author = Author.find_by({id: params[:id]})
	author.update(authors_hash)

	erb(:"authors/show", { locals: { author: author, posts: Post.all() } })
end	

# Deletes author entry and redirects to list of authors page	
delete ("/authors/:id") do
	author = Author.find_by({id: params[:id]})
	author.destroy

	redirect "/authors"
end

# POSTS

# Displays list of blog post titles
get("/posts") do
	erb(:"posts/index", { locals: { posts: Post.all() } })
end

# Create new blog post form
get("/posts/new") do
	erb(:"posts/new", { locals: { authors: Author.all(), tags: Tag.all() } })
end

# Captures new post data into hash, sends user back to list of posts
post("/posts") do

	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_url: params["image_url"],
		created_at: Time.now.strftime("%F/%T")
	}

	all_posts = Post.create(posts_hash)
	all_posts.save

	erb(:"posts/index", { locals: { posts: Post.all(), tags: Tag.all() } })
end

# Specific blog post page
get("/posts/:id") do
	post = Post.find_by(id: params[:id])
	author = Author.find_by({id: post.author_id})
	tag = Tag.find_by({id: post.tag_id})

	erb(:"posts/show", { locals: { post: post, tag: tag, author: author, authors: Author.all() } })
end

# Feed of all blog posts
get("/feed") do

	erb(:"posts/feed", { locals: { posts: Post.all(), authors: Author.all(), tags: Tag.all() } })
	end

# Edit blog post form
get("/posts/:id/edit") do
	post = Post.find_by({id: params[:id]})

	erb(:"posts/edit", { locals: { post: post, authors: Author.all(), tags: Tag.all() } })
end

# Sends updated information into the post hash
put("/posts/:id") do
	posts_hash = {
		title: params["title"],
		content: params["content"],
		tag_id: params["tag_id"],
		author_id: params["author_id"],
		image_url: params["image_url"],
		created_at: Time.now.strftime("%F/%T")
	}

	post = Post.find_by({id: params[:id]})
	post.update(posts_hash)
	author = Author.find_by({id: post.author_id})
	tag = Tag.find_by(id: params[:id])

	erb(:"posts/index", { locals: { post: post, author: author, tag: tag, authors: Author.all(), posts: Post.all() } })
end

# Deletes blog post
delete ("/posts/:id") do
	post = Post.find_by({id: params[:id]})
	post.destroy

	redirect "/posts"
end

# TAGS 

# List of tags
get("/tags") do
	erb(:"tags/index", { locals: { tags: Tag.all() } })
end

# New tag form
get("/tags/new") do
	erb(:"tags/new", { locals: { tags: Tag.all() } })
end

# Captures tag information into tags hash and sends user to list of tags
post("/tags") do
	tags_hash = {
		tag: params["tag"],
	}

	all_tags = Tag.create(tags_hash)
	all_tags.save

	erb(:"tags/index", { locals: { tags: Tag.all() } })
end

# List of blog posts containing specific tag
get("/tags/:id/posts") do
	# tag = Tag.find_by(id: params[:id])
	tag = Tag.find_by({id: params[:id]})
	post = Post.where({tag_id: params[:id]})

	erb(:"tags/show", { locals: { tag: tag, posts: post } })
end

# Edit tag form
get("/tags/:id/edit") do
	tag = Tag.find_by({id: params[:id]})
	erb(:"tags/edit", { locals: { tag: tag } })
end

# Captures edited tag name and sends user to list of tags
put("/tags/:id") do
	tags_hash = {
		tag: params["tag"]
	}

	tag = Tag.find_by({id: params[:id]})
	tag.update(tags_hash)

	erb(:"tags/index", { locals: { tag: tag, tags: Tag.all() } })
end	

# Deletes tag and redirects user to list of tags
delete ("/tags/:id") do
	tag = Tag.find_by({id: params[:id]})
	tag.destroy

	redirect "/tags"
end