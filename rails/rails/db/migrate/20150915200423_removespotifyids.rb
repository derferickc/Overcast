class Removespotifyids < ActiveRecord::Migration
  def change
    remove_column :tracks, :spotify_ids, :string
  end
end
