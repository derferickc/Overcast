//
//  SearchResultTrackTableViewCell.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/13/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class SearchResultTrackTableViewCell: UITableViewCell {
    var addToPlaylistDelegate : SearchViewController!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBAction func addToPlaylistButtonPressed(sender: UIButton) {
        addToPlaylistDelegate.addToPlaylist(self)
    }
}
