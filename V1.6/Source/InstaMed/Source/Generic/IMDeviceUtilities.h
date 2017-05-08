//
//  IMDeviceUtilities.h
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IMDeviceUtilities : NSObject

+ (void)endIgnoringEvents;
+ (void)beginIgnoringEvents;
+ (BOOL)isIgnoringEvents;

+ (BOOL)isDevicePad;
+ (BOOL)isDevicePhone;

+ (BOOL)isWideScreen;
+ (BOOL)isRetinaDisplay;

+ (float)systemVersion;

@end
