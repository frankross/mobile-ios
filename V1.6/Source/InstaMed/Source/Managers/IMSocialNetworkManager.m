//
//  IMSocialNetworkManager.m
//  InstaMed
//
//  Created by Yusuf Ansar on 23/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#import <GoogleSignIn/GoogleSignIn.h>
#include <FBSDKLoginKit/FBSDKLoginKit.h>
#include <FBSDKCoreKit/FBSDKCoreKit.h>
#import "IMSocialNetworkManager.h"
#import "IMLoginViewController.h"

static NSString *const IMGoogleClientID = @"894736360730-aerhuhdn0i1u07jnhjmfuh7dots36k3j.apps.googleusercontent.com";

@interface IMSocialNetworkManager () <GIDSignInDelegate,GIDSignInUIDelegate>

@property (nonatomic , strong)  FBSDKLoginManager *fbLoginManager;
@property (nonatomic, weak) IMLoginViewController *loginViewController;

@end

@implementation IMSocialNetworkManager


+(IMSocialNetworkManager *)sharedManager
{
    static IMSocialNetworkManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        GIDSignIn* signIn = [GIDSignIn sharedInstance];
        signIn.allowsSignInWithBrowser = NO;
        signIn.allowsSignInWithWebView = YES;
        signIn.shouldFetchBasicProfile = YES;
        
        signIn.clientID = IMGoogleClientID;
        signIn.scopes = @[ @"profile", @"email" ];
        signIn.delegate = sharedManager;
        signIn.uiDelegate = sharedManager;
    });
    return sharedManager;

}

/**
 *  Fuction to login with social channel
 *
 *  @param channel  :      Type of social channel
 *  @param viewController: From which view controller
 */
-(void)loginToSocialChannel:(IMSocialChannelLoginType)channel fromViewController:(UIViewController *)viewController
{
    [self logoutFacebook];
     [[GIDSignIn sharedInstance] signOut];
    if(channel == IMSocialLoginUsingFacebook)
    {
        self.fbLoginManager = [[FBSDKLoginManager alloc] init];
        self.fbLoginManager.loginBehavior = FBSDKLoginBehaviorWeb;
        self.loginViewController = (IMLoginViewController *) viewController;
        [self.fbLoginManager logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Process error %@",error);
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Cannot login through Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 
             }
             else if (result.isCancelled)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"User cancelled the facebook login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 [self returnUserDetails];

             }
         }];
    }
    
    else if (channel == IMSocialLoginUsingGoogle)
    {
        self.loginViewController = (IMLoginViewController *) viewController;
        [[GIDSignIn sharedInstance] signIn];
    }
}



/**
 @brief To logout from facebook
 @returns void
 */

- (void)logoutFacebook
{
    if(self.fbLoginManager)
    {
        [self.fbLoginManager logOut];
    }
    //force call
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}


/**
 @brief To return user details from Facebook graph API after facebook login succussfull
 @returns void
 */
-(void) returnUserDetails
{
    [self.loginViewController showActivityIndicatorView];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:@{ @"fields": @"id,name,email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        [self.loginViewController hideActivityIndicatorView];
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else
        {
            NSMutableDictionary *resultDictionary ;
            resultDictionary = [NSMutableDictionary dictionary];
            resultDictionary[@"id"] = result[@"id"];
            resultDictionary[@"email"] = result[@"email"];
            resultDictionary[@"name"] = result[@"name"];
            resultDictionary[@"accessToken"] = [[FBSDKAccessToken currentAccessToken] tokenString];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(loginDidSuccedWithUserDetails:forType:)])
            {
                [self.delegate loginDidSuccedWithUserDetails:resultDictionary forType:IMSocialLoginUsingFacebook];
            }
            
            
        }
    }];

}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    [self.loginViewController hideActivityIndicatorView];
    NSMutableDictionary *resultDictionary ;
    if(!error)
    {
        resultDictionary = [NSMutableDictionary dictionary];
        resultDictionary[@"id"] = user.userID;
        resultDictionary[@"email"] = user.profile.email;
        resultDictionary[@"name"] = user.profile.name;
        resultDictionary[@"accessToken"] = user.authentication.idToken;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(loginDidSuccedWithUserDetails:forType:)])
        {
            [self.delegate loginDidSuccedWithUserDetails:resultDictionary forType:IMSocialLoginUsingGoogle];
        }
        
    }else
    {
        [self.loginViewController hideActivityIndicatorView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    [self.loginViewController hideActivityIndicatorView];
    
}

#pragma mark - GIDSignInUIDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[self.loginViewController hideActivityIndicatorView];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self.loginViewController presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self.loginViewController dismissViewControllerAnimated:YES completion:nil];
}


         


@end
