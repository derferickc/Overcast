class RemovePlayableUri < ActiveRecord::Migration
  def change
  	remove_column :tracks, :playable_URI, :string
  end
end
