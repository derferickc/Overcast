//
//  File.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/13/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

protocol BroadcastDelegate : class {
    func addToPlaylist(track partialTrack : SPTPartialTrack)
}
