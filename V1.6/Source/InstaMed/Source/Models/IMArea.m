//
//  IMArea.m
//  InstaMed
//
//  Created by Suhail K on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMArea.h"


//"id":1061642937,
//"name":"AREA5",
//"pincode":111005

static NSString* const IMAreaIDKey = @"id";
static NSString* const IMNameKey = @"name";
static NSString* const IMPincodeKey = @"pincode";



@implementation IMArea

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.identifier = dictionary[IMAreaIDKey];
        self.name = dictionary[IMNameKey];
        self.pinCode = dictionary[IMPincodeKey];
    }
    return self;
}

@end
