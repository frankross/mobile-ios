//
//  IMSocialNetworkManager.h
//  InstaMed
//
//  Created by Yusuf Ansar on 23/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger ,IMSocialChannelLoginType)
{
    IMSocialLoginNone,
    IMSocialLoginUsingFacebook,
    IMSocialLoginUsingGoogle
};

@protocol IMSocialNetworkManagerDelegate <NSObject>

@optional
// function to call when social login succeeds
- (void)loginDidSuccedWithUserDetails:(NSDictionary *)userDictionary forType:(IMSocialChannelLoginType)type;

@end


/**
 *  Class for managing social network loging using facebook & google plus
 */
@interface IMSocialNetworkManager : NSObject

@property (nonatomic,weak) id<IMSocialNetworkManagerDelegate> delegate;

+ (IMSocialNetworkManager *)sharedManager;

- (void)loginToSocialChannel:(IMSocialChannelLoginType)channel fromViewController:(UIViewController *)viewController;
- (void)logoutFacebook;

@end
