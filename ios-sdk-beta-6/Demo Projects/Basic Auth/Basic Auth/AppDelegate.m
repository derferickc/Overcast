//
//  AppDelegate.m
//  Basic Auth
//
//  Created by Daniel Kennett on 02/08/2012.

/*
 This project is a simple project that does nothing but authenticate a user against the Spotify
 OAuth authentication service.
 */

#import "AppDelegate.h"
#import <Spotify/Spotify.h>

// For information on generating a client ID and callback URL,
// and setting up a token swap service, see the Spotify iOS SDK's documentation.
#warning You're using example credentials, please replace these with your own and remove this warning.
static NSString * const kClientId = @"e6695c6d22214e0f832006889566df9c";
static NSString * const kCallbackURL = @"spotifyiossdkexample://";
// If you're hosting your token swap service somewhere other than running the default script
// on this Mac, make sure you change the URL below as appropriate.
static NSString * const kTokenSwapServiceURL = @""; // or http://localhost:1234/swap if you want to use the example service

@implementation AppDelegate

-(IBAction)logIn:(id)sender {

	/*
	 STEP 1: Get a login URL from SPAuth and open it in Safari. Note that you must open
	 this URL using -[UIApplication openURL:].
	 */
    
    NSURL *loginURL;
    if (kTokenSwapServiceURL == nil || [kTokenSwapServiceURL isEqualToString:@""]) {
        // If we don't have a token exchange service, we need to request the token response type.
        loginURL = [[SPTAuth defaultInstance]  loginURLForClientId:kClientId
                                               declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                                            scopes:self.selectedScopes
                                                  withResponseType:@"token"];
    }
    else {
        loginURL = [[SPTAuth defaultInstance]  loginURLForClientId:kClientId
                                               declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                                            scopes:self.selectedScopes];
        
    }
    
    [[UIApplication sharedApplication] openURL:loginURL];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

	SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
		// This is the callback that'll be triggered when auth is completed (or fails).

		if (error != nil) {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Authentication Failed"
                                                           message:[NSString stringWithFormat:@"%@\n\n Are you sure your token swap service is set up correctly?",
                                                                    error.userInfo[NSLocalizedDescriptionKey]]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [view show];

			return;
		}

		[self performTestCallWithSession:session];
	};

	/*
	 STEP 2: Handle the callback from the authentication service. -[SPAuth -canHandleURL:withDeclaredRedirectURL:]
	 helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
	 
	 Make sure the token swap endpoint URL matches your auth service URL.
	 */
    
    
    
    
	if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
		[[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
                                            tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapServiceURL]
        														 callback:authCallback];
        return YES;
	}

	return NO;
}

-(void)performTestCallWithSession:(SPTSession *)session {

	/*
	 STEP 3: Execute a simple authenticated API call using our new credentials.
	 */
	[SPTRequest userInformationForUserInSession:session callback:^(NSError *error, SPTUser *user) {

        if (error != nil) {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Getting User Info Failed"
                                                           message:error.userInfo[NSLocalizedDescriptionKey]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [view show];
            return;
        }


        NSString *userDetailsString = [NSString stringWithFormat:@""
                                       "Display name: %@\n"
                                       "Canonical name: %@\n"
                                       "Territory: %@\n"
                                       "Email: %@\n"
                                       "Images: %@ images\n"
                                       "Product: %@",
                                       user.displayName, user.canonicalUserName, user.territory, user.emailAddress, @(user.images.count), [self stringFromProduct:user.product]];

        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"User Information"
                                                       message:userDetailsString
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [view show];

    }];
}

-(NSString *)stringFromProduct:(SPTProduct)product {
    switch (product) {
        case SPTProductFree:
            return @"Free";
            break;
        case SPTProductPremium:
            return @"Premium";
            break;
        case SPTProductUnlimited:
            return @"Unlimited";

        default:
            return @"Unknown";
            break;
    }
}

#pragma mark - UIApplication

#define S(s) @#s

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.scopes = @[SPTAuthUserReadPrivateScope, SPTAuthUserReadEmailScope];
    self.scopeDisplayNames = @[S(SPTAuthUserReadPrivateScope), S(SPTAuthUserReadEmailScope)];
    self.selectedScopes = [NSMutableArray new];
    [self.tableView reloadData];

    if (kClientId.length == 0 || kCallbackURL.length == 0) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Missing Details!"
                                                       message:
                             @"This demo app will not work until you fill in your "
                             "Client ID and Callback URL in the constants at the top "
                             "of AppDelegate.m.\n\n For more information, consult the "
                             "SDK's documentation or the Spotify developer website."
                                                      delegate:nil
                                             cancelButtonTitle:@"Quit"
                                             otherButtonTitles:nil];
        view.delegate = self;
        [view show];
    } else {
        // Check the Info.plist for auth callback
        BOOL found = NO;
        for (NSDictionary *handler in [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"]) {
            NSArray *schemes = handler[@"CFBundleURLSchemes"];
            for (NSString *scheme in schemes) {
                if ([kCallbackURL hasPrefix:scheme]) {
                    found = YES;
                    break;
                }
            }
        }

        if (!found) {

            NSString *callbackURLPrefix = [[kCallbackURL componentsSeparatedByString:@":"] firstObject];

            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Missing Callback URL Handler!"
                                                           message:
                                 [NSString stringWithFormat:@"This demo app will not work until "
                                 "you add your client callback's URL scheme (the '%@' part of '%@') "
                                 "to the application's handled URL types, either in the target's "
                                 "'Info' pane or directly in the Info.plist file.\n\n "
                                 "For more information, consult the SDK's documentation or the "
                                  "Spotify developer website.", callbackURLPrefix, kCallbackURL]
                                                          delegate:nil
                                                 cancelButtonTitle:@"Quit"
                                                 otherButtonTitles:nil];
            view.delegate = self;
            [view show];
        }
    }

    return YES;
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Quit"]) {
        exit(0);
    }
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scopes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = self.scopeDisplayNames[indexPath.row];
    if ([self.selectedScopes containsObject:self.scopes[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *scope = self.scopes[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectedScopes containsObject:scope]) {
        [self.selectedScopes removeObject:scope];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.selectedScopes addObject:scope];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end







// Check you out - reading all of the code in the example! I don't have anything to offer you except
// some Internet kudos points - tweet me @iKenndac to claim them.
