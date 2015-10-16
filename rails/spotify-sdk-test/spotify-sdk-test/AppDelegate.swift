//
//  AppDelegate.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/7/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let ClientID = "eca84f057c5e43f7a990d771752d2885"
    let CallBackURL = "spotifysdktest://returnafterlogin"
    let TokenSwapURL = "http://192.168.1.160:1234/swap" //THIS WILL CHANGE WHEN RUNNING ON MY PHONE
    let TokenRefreshServiceURL = "http://192.168.1.160:1234/refresh"

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("??")
        if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: CallBackURL)){
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: TokenSwapURL), callback: {(error:NSError!,session:SPTSession!)-> Void in
                print("!!")
                if error != nil {
                    print("AUTH ERROR")
                    print(error)
                    return
                }
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                userDefaults.setObject(sessionData, forKey: "SpotifySession")
                userDefaults.synchronize()
                
                NSNotificationCenter.defaultCenter().postNotificationName("loginSuccesful", object: nil)
            })
        }
        return false
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

