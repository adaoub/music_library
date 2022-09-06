require "album_repository"
# require 'pg'
# require 'database_connection'

def reset_albums_table
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

describe AlbumRepository do
  before(:each) do
    reset_albums_table
  end
  # (your tests will go here).

  it "returns all albums" do
    # connection = DatabaseConnection.connect('music_library')
    repo = AlbumRepository.new #(connection)
    albums = repo.all

    expect(albums[0].id).to eq "1"
    expect(albums[0].title).to eq "Doolittle"
    expect(albums[0].release_year).to eq "1989"
    expect(albums[0].artist_id).to eq "1"

    expect(albums[1].id).to eq "2"
    expect(albums[1].title).to eq "Surfer Rosa"
    expect(albums[1].release_year).to eq "1988"
    expect(albums[1].artist_id).to eq "1"
  end
end
