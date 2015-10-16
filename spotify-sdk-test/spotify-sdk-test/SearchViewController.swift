//
//  SearchViewControllerBETA.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/13/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ShowArtistOrAlbumDetailsDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var session : SPTSession!
    var searchResults = [SPTPartialObject]()
    var tabController : TabBarController?
    var lastSearchType : SPTSearchQueryType?
    var lastSearchString : String?
    
    /*
        Set session
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tabController = tabBarController as? TabBarController
        self.session = self.tabController!.session
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View functions
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.searchResults.count
    }
    /*
        Setup search results cell depending on search type
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.lastSearchType == SPTSearchQueryType.QueryTypeTrack{
            let dequeued : AnyObject = tableView.dequeueReusableCellWithIdentifier("searchResultTrackCell",forIndexPath: indexPath)
            let cell = dequeued as! SearchResultTrackTableViewCell
            let track = searchResults[indexPath.row] as! SPTPartialTrack
            cell.titleLabel.text = track.name
            cell.artistLabel.text = track.artists[0].name
            cell.addToPlaylistDelegate = self
            return cell
        } else if self.lastSearchType == SPTSearchQueryType.QueryTypeArtist{
            let dequeued : AnyObject = tableView.dequeueReusableCellWithIdentifier("searchResultArtistOrAlbumCell",forIndexPath: indexPath)
            let cell = dequeued as! SearchResultsArtistOrAlbumTableViewCell
            let artist = searchResults[indexPath.row] as! SPTPartialArtist
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.nameLabel!.text = artist.name
            cell.moreDetailsDelegate = self
            return cell
        } else{
            let dequeued : AnyObject = tableView.dequeueReusableCellWithIdentifier("searchResultArtistOrAlbumCell",forIndexPath: indexPath)
            let cell = dequeued as! SearchResultsArtistOrAlbumTableViewCell
            let album = searchResults[indexPath.row] as! SPTPartialAlbum
            cell.nameLabel!.text = album.name
            cell.moreDetailsDelegate = self
            return cell
        }
    }
    /*
        Had to set the cell height manually, not sure why
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    // MARK: - Search functions
    /*
        Search tracks/artists/albums depending on the segment control
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if self.searchBar.text == nil || self.searchBar.text == ""{
            self.searchResults = [SPTPartialObject]()
            self.tableView.reloadData()
            return
        }
        self.view.endEditing(true)
        let selectedSegmentedControlSelectedTitle = searchTypeSegmentedControl.titleForSegmentAtIndex(searchTypeSegmentedControl.selectedSegmentIndex)
        var searchType : SPTSearchQueryType
        if selectedSegmentedControlSelectedTitle == "Artists"{
            searchType = SPTSearchQueryType.QueryTypeArtist
            self.lastSearchType = SPTSearchQueryType.QueryTypeArtist
        }else if selectedSegmentedControlSelectedTitle == "Albums"{
            searchType = SPTSearchQueryType.QueryTypeAlbum
            self.lastSearchType = SPTSearchQueryType.QueryTypeAlbum
        }else{
            searchType = SPTSearchQueryType.QueryTypeTrack
            self.lastSearchType = SPTSearchQueryType.QueryTypeTrack
        }
        if let queryString = searchBar.text{
            SPTRequest.performSearchWithQuery(queryString, queryType: searchType, offset: 0, session: nil, callback: { (error:NSError!, result: AnyObject!) -> Void in
                let resultListPage = result as! SPTListPage
                let partials = resultListPage.items as! [SPTPartialObject]
                self.searchResults = partials
                self.tableView.reloadData()
            })
        }
    }
    // MARK: - UIButton handlers
    func addToPlaylist(cell : UITableViewCell){
        let indexPath = self.tableView.indexPathForCell(cell)
        let track = self.searchResults[indexPath!.row] as! SPTPartialTrack
        self.tabController?.addToPlaylist(track: track)
    }
    
    // MARK: - Segmented Control functions
    @IBAction func segmentedControlSelectionChanged(sender: UISegmentedControl) {
        let selectedSegmentTitle = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        if selectedSegmentTitle == "Songs"{
            self.lastSearchType = SPTSearchQueryType.QueryTypeTrack
        }else if selectedSegmentTitle == "Artists"{
            self.lastSearchType = SPTSearchQueryType.QueryTypeArtist
        }else {
            self.lastSearchType = SPTSearchQueryType.QueryTypeAlbum
        }
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    // MARK: - Show Artist Or Album Details Delegate functions
    func moreDetailsButtonPressedFrom(sender: SearchResultsArtistOrAlbumTableViewCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
        if self.lastSearchType == SPTSearchQueryType.QueryTypeArtist{
            let artist = self.searchResults[indexPath!.row] as! SPTPartialArtist
            performSegueWithIdentifier("showArtistOrAlbumDetails", sender: artist)
        }else if self.lastSearchType == SPTSearchQueryType.QueryTypeAlbum{
            let album = self.searchResults[indexPath!.row] as! SPTPartialAlbum
            performSegueWithIdentifier("showArtistOrAlbumDetails", sender: album)
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArtistOrAlbumDetails"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailsViewController = navigationController.topViewController as! ArtistOrAlbumDetailsTableViewController
            if let artist = sender as? SPTPartialArtist{
                detailsViewController.partialArtist = artist
            }
            if let album = sender as? SPTPartialAlbum{
                detailsViewController.partialAlbum = album
            }
            detailsViewController.broadcastDelegate = tabController!
            detailsViewController.dismissDelegate = self
        }
    }
    
}
