class ListenersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
     data = params[:data]
     listener = Listener.find_by(user_id: data["user_id"])
        if listener
          Listener.find(listener.id).update(playlist_id: data["broadcast_id"])
          render json: 'Listening to new playlist'
        else
          Listener.create(playlist_id: data["broadcaster_id"], user_id: data["user_id"])
          render json: 'User listening to playlistt'
        end
  end

  # def destroy
  #   # data = JSON.parse(params[:data])
  #   data = params[:data]
  # 	Listener.where(user_id: data["user_id"]).destroy_all
  #   render json: 'Listener removed from playlist'
  # end

  def all
  	data = JSON.parse(params[:data])
  	all = Listener.joins(:user).select("username, users.id as user_id").where(playlist_id:3)
  	render json: all
  end

end
