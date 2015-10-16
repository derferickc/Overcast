//
//  SearchResultsArtistOrAlbumTableViewCell.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/13/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class SearchResultsArtistOrAlbumTableViewCell: UITableViewCell {
    var moreDetailsDelegate : SearchViewController!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func moreDetailsButtonPressed(sender: UIButton) {
        print("pressed!")
        self.moreDetailsDelegate.moreDetailsButtonPressedFrom(self)
    }
}
