class AddLikesToTrack < ActiveRecord::Migration
  def change
  	add_column :tracks, :total_likes, :integer, default: 0
  end
end
