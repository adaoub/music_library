require "./lib/album.rb"

class AlbumRepository
  def all
    query = "SELECT id, title, release_year, artist_id FROM albums;"
    result = DatabaseConnection.exec_params(query, [])
    array = []

    result.each do |hash|
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

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    params = [id]
    query = "SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;"
    result = DatabaseConnection.exec_params(query, params)

    result.each do |albums|
      @album = Album.new
      @album.id = albums["id"]
      @album.title = albums["title"]
      @album.release_year = albums["release_year"]
      @album.artist_id = albums["artist_id"]
    end
    return @album
    # Executes the SQL query:
    # SELECT id, name, release_year FROM albums WHERE id = 1;

    # Returns a single album object.
  end

  def create(album)
    # Executes the SQL query:

    query = "INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);"
    params = [album.title, album.release_year, album.artist_id]
    result = DatabaseConnection.exec_params(query, params)

    #returns nothing
  end

  def delete(id)
    # Execute the SQL query:
    query = "DELETE FROM albums WHERE id = $1"

    params = [id]
    result = DatabaseConnection.exec_params(query, params)

    #returns nothing

  end

  def update(album)

    #Executes the SQL query:
    query = "UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;"
    params = [album.title, album.release_year, album.artist_id, album.id]
    result = DatabaseConnection.exec_params(query, params)

    #returns nothing

  end
end
