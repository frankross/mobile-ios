//
//  IMPrescription.m
//  InstaMed
//
//  Created by Suhail K on 30/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderPrescription.h"

@implementation IMOrderPrescription

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.escalationReason = dictionary[@"escalation_reason"];
        self.imageUrlStr = dictionary[@"image_url"];
    }
    return self;
}

@end
