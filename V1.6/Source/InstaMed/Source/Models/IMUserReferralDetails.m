//
//  IMUserReferralDetails.m
//  InstaMed
//
//  Created by Yusuf Ansar on 13/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMUserReferralDetails.h"


NSString *const IMReferralDetailsKey = @"referral_details";
NSString *const IMReferralCodeKey = @"code";
NSString *const IMReferralActiveKey = @"active";
NSString *const IMReferralUserIDKey = @"user_id";
NSString *const IMPointsAcquiredKey = @"points_accrued";
NSString *const IMSuccessfulReferralCountKey = @"successful_referral_count";
NSString *const IMStatusMessageKey = @"status_message";
NSString *const IMReferrralFAQTopicIDKey = @"faq_topic_id";
NSString *const IMSharingImageURLKey = @"image_url";
NSString *const IMMessageKey = @"message";
NSString *const IMSocialSharingDetailsKey = @"social_sharing_details";



@implementation IMUserReferralDetails

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        NSDictionary *referralDetails = dictionary[IMReferralDetailsKey];
        self.referralCode = referralDetails[IMReferralCodeKey];
        self.isActive = [referralDetails[IMReferralActiveKey] boolValue];
        self.userID = referralDetails[IMReferralUserIDKey];
        self.pointsAccured = referralDetails[IMPointsAcquiredKey];
        self.successfulReferralCount = [referralDetails[IMSuccessfulReferralCountKey] unsignedIntegerValue];
        self.statusMessage = referralDetails[IMStatusMessageKey];
        self.FAQTopicID = referralDetails[IMReferrralFAQTopicIDKey];
        self.imageURL = referralDetails[IMSharingImageURLKey];
        self.message = referralDetails[IMMessageKey];
        
         NSDictionary *socialSharingDetails = dictionary[IMSocialSharingDetailsKey];
        
        
        self.socialSharingDetails = [[IMSocialSharingDetails alloc] initWithDictionary:socialSharingDetails];
        
    }
    return self;
}

@end
