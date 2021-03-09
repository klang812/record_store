class Artist
  attr_reader :id
  attr_accessor :name, :album_id

  def initialize(attributes)
    @name = attributes[:name]
    @album_id = attributes[:album_id]
    @id = attributes[:id]
  end

  def ==(artist_to_compare)
    if artist_to_compare != nil
      (self.name() == artist_to_compare.name()) && (self.album_id() == artist_to_compare.album_id())
    else
      false
    end
  end

  def self.all
    returned_artists = DB.exec("SELECT * FROM artists;")
    artists = []
    returned_artists.each() do |artist|
      name = artist.fetch("name")
      album_id = artist.fetch("album_id").to_i
      id = artist.fetch("id").to_i
      artists.push(Artist.new({:name => name, :album_id => album_id, :id => id}))
    end
    artists
  end

  def save 
    result = DB.exec("INSERT INTO artists (name, album_id) VALUES ('#{@name}', #{@album_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    if artist
      name = artist.fetch("name")
      album_id = artist.fetch("album_id").to_i
      id = artist.fetch("id").to_i
      Artist.new({name: name, album_id: album_id, id: id})
    else
      nil
    end
  end

  def delete
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def update(updates)
    if (updates.has_key?(:name)) && (updates.fetch(:name) != nil)
      @name = updates.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    elsif (updates.has_key?(:album_name)) && (updates.fetch(:album_name) != nil)
      album_name = updates.fetch(:album_name)
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
      if album != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
  end

  def albums
    albums = []
    results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
    results.each() do |result|
      album_id = result.fetch("album_id").to_i()
      album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};")
      name = album.first().fetch("name")
      albums.push(Album.new({name: name, id: album_id}))
    end
    albums
  end
end
