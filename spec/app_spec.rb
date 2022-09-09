require "./app.rb"
require "database_connection"

def reset_albums_table
  seed_sql = File.read("spec/seeds.sql")
  @connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  @connection.exec(seed_sql)
end

describe Application do
  before(:each) do
    reset_albums_table
  end

  it "list all albums" do
    album_repository_double = double :fake_album
    io = double :io
    album1 = double :album1, id: 1, title: "test1"
    album2 = double :album2, id: 2, title: "test2"
    album3 = double :album3, id: 3, title: "test3"
    app = Application.new("music_library_test", io, album_repository_double)
    expect(io).to receive(:puts).with("what would you like to do?")
    expect(io).to receive(:puts).with("1- List all albums")
    expect(io).to receive(:gets).and_return(1)
    expect(album_repository_double).to receive(:all).and_return([album1, album2, album3])

    expect(io).to receive(:puts).with("* #{album1.id} - #{album1.title}")
    expect(io).to receive(:puts).with("* #{album2.id} - #{album2.title}")
    expect(io).to receive(:puts).with("* #{album3.id} - #{album3.title}")

    app.run
  end

  it "runs again if wrong option is chosen" do
    album_repository_double = double :fake_album
    io = double :io
    album1 = double :album1, id: 1, title: "test1"
    album2 = double :album2, id: 2, title: "test2"
    album3 = double :album3, id: 3, title: "test3"
    app = Application.new("music_library_test", io, album_repository_double)
    expect(io).to receive(:puts).with("what would you like to do?")
    expect(io).to receive(:puts).with("1- List all albums")
    expect(io).to receive(:gets).and_return(100)
    expect(io).to receive(:puts).with("Please choose a correct option")
    expect(io).to receive(:puts).with("what would you like to do?")
    expect(io).to receive(:puts).with("1- List all albums")
    expect(io).to receive(:gets).and_return(1)
    expect(album_repository_double).to receive(:all).and_return([album1, album2, album3])
    expect(io).to receive(:puts).with("* #{album1.id} - #{album1.title}")
    expect(io).to receive(:puts).with("* #{album2.id} - #{album2.title}")
    expect(io).to receive(:puts).with("* #{album3.id} - #{album3.title}")
    app.run
  end
end
