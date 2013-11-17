require 'appscript'
require 'csv'
require 'ostruct'

include Appscript

class ItunesTrack < OpenStruct
  VERSION = "0.0.1"

  ATTRS = %i(name time artist album genre rating played_count year composer track_count track_number disc_count disc_number played_count lyrics)
  class << self
    def build(*attrs)
      tracks.clear
      @attrs = attrs.empty? ? ATTRS : attrs
      track_attrs = []
      itunes_tracks.each do |track|
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
      tracks.push *track_attrs.map { |attrs| new attrs }
    end

    def full_build
      build(*track_properties)
    end

    def tracks
      @tracks ||= []
    end

    def itunes
      @itunes ||= app('iTunes').tracks
    end

    def itunes_tracks
      @itunes_tracks ||= itunes.get
    end

    def size
      itunes_tracks.size
    end

    def track_properties
      itunes.properties.map(&:intern)
    end

    def to_csv(path, attrs=@attrs)
      raise 'Should be build first' if tracks.empty?
      CSV.open(path, 'wb') do |csv|
        csv << attrs
        tracks.each { |t| csv << attrs.map{ |attr| t.send attr } }
      end
    end
  end
end

ITunesTrack = ItunesTrack
