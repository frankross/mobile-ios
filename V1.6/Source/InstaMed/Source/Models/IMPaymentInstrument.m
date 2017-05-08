//
//  IMPaymentInstrument.m
//  InstaMed
//
//  Created by Yusuf Ansar on 06/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPaymentInstrument.h"

@implementation IMPaymentInstrument

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _ID = dictionary[@"id"];
        _name = dictionary[@"name"];
        
    }
    return self;
}


@end
