//
//  IMCity.m
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCity.h"

static NSString* const IMNameKey = @"name";

@implementation IMCity

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.name =  [aDecoder decodeObjectForKey:IMNameKey];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:IMNameKey];
}


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.areas = [[NSMutableArray alloc] init];
        self.name = dictionary[IMNameKey];
        for (NSDictionary *areaDict in dictionary[@"areas"]) {
            IMArea *area = [[IMArea alloc] initWithDictionary:areaDict];
            [self.areas addObject:area];
        }
        self.contactNumber = dictionary[@"city"][@"customer_care_number"];
    }
    return self;
}
@end
