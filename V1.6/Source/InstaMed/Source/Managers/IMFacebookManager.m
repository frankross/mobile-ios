//
//  IMFacebookManager.m
//  InstaMed
//
//  Created by Kavitha on 23/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "IMSettingsUtility.h"

@interface IMFacebookManager ()

@property (nonatomic, assign) BOOL isLogFacebookEvents;

@end
@implementation IMFacebookManager

+(IMFacebookManager*)sharedManager
{
    static IMFacebookManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.isLogFacebookEvents = [IMSettingsUtility isProduction];
        [FBSDKSettings enableLoggingBehavior:FBSDKLoggingBehaviorAppEvents];
        
    });
    return sharedManager;
}

- (void) logFacebookActivateAppEvent
{
    if(self.isLogFacebookEvents)
    {
        [FBSDKAppEvents activateApp];
    }
}

- (void) logFacebookRegisterEventWithRegistrationMethod:(NSString *)registrationMethod
{
    if(self.isLogFacebookEvents)
    {
        [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration parameters:@{ FBSDKAppEventParameterNameRegistrationMethod : registrationMethod }] ;
    }
}

- (void) logFacebookAddToCartEventWithContentType: (NSString *)contentType contentID: (NSString *)contentID andCurrency :(NSString *)currency
{
    if(self.isLogFacebookEvents)
    {
        
        [FBSDKAppEvents logEvent:FBSDKAppEventNameAddedToCart parameters:@{ FBSDKAppEventParameterNameCurrency    : currency,  //INR
                                                                            FBSDKAppEventParameterNameContentType : contentType,  //product name
                                                                            FBSDKAppEventParameterNameContentID   : contentID } ]; //variant id
    }
}

- (void) logFacebookInitiatedCheckOutEvent
{
    if(self.isLogFacebookEvents)
    {
        [FBSDKAppEvents logEvent:FBSDKAppEventNameInitiatedCheckout];
    }
}

- (void) logFacebookPurchasedEventWithAmount:(double )totalAmount andCurrency :(NSString *)currency
{
    if(self.isLogFacebookEvents)
    {
        [FBSDKAppEvents logPurchase:totalAmount currency:currency];
    }
}


@end
