class DeletesockId < ActiveRecord::Migration
  def change
    remove_column :playlists, :sock_id, :string
  end
end
