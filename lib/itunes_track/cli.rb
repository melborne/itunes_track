require 'thor'

class ItunesTrack
  class CLI < Thor
    desc "size ARTIST", "Show track size for ARTIST match"
    def size(artist=nil)
      cond = artist ? ->t{ t.artist.get.match /#{artist}/i } : ->t{ true }
      puts ItunesTrack.size(&cond)
    end
    
    desc "tracks", "Show tracks"
    option :artist, aliases:"-a"
    option :album, aliases:"-l"
    def tracks
      artist, album = options[:artist], options[:album]
      if artist && album
        cond = ->t{ t.artist.get.match(/#{artist}/i) && t.album.get.match(/#{album}/i) }
      elsif artist
        cond = ->t{ t.artist.get.match(/#{artist}/i) }
      elsif album
        cond = ->t{ t.album.get.match(/#{album}/i) }
      else
        cond = ->t{ true }
      end
      attrs = %i(name time artist album played_count)
      ItunesTrack.itunes_tracks(&cond).map do |t|
        puts attrs.inject("") { |str, attr| [str, t.send(attr).get.to_s].join(" ") }
      end
    end
  end
end