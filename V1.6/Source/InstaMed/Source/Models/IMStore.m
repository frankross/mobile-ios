//
//  IMStore.m
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMStore.h"

@implementation IMStore

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.name = dictionary[@"name"];
        self.address = [[IMAddress alloc]init];
        self.address.addressLine1 = dictionary[@"address"];
        self.timing = dictionary[@"timings"];
        
        if(dictionary[@"email"]) {
            self.emails = dictionary[@"email"];
        }
        if(dictionary[@"phone"]) {
            self.phoneNumbers = dictionary[@"phone"];
        }
        self.latitude = dictionary[@"lat"];
        self.longitude = dictionary[@"long"];
    }
    return self;
}

@end
