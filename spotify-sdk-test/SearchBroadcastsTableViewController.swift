//
//  SearchBroadcastsTableViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/16/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class SearchBroadcastsTableViewController: UITableViewController {
    
    var tabController : TabBarController!
    var broadcasts = [[String:String]]()
    var session : SPTSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabController.getAllBroadcasts()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func recieveAllBroadcasts(broadcasts: [[String:String]]?){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if broadcasts == nil {
                //error recieving broadcasts
            }else{
                self.broadcasts = broadcasts!
            }
            self.tableView.reloadData()
            print("set broadcasts")
        })
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.broadcasts.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("broadcastCell", forIndexPath: indexPath)
        cell.textLabel!.text = self.broadcasts[indexPath.row]["broadcaster_username"]! + "'s Broadcast"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let broadcast = self.broadcasts[indexPath.row]
        performSegueWithIdentifier("showBroadcastDetails", sender: broadcast)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBroadcastDetails"{
            let broadcast = sender as! [String:String]
            var navigationController = segue.destinationViewController as! UINavigationController
            var showDetailsViewController = navigationController.topViewController as! ShowBroadcastDetailsViewController
            self.tabController.getBroadcast(broadcast["playlist_id"]!, forView: showDetailsViewController)
            showDetailsViewController.session = self.session
            showDetailsViewController.listener = self.tabController
            print("in search playlist_id = " + broadcast["playlist_id"]!)
            showDetailsViewController.playlist_id = broadcast["playlist_id"]
            showDetailsViewController.broadcaster_id = broadcast["broadcaster_id"]
            showDetailsViewController.broadcaster_username = broadcast["broadcaster_username"]
        }
    }
}
