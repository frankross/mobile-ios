//
//  IMDoctor.m
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDoctor.h"

@implementation IMDoctor


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.name = dictionary[@"name"];
        self.regNumber = dictionary[@"regNo"];
        self.speciality = dictionary[@"speciality"];
        self.phone = dictionary[@"phone"];
        self.mobile = dictionary[@"mobile"];
        self.facility = dictionary[@"facility"];
        self.address = dictionary[@"address"];
        
    }
    return self;
}
@end
