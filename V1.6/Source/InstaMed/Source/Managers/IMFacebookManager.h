//
//  IMFacebookManager.h
//  InstaMed
//
//  Created by Kavitha on 23/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

/**
 @brief Class to manage Facebook related tasks like analytics tracking.
 */

@interface IMFacebookManager : NSObject

/**
 @brief Returns the shared instance of IMFacebookManager
 @returns IMFacebookManager*
 */
+ (IMFacebookManager *)sharedManager;

/**
 @brief Initiates app analytics tracking, mainly to track the app installations
 */
- (void) logFacebookActivateAppEvent;

- (void) logFacebookRegisterEventWithRegistrationMethod:(NSString *)registrationMethod;

- (void) logFacebookAddToCartEventWithContentType: (NSString *)contentType contentID: (NSString *)contentID andCurrency :(NSString *)currency;

- (void) logFacebookInitiatedCheckOutEvent;

- (void) logFacebookPurchasedEventWithAmount:(double )totalAmount andCurrency :(NSString *)currency;



@end
