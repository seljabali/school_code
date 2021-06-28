class GenreController < ApplicationController
	scaffold :genre
	
	def list
		@genres = Genre.find(:all, :order => "genres.name ASC")
	end

	def edit
		@genre = Genre.find(params["id"])
	end
	
	def show
    @genre = Genre.find_by_sql(["SELECT alb.year, art.name AS artist_name, alb.name AS album_name, art.id AS artist_id, alb.id AS album_id, gen.name AS genre_name, gen.id AS genre_id
                            FROM artists art, albums alb, genres gen
                            WHERE gen.id = ? AND art.id = alb.artist_id AND alb.genre_id = gen.id
                            ORDER BY art.name ASC, alb.name ASC, alb.year ASC",params["id"]])
	end
	
	def new
	end
	
end
