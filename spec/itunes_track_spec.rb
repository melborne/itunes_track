require 'spec_helper'

describe ItunesTrack do
  before(:each) do
    ITunesTrack.tracks.clear
  end

  it 'should have a version number' do
    ItunesTrack::VERSION.should_not be_nil
  end

  describe '.itunes' do
    it 'returns a Appscript::Reference' do
      expect(ITunesTrack.itunes).to be_a_kind_of(Appscript::Reference)
    end
  end

  describe '.size' do
    it 'returns number of tracks at iTunes' do
      expect(ITunesTrack.size).to be >= 1000
    end

    it 'returns number of tracks for ABBA' do
      size = ITunesTrack.size { |t| t.artist.get.match /ABBA/ }
      expect(size).to eq 1
    end
  end

  describe '.track_properties' do
    it 'returns track properties' do
      properties = %i(name time artist album genre rating played_count year composer 
              track_count track_number disc_count disc_number played_count lyrics)
      expect(ITunesTrack.track_properties).to include(*properties)
    end
  end

  describe '.build' do
    context 'with :name, :artist arguments' do
      it 'builds track objects with name and artist attrs' do
        ITunesTrack.build(:name,:artist)
        expect(ITunesTrack.tracks.all? { |t| t.is_a? ITunesTrack::Track }).to be_true
      end
    end

    context 'with a block' do
      it 'builds track objects under the block condition' do
        ITunesTrack.build(:name, :artist) do |t|
          t.artist.get.match /beatles/i
        end
        expect(ITunesTrack.tracks.size).to be <= 300
        expect(ITunesTrack.tracks.all? { |t| t.artist.match /beatles/i }).to be_true
      end
    end
  end

  describe '.tracks' do
    context 'before build' do
      it 'should be empty' do
        expect(ITunesTrack.tracks).to be_empty
      end
    end

    context 'after build' do
      it 'should not be empty' do
        ITunesTrack.build(:name)
        expect(ITunesTrack.tracks).not_to be_empty
      end
    end
  end
end
