//
//  IMSocialSharingDetails.m
//  InstaMed
//
//  Created by Yusuf Ansar on 13/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSocialSharingDetails.h"

NSString *const IMEmailSubjectKey = @"email_subject";
NSString *const IMEmailBodyKey = @"email_body";
NSString *const IMPromotionalMessageKey = @"promotional_message";

@implementation IMSocialSharingDetails

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.emailSubject = dictionary[IMEmailSubjectKey];
        self.emailBody = dictionary[IMEmailBodyKey];
        self.promotionalMessage = dictionary[IMPromotionalMessageKey];
    }
    return self;
}

@end

