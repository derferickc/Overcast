class RemovePlaylistsFromLikes < ActiveRecord::Migration
  def change
  	remove_column :likes, :playlist_id
  end
end
