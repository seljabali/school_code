class TrackController < ApplicationController
	scaffold :track
	
	def list
    @track = Track.find_by_sql(["SELECT art.name AS name_artist, trk.name AS name_track, art.id AS artist_id, alb.id AS album_id
                            FROM artists art, tracks trk, albums alb 
                            WHERE trk.album_id = alb.id AND alb.artist_id = art.id
                            ORDER BY name_track ASC, name_artist ASC", params["id"]])
	end
	
	def edit
		@track = Track.find(params["id"])
		@albums = Album.find(:all, :include => "artist", :order => "artists.name ASC, albums.year ASC")
	end
	
	def show
    @artist = Artist.find(params["id"])
	end
	
	def new
		@albums = Album.find(:all, :include => "artist", :order => "artists.name ASC, albums.year ASC")
	end
	
end
