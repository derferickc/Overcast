//
//  ShowBroadcastDetailsViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/16/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class ShowBroadcastDetailsViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    let globals = Globals()
    var playlist : [[String:String]]?
    var player : SPTAudioStreamingController!
    var session : SPTSession!
    var listener : ListenerSocketDelegate!
    var broadcaster_id : String!
    var playlist_id : String!
    var broadcaster_username : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = SPTAudioStreamingController(clientId: globals.SpotifyClientID)
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedPlaylist(tracks : [[String:String]]?){
        self.playlist = tracks
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if tracks == nil {
                //error recieving broadcasts
            }else{
                self.playlist = tracks!
            }
            self.tableView.reloadData()
            print("set broadcasts")
        })
        
        
    }
    // MARK: - UI Button handlers
    @IBAction func playButtonPressed(sender: UIButton) {
        print("^_^_^_^_^_^_")
        self.listener.joinStation(self.playlist_id, broadcaster_id: broadcaster_id)
        self.listener.requestPlaybackInfo(self.playlist_id, broadcaster_id: broadcaster_id)
//        print(self.playlist![0]["spotify_uri"])
////        player.playURI(NSURL(string: playlist![0]["playable_uri"]!)) {
////            (error:NSError!) -> Void in
////            print("???")
////        }
//        //do login thing
//        player!.loginWithSession(self.session) {
//            (error: NSError!) -> Void in
//            SPTRequest.requestItemAtURI(NSURL(string: self.playlist![0]["spotify_uri"]!), withSession: nil) {
//                (error: NSError?, object:AnyObject!) -> Void in
//                let track = object as! SPTTrack
//                print(track)
//                self.player!.playURI(track.playableUri, callback: {
//                    (error:NSError!) -> Void in
//                    print("yo")
//                })
//            }
//        }
    }
    
    
    // MARK: - Table View functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.playlist != nil{
            return self.playlist!.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCellWithIdentifier("playlistTrackCell")
        let cell = dequeued as! PlaylistTrackCell
        cell.trackArtistLabel.text = self.playlist![indexPath.row]["artist"]
        cell.trackTitleLabel.text = self.playlist![indexPath.row]["title"]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
