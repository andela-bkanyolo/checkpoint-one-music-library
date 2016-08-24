class Song
  extend Concerns::Findable

  attr_accessor :name
  attr_reader :artist
  attr_reader :genre

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist
    self.genre = genre
  end

  def artist=(artist)
    @artist = artist
    artist && artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre && (genre.songs << self unless genre.songs.include?(self))
  end

  def self.all
    @@all
  end

  def save
    @@all << self
    self
  end

  def self.destroy_all
    @@all.clear
  end

  def self.create(name, artist = nil, genre = nil)
    Song.new(name, artist, genre).save
  end

  def self.new_from_filename(filename)
    details = filename.chomp(".mp3").split(" - ").map(&:strip)
    if details.size == 3
      artist, name, genre = details
      artist = Artist.find_or_create_by_name(artist)
      genre = Genre.find_or_create_by_name(genre)
      Song.new(name, artist, genre)
    else
      Song.new(filename, nil, nil)
    end
  end

  def self.create_from_filename(filename)
    Song.new_from_filename(filename).save
  end
end
