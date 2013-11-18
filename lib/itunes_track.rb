require 'appscript'
require 'csv'
require 'ostruct'

require 'itunes_track/version'

include Appscript

class ItunesTrack
  ATTRS = %i(name time artist album genre rating played_count year composer track_count track_number disc_count disc_number played_count lyrics)

  require 'itunes_track/cli'

  class Track < OpenStruct
  end

  class << self
    def build(*attrs, &blk)
      tracks.clear
      @attrs = attrs.empty? ? ATTRS : attrs
      track_attrs = []
      itunes_tracks(&blk).each do |track|
        track_attrs << begin
          @attrs.inject({}) do |h, attr|
            val = track.send(attr).get rescue ''
            if val.is_a?(String) && val.encoding.to_s!='UTF-8'
              val = val.force_encoding('UTF-8')
            end
            h[attr.intern] = val
            h
          end
        end
      end
      tracks.push *track_attrs.map { |attrs| Track.new attrs }
    end

    def full_build(&blk)
      build(*track_properties, &blk)
    end

    def tracks
      @tracks ||= []
    end

    def itunes
      @itunes ||= app('iTunes').tracks
    end

    def itunes_tracks(&blk)
      block_given? ? itunes.get.select(&blk) : itunes.get
    end

    def size(&blk)
      itunes_tracks(&blk).size
    end

    def track_properties
      itunes.properties.map(&:intern)
    end

    def to_csv(path, attrs=@attrs)
      raise 'Should be built first' if tracks.empty?
      CSV.open(path, 'wb') do |csv|
        csv << attrs
        tracks.each { |t| csv << attrs.map{ |attr| t.send attr } }
      end
    rescue => e
      puts "Something go wrong during csv building: #{e}"
    end
  end
end

ITunesTrack = ItunesTrack

