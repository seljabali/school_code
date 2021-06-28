class AlbumController < ApplicationController
	scaffold :album
	
	def list
		@albums = Album.find(:all, :include => "artist", :order => "artists.name ASC, albums.year ASC")
	end
	
	def edit
		@album = Album.find(params["id"])
		@artists = Artist.find(:all, :order => "artists.name ASC")
		@genres = Genre.find(:all, :order => "genres.name ASC")
   
	end
	
	def show
		@album = Album.find(params["id"])
    @track = Track.find_by_sql(["SELECT trk.length, trk.number AS number, trk.name AS name_track
                            FROM tracks trk, albums alb 
                            WHERE trk.album_id = alb.id AND alb.id = ?
                            ORDER BY trk.number ASC", params["id"]])
	end
	
	def new
		@artists = Artist.find(:all, :order => "artists.name ASC")
		@genres = Genre.find(:all, :order => "genres.name ASC")
	end
  
  def best_albums
  @album = Album.find_by_sql(["SELECT alb.rating, alb.year, art.name AS artist_name, alb.name AS album_name, art.id AS artist_id, alb.id AS album_id   
                          FROM albums alb, artists art   
                          WHERE art.id = alb.artist_id AND alb.rating = (SELECT DISTINCT MAX(alb2.rating) 
                                                                          FROM albums alb2)
                          ORDER BY art.name ASC,alb.name ASC, alb.year ASC",params["id"]])
  end
end
