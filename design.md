# {{Music_Library}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `albums`*

```
# EXAMPLE

Table: albums

      array << album
 id |        title         | release_year | artist_id 
----+----------------------+--------------+-----------
  1 | Doolittle            |         1989 |         1
  2 | Surfer Rosa          |         1988 |         1
  4 | Super Trouper        |         1980 |         2
  5 | Bossanova            |         1990 |         1
  6 | Lover                |         2019 |         3
  7 | Folklore             |         2020 |         3
  8 | I Put a Spell on You |         1965 |         4
  9 | Baltimore            |         1978 |         4
 10 | Here Comes the Sun   |         1971 |         4
 11 | Fodder on My Wings   |         1982 |         4
  3 | Waterloo             |         1972 |         2
 13 | Mezzanine            |         1998 |         5
 14 | Running up that hill |         1970 |         6


```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO "public"."albums" ("title", "release_year", "artist_id") VALUES
('Doolittle', 1989, 1);
INSERT INTO "public"."albums" ("title", "release_year", "artist_id") VALUES
('Surfer Rosa', 1988, 1);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)

class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# album = Album.new
# album.name = 'Bossanova'
# album.name
```


*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums

# Repository class
# (in lib/albums_repository.rb)

class AlbumsRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of album objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, release_year FROM albums WHERE id = 1;

    # Returns a single album object.
  end

  # Add more methods below for each operation you'd like to implement.

  def create(album)
  # Executes the SQL query:
  #INSERT INTO albums (name, release_year, artist_id) VALUES ($1, $2, $3);
  
  #returns nothing
  end

  def update(album)

  #Executes the SQL query:
  # UPDATE albums SET title = $1, release_year = $2, artist_id = $3;

  #returns nothing

  end

  def delete(id)
  # Execute the SQL query:
  #DELETE FROM albums WHERE id = $1
  #returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all albums

repo = AlbumRepository.new

albums = repo.all

# albums.length # =>  2

albums[0].id # =>  1
albums[0].title # =>  'Doolittle'
albums[0].release_year # =>  '1989'
albums[0].artist_id #=> 1

albums[1].id # =>  2
albums[1].title # =>  'Surfer Rosa'
albums[1].release_year # =>  '1988'
albums[0].artist_id #=> 2

#........ return all other albums in the table

# 2
# Get a single album


repo = AlbumRepository.new

album = repo.find(1)

album.id # =>  1
album.title # =>  'Surfer Rosa'
album.release_year # =>  '1988'
album.artist_id #=> 2



# 3
# create an album

repo = AlbumRepository.new

# Build a new model object
album = album.new
album.title = 'DRE'
album.release_year = '1990'
album.artist_id = 2

repo.create(album) # Performs the INSERT query

# Performs a SELECT query to get all records (implemented previously)
all_albums = repo.all 

# all_albums should contain the album 'DRE' created above.

# 4
# Delete a single album


repo = AlbumRepository.new



repo.delete(1)

albums = repo.all

albums.length #=>1



#5 update an album record

repo = AlbumRepository.new

album = repo.find(1)

album.title = "Fire"
album.release_year = 2015
album.artist_id = 3

album.update(album)

albums = repo.all

albums[0].title #> Fire
albums[0].release_year #> 2015
albums[0].artist_id #> 3



# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'albums' })
  connection.exec(seed_sql)
end

describe albumRepository do
  before(:each) do 
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._



SELECT albums.id AS album_id,
      albums.title
      FROM artists
      JOIN albums
      ON artists.id = albums.artist_id
      WHERE artists.name = 'Pixies' AND artists.release_year = 1988;
  