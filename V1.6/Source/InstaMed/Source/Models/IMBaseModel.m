//
//  IMBaseModel.m
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

NSString* const IMIdentifierKey = @"id";


@implementation IMBaseModel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.identifier =  [aDecoder decodeObjectForKey:IMIdentifierKey];
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:IMIdentifierKey];
}



-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        self.identifier = dictionary[IMIdentifierKey];
    }
    return self;
}

-(NSMutableDictionary*)dictinaryRepresentation;
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    if(self.identifier)
    {
        dictionary[IMIdentifierKey] = self.identifier;
    }
    return dictionary;
}


@end
