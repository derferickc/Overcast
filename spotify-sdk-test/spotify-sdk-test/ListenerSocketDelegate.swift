//
//  ListenerSocketDelegate.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/15/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import Foundation

protocol ListenerSocketDelegate : class {
    func gotNextSongForced()
    func gotNextSong()
    func requestPlaybackInfo(playlist_id : String, broadcaster_id : String)
    func joinStation(playlist_id : String, broadcaster_id : String)
    func likeTrack()
    func recievedCurrentTimeReply()
}