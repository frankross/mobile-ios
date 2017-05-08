//
//  IMDeviceManager.h
//  InstaMed
//
//  Created by Suhail K on 16/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

//To manage device related things.
@interface IMDeviceManager : NSObject

+ (IMDeviceManager *)sharedManager;

-(NSString*)deviceToken;

-(void)setDeviceToken:(NSString*)token;

- (void)registerDeviceWithCompletion:(void(^)(NSError* error))completion;
- (void)unRegisterDeviceWithCompletion:(void(^)(NSError* error))completion;

@end
