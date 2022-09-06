require "./lib/album.rb"

class AlbumRepository
  def all
    query = "SELECT id, title, release_year, artist_id FROM albums;"
    result = DatabaseConnection.exec_params(query, [])
    array = []
    result.each do |hash|
      p hash
      album = Album.new
      album.id = hash["id"]
      album.title = hash["title"]
      album.release_year = hash["release_year"]
      album.artist_id = hash["artist_id"]
      array << album
    end

    return array
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;
    # Returns an array of album objects.
  end
end
