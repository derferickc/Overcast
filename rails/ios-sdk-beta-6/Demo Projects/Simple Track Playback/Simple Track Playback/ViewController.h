//
//  ViewController.h
//  Empty iOS SDK Project
//
//  Created by Daniel Kennett on 2014-02-19.
//  Copyright (c) 2014 Your Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface ViewController : UIViewController<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>

-(void)handleNewSession:(SPTSession *)session;

@end
