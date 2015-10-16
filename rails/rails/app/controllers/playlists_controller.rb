class PlaylistsController < ApplicationController
	skip_before_filter :verify_authenticity_token

  def broadcast
    data = JSON.parse(params[:data])
  	Playlist.find(data["playlist_id"]).update(broadcast_status: 'true')
    render json: data

  end

  def end_broadcast
    data = JSON.parse(params[:data])
  	Playlist.find(data["playlist_id"]).update(broadcast_status: 'false')
    render json: data
  end

  def all_broadcasts
    playlists = Playlist.joins(:user).select("username, playlists.id as playlist_id, user_id").where(broadcast_status: 'true')
    render json: playlists
  end

  def complete_playlist_info
    data = JSON.parse(params[:data])
    tracks = Track.joins(:playlist).select("playlists.id as playlist_id, tracks.id as track_id, title, artist, album, duration, spotify_id, spotify_uri, playable_uri, total_likes, playlist_position").where(playlist_id: data["playlist_id"])
    render json: tracks
  end

  def position
    data = JSON.parse(params[:data])
    position = Playlist.find(data["playlist_id"]).update(playlist_position: data["playlist_position"])
    render json: position
  end
 
end

   # likes = Like.joins(:track).select("tracks.id as track_id, artist, title, duration, spotify_id, user_id").where(playlist_id: params[:data])


    # joins(:tracks).select("playlist_id as playlist_id, tracks.id as track_id, artist, title, duration, spotify_id, spotify_uri, playable_uri").where(playlist_id: data["playlist_id"])


    # playlists = Playlist.joins(:user, :tracks, :listeners).select("username, playlists.id as playlist_id, users.id as user_id, tracks.id as track_id, listeners.id as listener_id, artist, title, duration, spotify_id, spotify_uri, playable_uri").where(broadcast_status: 'true', id: data["playlist_id"])

    # likes = Like.where(playlist_id: data["playlist_id"])

