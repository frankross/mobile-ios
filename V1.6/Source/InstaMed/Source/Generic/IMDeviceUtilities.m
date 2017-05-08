//
//  IMDeviceUtilities.m
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDeviceUtilities.h"

@implementation IMDeviceUtilities

+ (void)beginIgnoringEvents
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

+ (void)endIgnoringEvents
{
    if([IMDeviceUtilities isIgnoringEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

+ (BOOL)isIgnoringEvents
{
    return [[UIApplication sharedApplication] isIgnoringInteractionEvents];
}

#pragma mark - Device Infos -

+ (BOOL)isDevicePhone
{
    static BOOL result = NO;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      result = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
                  });
    
    return result;
}

+ (BOOL)isDevicePad
{
    static BOOL result = NO;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      result = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
                  });
    
    return result;
}

+ (BOOL)isWideScreen
{
    static BOOL result = NO;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      result = (fabs((double)[[UIScreen mainScreen] bounds].size.height - 568.0f) < DBL_EPSILON);
                  });
    
    return result;
}

+ (BOOL)isRetinaDisplay
{
    static BOOL result = NO;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      result = ([UIScreen mainScreen].scale == 2.0f);
                  });
    
    return result;
}

+ (float)systemVersion
{
    static NSString *systemVersion = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      systemVersion = [[UIDevice currentDevice] systemVersion];
                  });
    
    return [systemVersion floatValue];
}

@end
