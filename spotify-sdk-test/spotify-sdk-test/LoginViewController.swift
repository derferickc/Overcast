//
//  ViewController.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/7/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    let globals = Globals()
    var ClientID : String!
    var CallBackURL : String!
    /*You will need to change these for testing on localhost or your own phone!*/
    /*Also needs to change in AppDelegate*/
    var TokenSwapURL : String!
    var TokenRefreshServiceURL :String!
    var RailsServerUrl : String!
    var session: SPTSession!
    var sentPassword : String?
    var UserID : Int?
    var BroadcastID : Int?
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var spotifyLoginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    /*
    Check if we have an Overcast Login
        If not unhide the registration stuff
        If we do call checkSpotifyAccount
    */
    override func viewDidLoad() {
        self.ClientID = globals.SpotifyClientID
        self.CallBackURL = globals.SpotifyCallbackUrl
        self.TokenRefreshServiceURL = globals.AuthenticateServer + "/refresh"
        self.TokenSwapURL = globals.AuthenticateServer + "/swap"
        self.RailsServerUrl = globals.RailsServer
        print("loaded")
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccesful", object: nil)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        /*FOR TESTING ONLY - DELETE AFTER*/
//        self.checkSpotifyAccount()
        /* ----------------------------- */
        //Hide everything
        spotifyLoginButton.hidden = true
        registerLabel.hidden = true
        usernameTextField.hidden = true
        passwordTextField.hidden = true
        confirmPasswordTextField.hidden = true
        registerButton.hidden = true
        //Check if we have Overcast username and password saved on user preferences
        let username = userDefaults.stringForKey("OvercastUsername")
        let playlistID = userDefaults.stringForKey("OvercastBroadcastingPlaylistID")
        let userID = userDefaults.stringForKey("OvercastUserID")
        if username != nil && playlistID != nil && userID != nil {
            self.UserID = Int(userID!)
            self.BroadcastID = Int(playlistID!)
            self.checkSpotifyAccount()
        }else{
//            show registration stuff
            registerLabel.hidden = false
            usernameTextField.hidden = false
            passwordTextField.hidden = false
            confirmPasswordTextField.hidden = false
            registerButton.hidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Spotify in Browser functions
    /*
        Called from the Browser
        Get newly set session from User Defaults
        Segue to Home
    */
    func updateAfterFirstLogin (){
        spotifyLoginButton.hidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){
            let sessionDataObj = sessionObj as! NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            self.segueToMainScreen()
        }
    }
    
    //MARK: - UIButton handlers
    /*
        Overcast registration button
        Creates a user on postgres if valid username and password
    */
    @IBAction func registerButtonPressed(sender: UIButton) {
        view.endEditing(true)
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        let confPassword = self.confirmPasswordTextField.text
        self.sentPassword = username
        self.loginRequest(username!, password: password!, confPassword: confPassword)
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
    
    //MARK: - HTTP send/recieve functions
    /*
        Sends a POST request with registration info to the rails server
    */
    func loginRequest(username: String, password: String, confPassword: String?){
        if let urlToReq = NSURL(string: RailsServerUrl + "/users"){
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            var bodyData = "username=\(username)"
            bodyData += "&password=\(password)"
            bodyData += "&password_confirmation=\(confPassword!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                self.handleOvercastLoginResponse(data, response: response, error: error)
            }).resume()
        }
    }
    /*
        If login was good save the username/password in userdefaults
    */
    func handleOvercastLoginResponse(data: NSData?, response: NSURLResponse?, error: NSError?){
        let json = JSON(data: data!)
        print(json)
        print(json[0]["username"])
        let username = json[0]["username"].string
        let playlistID = json[0]["playlist_id"].int
        let userID = json[0]["user_id"].int
        if username != nil && playlistID != nil && userID != nil{
            print("login success")
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(username, forKey: "OvercastUsername")
            userDefaults.setInteger(playlistID!, forKey: "OvercastBroadcastingPlaylistID")
            userDefaults.setInteger(userID!, forKey: "OvercastUserID")
            self.UserID = userID!
            self.BroadcastID = playlistID!
            self.usernameTextField.hidden = true
            self.passwordTextField.hidden = true
            self.confirmPasswordTextField.hidden = true
            self.registerButton.hidden = true
            self.registerLabel.hidden = true
            self.checkSpotifyAccount()
            return
        }
        //HANDLE INCORRECT PASSWORD OR USERNAME TAKEN
    }
    /*
        Check user defaults for spotify session
        if valid try and refresh it
        if not show the Spotify Login Button
    */
    func checkSpotifyAccount(){
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
            print("??juhkhk")
            dispatch_async(dispatch_get_main_queue()){
                self.spotifyLoginButton.hidden = false
            }
        }
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
            tabController.UserID = self.UserID
            tabController.BroadcastID = self.BroadcastID
        }
    }
}

