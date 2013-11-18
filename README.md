# ItunesTrack

`ItunesTrack` is a object wrapper of iTunes music tracks. You can get the track information and save them in a CSV file.

## Installation

Add this line to your application's Gemfile:

    gem 'itunes_track'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itunes_track

## Usage

In your terminal, try followings;

    # Show help
    % itunes_track
    
    # Show number of tracks with ARTIST match
    % itunes_track size beatles
    
    # Create CSV file
    % itunes_track csv itunes.csv

In your ruby script;

```ruby
require 'itunes_track'

# to build track data for `beatles` with 'name' and 'artist' fields
ItunesTrack.build(:name, :artist) do |t|
  t.artist.get.match /beatles/i
end

# create csv for the builded track data
ItunesTrack.to_csv('beatles.csv')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
