require 'thor'

class ItunesTrack
  class CLI < Thor
    desc "size [ARTIST]", "Show track size for ARTIST match"
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
      res = ItunesTrack.itunes_tracks(&cond)
      unless res.empty?
        res.map { |t|
          puts attrs.inject("") { |str, attr| [str, t.send(attr).get.to_s].join(" ") }
        }
      else
        puts "No tracks found"
      end
    end

    desc "csv PATH", "Create CSV file from tracks data"
    option :fields, aliases:"-f", default: ItunesTrack::ATTRS.join(",")
    option :artist, aliases:"-a"
    def csv(path)
      fields = options[:fields].split(",")
      cond =
        if options[:artist]
          ->t{ t.artist.get.match(/#{options[:artist]}/i) }
        else
          ->t{ true }
        end
      puts "I am working on csv..."
      ItunesTrack.build(*fields, &cond)
      ItunesTrack.to_csv(path, fields)
      puts "CSV file successfully created at #{path}."
    end

    desc "version", "Show ItunesTrack version"
    def version
      puts "ItunesTrack #{ItunesTrack::VERSION} (c) 2013 kyoendo"
    end
    map "-v" => :version
  end
end
