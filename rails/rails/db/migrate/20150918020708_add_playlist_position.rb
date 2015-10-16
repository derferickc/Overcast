class AddPlaylistPosition < ActiveRecord::Migration
  def change
  	add_column :playlists, :playlist_position, :integer, default: 0
  end
end
