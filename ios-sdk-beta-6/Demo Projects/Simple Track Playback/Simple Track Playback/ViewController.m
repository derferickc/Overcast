//
//  ViewController.m
//  Empty iOS SDK Project
//
//  Created by Daniel Kennett on 2014-02-19.
//  Copyright (c) 2014 Your Company. All rights reserved.
//

#import "Config.h"
#import "ViewController.h"

@interface ViewController () <SPTAudioStreamingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

-(IBAction)rewind:(id)sender {
    [self.player skipPrevious:nil];
}

-(IBAction)playPause:(id)sender {
    [self.player setIsPlaying:!self.player.isPlaying callback:nil];
}

-(IBAction)fastForward:(id)sender {
    [self.player skipNext:nil];
}

#pragma mark - Logic

-(void)updateUI {
    if (self.player.currentTrackMetadata == nil) {
        self.titleLabel.text = @"Nothing Playing";
        self.albumLabel.text = @"";
        self.artistLabel.text = @"";
    } else {
        self.titleLabel.text = [self.player.currentTrackMetadata valueForKey:SPTAudioStreamingMetadataTrackName];
        self.albumLabel.text = [self.player.currentTrackMetadata valueForKey:SPTAudioStreamingMetadataAlbumName];
        self.artistLabel.text = [self.player.currentTrackMetadata valueForKey:SPTAudioStreamingMetadataArtistName];
    }
    [self updateCoverArt];
}

-(void)updateCoverArt {
    if (self.player.currentTrackMetadata == nil) {
        self.coverView.image = nil;
        return;
    }
    
    [self.spinner startAnimating];
    
    [SPTAlbum albumWithURI:[NSURL URLWithString:[self.player.currentTrackMetadata valueForKey:SPTAudioStreamingMetadataAlbumURI]]
                   session:self.session
                  callback:^(NSError *error, SPTAlbum *album) {
                      
        NSURL *imageURL = album.largestCover.imageURL;
        if (imageURL == nil) {
            NSLog(@"Album %@ doesn't have any images!", album);
            self.coverView.image = nil;
            return;
        }
                      
        // Pop over to a background queue to load the image over the network.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            UIImage *image = nil;
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
                          
            if (imageData != nil) {
                image = [UIImage imageWithData:imageData];
            }
                          
            // …and back to the main queue to display the image.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                    self.coverView.image = image;
                    if (image == nil) {
                    NSLog(@"Couldn't load cover image with error: %@", error);
                }
            });
        });
    }];
}

-(void)handleNewSession:(SPTSession *)session {

    self.session = session;
    
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:@kClientId];
        self.player.playbackDelegate = self;
    }

    [self.player loginWithSession:session callback:^(NSError *error) {

		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}

		[SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
                         withSession:session
                            callback:^(NSError *error, id object) {

            if (error != nil) {
                NSLog(@"*** Album lookup got error %@", error);
                return;
            }

            [self.player playTrackProvider:(id <SPTTrackProvider>)object callback:nil];

        }];
	}];
}

#pragma mark - Track Player Delegates

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void) audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata {
    [self updateUI];
}

@end
