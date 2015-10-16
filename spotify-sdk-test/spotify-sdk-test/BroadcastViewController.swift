//
//  playlistViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/8/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit
import MediaPlayer

class BroadcastViewController : UIViewController, SPTAudioStreamingPlaybackDelegate, UITableViewDataSource, BackButtonDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nowPlayingAlbumLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    @IBOutlet weak var nowPlayingTrackLabel: UILabel!
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var globals = Globals()
    var ClientId : String!
    var session : SPTSession!
    var player : SPTAudioStreamingController?
    var playlist = [SPTPartialTrack]()
    var tabController : TabBarController!
    var RailsServerUrl : String!
    var forced_stop : Bool = false
    @IBOutlet weak var muteButoon: UIButton!
    var muted = false
    var playlistPosition = 0
    
    /*
        Set Spotify Session. If We aren't playing right now make play button visible.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ClientId = globals.SpotifyClientID
        self.RailsServerUrl = globals.RailsServer
        self.tableView.dataSource = self
        let tabController = self.tabBarController as! TabBarController
        self.session = tabController.session
        if self.playlist.count > 0 {
            self.resetNowPlayingInfo(partialTrack: self.playlist[0])
        }
        if self.player == nil {
            self.player = SPTAudioStreamingController(clientId: ClientId)
            self.player!.playbackDelegate = self
        }
        self.playButton.hidden = true
    }
    
    //MARK: - UI Button Handlers
    @IBAction func nextButtonClicked(sender: UIButton) {
        self.forced_stop = true
        self.player?.stop(nil)
        if self.playlist.first != nil{
            self.playlistPosition++
//            self.playlist.removeFirst()
            self.playNextSong()
            self.tableView.reloadData()
        }else{
            //Set all info to empty
        }
    }
    @IBAction func playButtonClicked(sender: UIButton) {
        print("clicked play")
        self.tabController.beginBroadcast()
        self.playNextSong()
        sender.hidden = true
    }
    @IBAction func muteButtonPressed(sender: UIButton) {
        if self.muted == false{
            self.toggleMute()
            self.muteButoon.setTitle("Unmute", forState: UIControlState.Normal)
        }else{
            self.toggleMute()
            self.muteButoon.setTitle("Mute", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func changeTabToSearchController(sender: UIButton) {
        self.tabController.changeTabToSearch()
    }
    //MARK: - Table View functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlist.count-1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued : AnyObject = tableView.dequeueReusableCellWithIdentifier("playlistTrackCell",forIndexPath: indexPath)
        let cell = dequeued as! PlaylistTrackCell
        cell.trackArtistLabel.text = self.playlist[indexPath.row].artists[0].name
        cell.trackTitleLabel.text = self.playlist[indexPath.row].name!
        if indexPath.row < self.playlistPosition {
            cell.backgroundColor = .grayColor()
        }else{
            cell.backgroundColor = .whiteColor()
        }
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.playlist.removeAtIndex(indexPath.row + 1)
        self.tableView.reloadData()
    }
    
    //MARK: - Playback functions
    
//    func playPartial(track partialTrack : SPTPartialTrack, withSession session : SPTSession!){
//        print("in playlist view controller")
//        if self.player == nil {
//            self.player = SPTAudioStreamingController(clientId: ClientId)
//            self.player!.playbackDelegate = self
//        }
//        if self.player!.isPlaying {
//            print("is playing was true")
//            self.forced_stop = true
//            self.player!.stop(nil)
//            self.playlist[0] = partialTrack
//        }else{
//            print("is playing was false")
//            self.playlist.insert(partialTrack, atIndex: 0)
//        }
//        self.playNextSong()
//    }
    /*
        Can be called from other views
    */
    func addToPlaylist(partialTrack: SPTPartialTrack){
        self.playlist.append(partialTrack)
        if self.playlist.count == 1 {
            self.resetNowPlayingInfo(partialTrack: partialTrack)
            if !self.player!.isPlaying{
               self.playButton.hidden = false
            }
        }
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    /*
        Requests the first song in the playlist's stream
        Start playing it
    */
    func playNextSong() {
        self.playButton.hidden = true
        if self.playlist.count - self.playlistPosition > 1 {
            let partialTrack = self.playlist[self.playlistPosition]
            player!.loginWithSession(self.session) { (error: NSError!) -> Void in
                SPTRequest.requestItemFromPartialObject(partialTrack, withSession: nil, callback: { (error:NSError!, results: AnyObject!) -> Void in
                    let track = results as! SPTTrack
                    /*play track*/
                    print("playing track...")
                    self.player!.playURI(track.playableUri, callback: { (error: NSError!) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        print("got response from player??")
                    })
                    /*update command center and view*/
                    self.resetNowPlayingInfo(track: track)
                })
            }
        }
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
//    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
//        print("DID CHANGE TO TRACK")
//        if trackMetadata != nil {
//            print(trackMetadata["SPTAudioStreamingMetadataTrackName"])
//            
//        }
//    }
    
    /*
        Called when a track stops
        forced stop is true when someone clicked next
        if the song finished, remove it from the playlist and play the next song
    */
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        print("DID STOP PLAYING TRACK")
        if (!self.forced_stop){
            if (self.playlist.count > 0){
                self.playlist.removeFirst()
                self.playNextSong()
            }
        }
        self.forced_stop = false
    }
    
    /*
        Called when a track failed to play
        Skip it and play the next song
    */
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        print("DID FAIL TO PLAY TRACK")
        if (self.playlist.count > 0){
            self.playlist.removeFirst()
            self.playNextSong()
        }
    }
//    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!) {
//        print("DID START PLAYING TRACK")
//    }
    
    /*
        Reset now playing info with track metadata if its already playing
    */
    func resetNowPlayingInfo(metadata trackMetadata : [NSObject : AnyObject]){
        let duration = trackMetadata["SPTAudioStreamingMetadataTrackDuration"] as? Int
        let artist = trackMetadata["SPTAudioStreamingMetadataArtistName"] as? String
        let album = trackMetadata["SPTAudioStreamingMetadataAlbumName"] as? String
        let track = trackMetadata["SPTAudioStreamingMetadataTrackName"] as? String
        nowPlayingTrackLabel.text = track
        nowPlayingArtistLabel.text = artist
        nowPlayingAlbumLabel.text = album
        var nowPlayingInfo : [String: AnyObject]!
        nowPlayingInfo = [
            MPMediaItemPropertyPlaybackDuration : duration as! AnyObject,
            MPMediaItemPropertyTitle : track as! AnyObject,
            MPMediaItemPropertyArtist : artist as! AnyObject,
            MPMediaItemPropertyAlbumTitle : album as! AnyObject
        ]
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
    }
    /*
        Reset now playing info when it just started playing (metadata hasn't loaded yet)
    */
    func resetNowPlayingInfo(track full_track : SPTTrack){
        let duration = full_track.duration
        let artist = full_track.artists[0].name
        let track = full_track.name
        let album = full_track.album.name
        if nowPlayingTrackLabel != nil {
            nowPlayingTrackLabel.text = track
            nowPlayingArtistLabel.text = artist
            nowPlayingAlbumLabel.text = album
        }
        var nowPlayingInfo : [String: AnyObject]!
        nowPlayingInfo = [
            MPMediaItemPropertyPlaybackDuration : duration as AnyObject,
            MPMediaItemPropertyTitle : track as AnyObject,
            MPMediaItemPropertyArtist : artist as AnyObject,
            MPMediaItemPropertyAlbumTitle : album as AnyObject
        ]
        self.setNowPlayingImage(full_track.album.largestCover)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
    }
    /*
        Reset now playing info before any playing
        **This only happens when people have added tracks to the playlist but have not started playing music
    */
    func resetNowPlayingInfo(partialTrack partial : SPTPartialTrack){
        player!.loginWithSession(self.session) { (error: NSError!) -> Void in
            SPTRequest.requestItemFromPartialObject(partial, withSession: nil, callback: { (error:NSError!, results: AnyObject!) -> Void in
                let track = results as! SPTTrack
                self.resetNowPlayingInfo(track: track)
            })
        }
    }
    /*
        Asynchronously grabs the album art
    */
    func setNowPlayingImage(artwork : SPTImage?){
        if artwork != nil && self.nowPlayingImageView != nil{
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
                if let imageData = NSData(contentsOfURL: artwork!.imageURL){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.nowPlayingImageView.image = UIImage(data: imageData)
                    })
                }
            })
        }
    }
    func toggleMute(){
        if self.muted == true{
            self.player?.setVolume(1, callback: {
                (error: NSError!) -> Void in
                if error != nil{
                    print(error)
                }
            })
        }else{
            self.player?.setVolume(0, callback: {
                (error: NSError!) -> Void in
                if error != nil{
                    print(error)
                }
            })
        }
        self.muted = !self.muted
    }
    // MARK - Back Button Delegate functions
    func backButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showListenersTableView" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController! as! ShowListenersTableViewController
            controller.backButtonDelegate = self
        }
    }
}
