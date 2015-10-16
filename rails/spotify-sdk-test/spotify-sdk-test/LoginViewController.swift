//
//  ViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/7/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    let ClientID = "eca84f057c5e43f7a990d771752d2885"
    let CallBackURL = "spotifysdktest://returnafterlogin"
    /*You will need to change these for testing on localhost or your own phone!*/
    /*Also needs to change in AppDelegate*/
    let TokenSwapURL = "http://192.168.1.160/swap"
    let TokenRefreshServiceURL = "http://192.168.1.160:1234/refresh"
    var session: SPTSession!
    @IBOutlet weak var loginButton: UIButton!
    
    /*
    Check if we have a valid Spotify Premium Session
        If we don't show the Spotify Login Button
            return from spotify login -> Calls updateAfterFirstLogin
        If we do segue to Home
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccesful", object: nil)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){//Session available
            let sessionDataObj = sessionObj as! NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, withServiceEndpointAtURL: NSURL(string: TokenRefreshServiceURL)){
                    (error: NSError!,renewedSession: SPTSession!) -> Void in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        self.session = renewedSession
                        self.segueToMainScreen()
                        
                    }else{
                        print ("error refreshing session")
                    }
                }
            }else{
                print("session valid")
                self.session = session
                self.segueToMainScreen()
            }
        }else{
            loginButton.hidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Spotify in Browser functions
    
    /*
        Get newly set session from User Defaults
        Segue to Home
    */
    func updateAfterFirstLogin (){
        loginButton.hidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){
            let sessionDataObj = sessionObj as! NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            self.segueToMainScreen()
        }
    }
    /*
        Open browser to Spotify Login page
        Spotify will call updateAfterFirstLogin when finished
    */
    @IBAction func loginWithSpotify(sender: UIButton) {
        let auth = SPTAuth.defaultInstance()
        let loginURL = auth.loginURLForClientId(ClientID, declaredRedirectURL: NSURL(string: CallBackURL), scopes: [SPTAuthStreamingScope])
        UIApplication.sharedApplication().openURL(loginURL)
    }
    
    //MARK: - Navigation
    
    func segueToMainScreen(){
        dispatch_async(dispatch_get_main_queue()){
            print("segueToMainScreen")
            self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSuccessSegue" {
            let tabController = segue.destinationViewController as! TabBarController
            tabController.session = self.session
        }
    }
}

