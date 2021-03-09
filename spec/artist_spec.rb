require 'rspec'
require 'album'
require 'artist'
require 'spec_helper'

describe '#Artist' do
  before(:each) do
    @album = Album.new({name: "Giant Step"})
    @album.save()
  end
  
  describe('#==') do
    it("is the same artist if it has the same attributes as another artist") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist2 = Artist.new({name: "Les Claypool", album_id: @album.id})
      expect(artist).to(eq(artist2))
    end
  end
  
  describe('.all') do
    it("returns an empty array when there are no artists") do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.save') do
    it("saves an artist") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist2 = Artist.new({name: "Johnny Cash", album_id: @album.id})
      artist2.save()
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('.clear') do
    it("clears all artists") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist2 = Artist.new({name: "Johnny Cash", album_id: @album.id})
      artist2.save()
      Artist.clear()
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an artist by id") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist2 = Artist.new({name: "Johnny Cash", album_id: @album.id})
      artist.save()
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end

  describe('#delete') do
    it("deletes an artist") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist2 = Artist.new({name: "Johnny Cash", album_id: @album.id})
      artist2.save()
      artist.delete()
      expect(Artist.all).to(eq([artist2]))
    end
  end

  describe('#update') do
    it("updates an artist by id") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist.update({name: "Johnny Cash"})
      expect(artist.name).to(eq("Johnny Cash"))
    end
    it("adds an album to an artist") do
      artist = Artist.new({name: "Les Claypool", album_id: @album.id})
      artist.save()
      artist.update({album_name: "Giant Step"})
      expect(artist.albums).to(eq([@album]))
    end
  end
end
