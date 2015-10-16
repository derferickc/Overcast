//
//  SocketDelegate.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/15/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import Foundation

protocol BroadcasterSocketDelegate : class {
    func signalNextSongForced()
    func signalNextSong()
    func replyCurrentTimeRequest()
    func gotListenerJoin()
    func gotListenerLikeTrack()
}