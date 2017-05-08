//
//  IMDeviceManager.m
//  InstaMed
//
//  Created by Suhail K on 16/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDeviceManager.h"
#import "IMUser.h"
#import "IMServerManager.h"

@implementation IMDeviceManager


+(IMDeviceManager*)sharedManager
{
    static IMDeviceManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
   
    });
    return sharedManager;
}

-(NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:IMDeviceTokenKey];
}

-(void)setDeviceToken:(NSString *)token
{
    if(token)
    {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:IMDeviceTokenKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IMDeviceTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)registerDeviceWithCompletion:(void(^)(NSError* error))completion
{

    NSString *token = [self deviceToken];
    NSDictionary *deviceDictionary;
    if(!token)
    {
       token = @"abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70";
    }
    deviceDictionary = @{@"device" : @{ IMTokenKey:token,
                                        IMDeviceTypeKey:@"ios",
                                        IMAppVersionKey : [[IMServerManager sharedManager] currentAPIVersion]}};
    [[IMServerManager sharedManager] registerDeviceWithDictionary:deviceDictionary andCompletion:^(NSError *error) {
        
        
    }];
}

- (void)unRegisterDeviceWithCompletion:(void(^)(NSError* error))completion
{
    NSString *token = [self deviceToken];
//    NSString *token = @"abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70";

    [[IMServerManager sharedManager] unRegisterDeviceWithDictionary:token andCompletion:^(NSError *error) {
        
        
    }];
}

@end
