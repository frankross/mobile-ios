//
//  IMPatient.m
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPatient.h"

@implementation IMPatient

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.name = dictionary[@"name"];
        self.age = dictionary[@"age"];
        self.weight = dictionary[@"weight"];
        self.height = dictionary[@"height"];
        self.gender = dictionary[@"gender"];
    }
    return self;
}

@end
