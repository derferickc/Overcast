class AddPlayableUri < ActiveRecord::Migration
  def change
  	add_column :tracks, :playable_uri, :string
  end
end
