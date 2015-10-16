class LikesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # data = JSON.parse(params[:data])
    data = params[:data]
    liker = Like.where(track_id: data["track_id"], user_id: data["user_id"])
      if liker
        render json: 'User has already liked this track'
      else
      	Like.create(track_id: data["track_id"], user_id: data["user_id"])
        total_likes = Track.find(data["track_id"]).increment!(:total_likes)
        render json: total_likes
      end
  end

  def like_info
 	  data = JSON.parse(params[:data])
  	info = Like.joins(:user).where(track_id: data["track_id"]).select("user_id, username")
    render json: info

 end
  
end
