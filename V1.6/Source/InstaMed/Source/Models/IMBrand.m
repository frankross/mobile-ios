//
//  IMBrand.m
//  InstaMed
//
//  Created by Arjuna on 08/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBrand.h"

@implementation IMBrand


-(BOOL)isEqual:(IMBrand*)object
{
    return [self.name isEqualToString:object.name];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _imageURl = dictionary[@"brand_image_url"];
        _name = dictionary[@"brand_name"];
    }
    return self;
}

@end
