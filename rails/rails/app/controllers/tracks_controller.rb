class TracksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    data = JSON.parse(params[:data])
    # data = params[:data]
  	Track.create(playlist_id: data["playlist_id"], title: data["title"], artist: data["artist"], album: data["album"], duration: data["duration"], playable_uri: data["playable_uri"], spotify_id: data["spotify_id"], spotify_uri: data["spotify_uri"])
    render json: 'Track inserted into playlist'
  end

  def destroy
    # data = params[:data]
    data = JSON.parse(params[:data])
  	Track.where(spotify_id: data["spotify_id"], playlist_id: data["playlist_id"]).destroy_all
    render json: 'Track removed from playlist'
  end

end
