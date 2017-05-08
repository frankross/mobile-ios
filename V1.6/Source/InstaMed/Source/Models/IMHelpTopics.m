//
//  IMHelpTopics.m
//  InstaMed
//
//  Created by Yusuf Ansar on 08/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMHelpTopics.h"

NSString *const IMHelpTopicsNameKey = @"name";

@implementation IMHelpTopics

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _name = dictionary[IMHelpTopicsNameKey];
    }
    return self;
}

@end
