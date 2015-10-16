class AddBroadcastStatusPlyalist < ActiveRecord::Migration
  def change
  	add_column :playlists, :broadcast_status, :boolean, default: false
  end
end
