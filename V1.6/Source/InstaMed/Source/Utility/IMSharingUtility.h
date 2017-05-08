//
//  IMSharingUtility.h
//  InstaMed
//
//  Created by Yusuf Ansar on 14/09/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

/**
 *  Utility class for sharing related tasks 
 */

@interface IMSharingUtility : NSObject

+ (void)shareUsingFacebookWithURL:(NSString *)urlString andMessage:(NSString *)message;

+ (void)shareUsingTwitterWithURL:(NSString *)urlString andMessage:(NSString *)message;

+ (void)shareUSingGooglePlusWithURL:(NSString *)urlString;

+ (void)shareUsingWhatsAppWithURL:(NSString *) urlString andMessage:(NSString *)message;

@end
