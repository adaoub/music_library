require "album_repository"
require "album"
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

  it "returns a sinlge album" do
    repo = AlbumRepository.new

    album = repo.find(2)

    expect(album.id).to eq "2"
    expect(album.title).to eq "Surfer Rosa"
    expect(album.release_year).to eq "1988"
    expect(album.artist_id).to eq "1"
  end

  it "insert an album into albums table" do
    repo = AlbumRepository.new
    album = Album.new
    album.title = "DRE"
    album.release_year = "1990"
    album.artist_id = 2

    repo.create(album)
    albums = repo.all
    expect(albums[0].id).to eq "1"
    expect(albums[0].title).to eq "Doolittle"
    expect(albums[0].release_year).to eq "1989"
    expect(albums[0].artist_id).to eq "1"

    expect(albums[1].id).to eq "2"
    expect(albums[1].title).to eq "Surfer Rosa"
    expect(albums[1].release_year).to eq "1988"
    expect(albums[1].artist_id).to eq "1"

    expect(albums[2].id).to eq "3"
    expect(albums[2].title).to eq "DRE"
    expect(albums[2].release_year).to eq "1990"
    expect(albums[2].artist_id).to eq "2"
  end

  it "delete an album entry" do
    repo = AlbumRepository.new
    repo.delete(1)
    albums = repo.all
    expect(albums.length).to eq 1
    expect(albums.first.id).to eq "2"
  end

  it "delete both album entries" do
    repo = AlbumRepository.new
    repo.delete(1)
    repo.delete(2)
    albums = repo.all
    expect(albums.length).to eq 0
  end

  it "update an album record" do
    repo = AlbumRepository.new

    album = repo.find(1)

    album.title = "Fire"
    album.release_year = "2015"
    album.artist_id = "3"

    repo.update(album)

    albums = repo.find(1)

    expect(albums.title).to eq "Fire"
    expect(albums.release_year).to eq "2015"
    expect(albums.artist_id).to eq "3"
  end

  it "update only the release_year in an album record" do
    repo = AlbumRepository.new

    album = repo.find(1)

    album.release_year = "2015"

    repo.update(album)

    albums = repo.find(1)

    expect(albums.title).to eq "Doolittle"
    expect(albums.release_year).to eq "2015"
    expect(albums.artist_id).to eq "1"
  end
end
