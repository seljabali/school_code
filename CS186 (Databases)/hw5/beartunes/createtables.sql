CREATE TABLE artists (
	id SERIAL PRIMARY KEY,
	name varchar(100),
	bio varchar(500)
);

CREATE TABLE albums (
	id SERIAL PRIMARY KEY,
	artist_id integer,
	name varchar(100),
	year integer,
	genre_id integer,
	rating integer
);

CREATE TABLE tracks (
	id SERIAL PRIMARY KEY,
	album_id integer,
	name varchar(100),
	number integer,
	length integer
);

CREATE TABLE genres (
	id SERIAL PRIMARY KEY,
	name varchar(100)
);
