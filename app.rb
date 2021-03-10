require('sinatra')
require('sinatra/reloader')
require('pry')
require('pg')
require('./lib/album')
require('./lib/song')
require('./lib/artist')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "record_store"})

get('/') do
  @albums = Album.all()
  erb(:albums)
end

get('/albums') do
  @albums = Album.all()
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

post('/albums') do
  name = params[:album_name] 
  album = Album.new({:name => name, :id => nil})
  album.save()
  @albums = Album.all()
  erb(:albums)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  if params[:artist_name] != nil
    @artist = Artist.new({name: params[:artist_name], album_id: @album.id})
    @artist.save()
  end
  if params[:song_name] !=nil
    song = Song.new({name: params[:song_name], album_id: @album.id})
    song.save()
  end
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/artists') do
  @artists = Artist.all()
  erb(:artists)
end

get('/artists/new') do
  erb(:new_artist)
end

post('/artists') do
  name = params[:artist_name]
  artist = Artist.new({name: name})
  artist.save()
  @artists = Artist.all()
  erb(:artists)
end

get('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  erb(:artist)
end

patch('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.update(params[:artist_name])
  @artists = Artist.all()
  erb(:artists)
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  @artists = Artist.all()
  erb(:artists)
end
