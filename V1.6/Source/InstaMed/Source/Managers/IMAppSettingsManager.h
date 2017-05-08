//
//  IMAppSettingsManager.h
//  InstaMed
//
//  Created by Yusuf Ansar on 06/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

/**
 @brief Class to manage App settings.
 */

@interface IMAppSettingsManager : NSObject


@property (nonatomic, strong, readonly) NSString *appShareSubject;
@property (nonatomic, strong, readonly) NSString *appShareMessage;
@property (nonatomic, strong, readonly) NSString *productShareSubject;
@property (nonatomic, strong, readonly) NSString *productShareMessage;
@property (nonatomic, strong, readonly) NSString *appSharingLinkTitle;
@property (nonatomic, strong, readonly) NSString *appSharingLinkDescription;
@property (nonatomic, strong, readonly) NSString *appSharingLinkImageURL;
@property (nonatomic, strong, readonly) NSString *referralLinkTitle;
@property (nonatomic, strong, readonly) NSString *referralLinkDescription;
@property (nonatomic, strong, readonly) NSString *referralLinkImageURL;

+ (IMAppSettingsManager *) sharedManager;


- (BOOL)isShowRedeem;
-(void) fetchAppSettingsDetailswithCompletion:(void (^)(NSError *))completion;

@end
