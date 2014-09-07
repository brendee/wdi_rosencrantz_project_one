CREATE DATABASE sloths_microblog;

CREATE TABLE posts (
id serial primary key,
title varchar(255),
content text,
tag_id integer,
author_id integer,
created_at timestamp,
image_url text
);

CREATE TABLE authors (
id serial primary key,
name varchar(255),
subscriber_id integer
);

CREATE TABLE images (
id serial primary key,
name varchar(255),
url text,
post_id integer,
tag_id integer
);

CREATE TABLE tags (
id serial primary key,
tag varchar(255),
post_id integer
);

-- CREATE TABLE snippets (
-- id serial primary key,
-- name varchar(255),
-- post_id integer,
-- image_id integer,
-- author_id integer
-- );

CREATE TABLE subscribers (
id serial primary key,
name varchar(255),
email varchar(255),
author_id integer
);