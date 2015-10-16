class AddSpotifyUriToTracks < ActiveRecord::Migration
  def change
  	add_column :tracks, :spotify_uri, :string
  end
end
