//
//  OvercastServerHTTPDelegate.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/15/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import Foundation

protocol OvercastServerHTTPDelegate : class{
    func pushAddedTrackToServer(track: SPTPartialTrack)
    func getAllBroadcasts()
    func getBroadcast(broadcastID: String, forView: ShowBroadcastDetailsViewController)
}