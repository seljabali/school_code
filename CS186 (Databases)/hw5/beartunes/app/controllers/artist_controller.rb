class ArtistController < ApplicationController
	scaffold :artist
	
	def list
		@artists= Artist.find(:all, :order => "artists.name ASC");
	end
	
	def edit
		@artist = Artist.find(params["id"])
	end
	
	def show
		@artist = Artist.find(params["id"])
    @album = Artist.find_by_sql(["Select a.year, a.rating, a.name AS album_name, g.id AS genre_id, a.id AS album_id, g.name AS genre_name From albums a, genres g Where a.artist_id = ? AND g.id = a.genre_id", params["id"]])
    @albums = Artist.find_by_sql(["Select a.year, a.rating, a.name AS album_name, g.id AS genre_id, a.id AS album_id, g.name AS genre_name, SUM(t.length) AS total_length    
                            FROM albums a, genres g, tracks t      
                            WHERE a.artist_id =? AND g.id = a.genre_id AND t.album_id = a.id     
                            GROUP BY a.id, a.year, a.rating, a.name, g.id, a.id, g.name   
                            ORDER BY a.year ASC, a.name ASC", params["id"]])

		@average = Album.find_by_sql(["Select AVG (a.rating) AS avg_rating     
                              FROM albums a     
                              WHERE a.artist_id = ?", params["id"]])
	end
	
	def new
    
	end

  def top_ten_artists
@averages = Artist.find_by_sql(["SELECT art.name AS artist_name, art.id AS artist_id, AVG(alb.rating) AS avg  
                            FROM artists art, albums alb  
                            WHERE alb.artist_id = art.id  
                            GROUP BY art.id, art.name  
                            ORDER BY avg DESC, artist_name  limit 10", params["id"]])
  end

end
