//
//  tabBarControllerWithSession.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/8/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

/*
    This acts as the go-between for the tab views
    Should have a Controller variable for each of its tabbed views
    Should have a protocol for being able to call functions in each tabbed view
    Ex. Playlist Delegate so it can add songs to the playlist in the playlist view
*/
class TabBarController : UITabBarController, PlaylistDelegate {
    var session : SPTSession!
    var playlistController : PlaylistViewController?
    var searchController : SearchViewController?
    
    /*
        Saves all its tab controllers in variables and sets the Home tab as the selected one
    */
    override func viewDidLoad() {
        let controllers = self.viewControllers
        for controller in controllers! {
            if controller.title == "PlaylistViewController"{
                self.playlistController = controller as? PlaylistViewController
            }else if controller.title == "SearchViewController"{
                self.searchController = controller as? SearchViewController
            }
        }
        self.selectedViewController = self.playlistController
    }
    
    //MARK: - Playlist Delegate functions
    func addToPlaylist(track partialTrack : SPTPartialTrack){
        self.playlistController!.addToPlaylist(partialTrack)
    }
}
