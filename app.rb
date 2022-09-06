require_relative "lib/database_connection"
require_relative "lib/album_repository"

# We need to give the database name to the method `connect`.
DatabaseConnection.connect("music_library")

# Perform a SQL query on the database and get the result set.
album_repository = AlbumRepository.new
result = album_repository.all

# Print out each record from the result set .
result.each do |record|
  p record.id
  p record.title
  p record.release_year
  p record.artist_id
end
