class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token
	
	def create
    user = User.find_by(username: params[:username])
  			if user and user.authenticate(params[:password])
  				user_info = Playlist.joins(:user).select("username, playlists.id as playlist_id, user_id").where(user_id: user.id)
				  render json: user_info

        elsif user

  			else 
  				user = User.create(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation])
          Playlist.create(user_id: user.id)
          user_info = Playlist.joins(:user).select("username, playlists.id as playlist_id, user_id").where(user_id: user.id)
  				render json: user_info
  			end
	end

end
