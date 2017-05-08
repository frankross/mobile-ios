//
//  IMSharingUtility.m
//  InstaMed
//
//  Created by Yusuf Ansar on 14/09/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Social/Social.h>
#import "IMSharingUtility.h"
#import "IMConstants.h"

@import SafariServices;


// Whatsapp URLs
static NSString *const whatsAppUrl = @"whatsapp://app";
static NSString *const whatsAppSendTextUrl = @"whatsapp://send?text=%@";
static NSString *const GooglePlusShareUrl = @"https://plus.google.com/share";

@interface IMSharingUtility () <SFSafariViewControllerDelegate>

@end

@implementation IMSharingUtility

/**
 @brief Function to share using facebook
 @returns void
 */
+ (void)shareUsingFacebookWithURL:(NSString *)urlString andMessage:(NSString *)message
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *shareSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [shareSheet setInitialText:message];
        [shareSheet addURL:[NSURL URLWithString:urlString]];
         
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
         [rootViewController presentViewController:shareSheet animated:YES completion:nil];

    }
    else
    {
        [self alertFacebookNotConfigured];
    }
    

}

/**
 @brief Function to share using twitter
 @returns void
 */
+ (void)shareUsingTwitterWithURL:(NSString *)urlString andMessage:(NSString *)message
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:message];
        [tweetSheet addURL:[NSURL URLWithString:urlString]];
        
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [self alertTwitterNotConfigured];
    }
    
}

/**
 @brief Function to share using google plus
 @returns void
 */
+ (void)shareUSingGooglePlusWithURL:(NSString *)urlString
{
    // Construct the Google+ share URL
    NSURL *shareURL = [NSURL URLWithString:urlString];
    NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                      initWithString:GooglePlusShareUrl];
    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:[shareURL absoluteString]]];
    NSURL* url = [urlComponents URL];

    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 10+)
        if(IS_IOS10_OR_ABOVE)
        {
            SFSafariViewController* controller = [[SFSafariViewController alloc]
                                                  initWithURL:url];
            //controller.delegate = self;
            
            UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [rootViewController presentViewController:controller animated:YES completion:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:url];
    }


}


/**
 @brief Function to share using whatsapp
 @returns void
 */
+ (void)shareUsingWhatsAppWithURL:(NSString *)urlString andMessage:(NSString *)message
{
    NSString *str = [NSString stringWithFormat:@"%@ %@",message,urlString];
    
    str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (CFStringRef)str,
                                                                                NULL,
                                                                                CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                kCFStringEncodingUTF8));
    
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:whatsAppSendTextUrl, str]];
    
    if ( [self isWhatsAppInstalled] ) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        [self alertWhatsappNotInstalled];
    }
}


/**
 @brief Function to check whether whatsapp is installed
 @returns BOOL
 */
+ (BOOL)isWhatsAppInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:whatsAppUrl]];
}


/**
 @brief Function to show alert
 @returns void
 */
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil];
    [alert show];
}


/**
 @brief Function to show facebook not configured alert
 @returns void
 */
+ (void)alertFacebookNotConfigured
{
    [self alertError:IMFacebookAccountNotConfiguredAlertMessage];
}


/**
 @brief Function to show Twitter not configured alert
 @returns void
 */

+ (void)alertTwitterNotConfigured
{
    [self alertError:IMTwitterAccountNotConfiguredAlertMessage];
}


/**
 @brief Function to show whatsapp not installed alert
 @returns void
 */
+ (void)alertWhatsappNotInstalled
{
    [self alertError:IMWhatsAppNotInstalledAlertMessage];
}

+ (void)alertError:(NSString *)message
{
    [self alertWithTitle:@"" message:message];
}

@end
