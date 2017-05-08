//
//  IMUserReferralDetails.h
//  InstaMed
//
//  Created by Yusuf Ansar on 13/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMSocialSharingDetails.h"

@interface IMUserReferralDetails : IMBaseModel

@property (nonatomic, strong) NSString *referralCode;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *pointsAccured;
@property (nonatomic, assign) NSUInteger successfulReferralCount;
@property (nonatomic, strong) NSString *statusMessage;
@property (nonatomic, strong) NSNumber *FAQTopicID;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *message;

//property to hold social sharing details of the user
@property (nonatomic, strong) IMSocialSharingDetails *socialSharingDetails;

@end
