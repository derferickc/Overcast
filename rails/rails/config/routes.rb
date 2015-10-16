Rails.application.routes.draw do

# Listeners
  post 'listeners/create' => 'listeners#create'

  delete 'listeners/destroy' => 'listeners#destroy'

  post 'listeners/all' => 'listeners#all'

# Tracks
  post 'tracks/create' => 'tracks#create'

  post 'tracks/destroy' => 'tracks#destroy'

# Playlists
  post 'playlists/broadcast' => 'playlists#broadcast'

  post 'playlists/end_broadcast' => 'playlists#end_broadcast'

  get 'playlists/all_broadcasts' => 'playlists#all_broadcasts'

  post 'playlists/complete_playlist_info' => 'playlists#complete_playlist_info'

  post 'playlists/position' => 'playlists#position'

# Users
  post 'users' => 'users#create'

# Likes
  post 'likes/create' => 'likes#create'

  get 'likes/like_info' => 'likes#like_info'

end
