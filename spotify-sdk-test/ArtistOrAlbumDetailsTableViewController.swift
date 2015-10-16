//
//  ArtistOrAlbumDetailsTableViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/14/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class ArtistOrAlbumDetailsTableViewController: UITableViewController {
    
    var partialArtist : SPTPartialArtist!
    var partialAlbum : SPTPartialAlbum!
    var broadcastDelegate : BroadcastDelegate!
    var dismissDelegate : SearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.partialArtist != nil {
            self.title = partialArtist.name
//            SPTRequest.requestItemFromPartialObject(partialArtist, withSession: nil, callback: {
//                (error:NSError!, response: AnyObject!) -> Void in
//                print("returned")
//                if error == nil{
//                    let artist = response as! SPTArtist
//                    /*Need to get territory from Spotify User*/
//                    return
////                    artist.requestTopTracksForTerritory(<#T##territory: String!##String!#>, withSession: <#T##SPTSession!#>, callback: <#T##SPTRequestCallback!##SPTRequestCallback!##(NSError!, AnyObject!) -> Void#>)
//                }
//            })
        }
        if self.partialAlbum != nil{
//            self.title = album.name
//            SPTRequest.requestItemFromPartialObject(partialAlbum, withSession: nil, callback: {
//                (error: NSError!, response: AnyObject!) -> Void in
//                print("returned")
//                if error == nil{
//                    let album = response as! SPTAlbum
//                    album
//                }
//            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: - Navigation

    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissDelegate.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
