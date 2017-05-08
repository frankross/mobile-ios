//
//  IMRewardPointTransaction.m
//  InstaMed
//
//  Created by Yusuf Ansar on 12/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMRewardPointTransaction.h"

@implementation IMRewardPointTransaction

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _date = dictionary[@"date"];
        _summary = dictionary[@"summary"];
        _type = dictionary[@"type"];
        _amount = dictionary[@"amount"];
    }
    return self;
}




@end
