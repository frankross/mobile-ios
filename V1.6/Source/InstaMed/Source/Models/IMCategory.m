//
//  IMCategory.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

NSString* const IMCategoryNameKey = @"name";
NSString* const IMSubCategoriesKey = @"children";
NSString* const IMIsPharmaProductKey = @"pharmacy";
NSString* const IMImageURLKey = @"category_image_url";
NSString* const IMHomeIconImageURLKey = @"home_page_icon_url";
#import "IMCategory.h"
#import "NSString+IMStringSupport.h"


@implementation IMCategory

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.name = [dictionary[IMCategoryNameKey] capitalizeFirstLetter];
        
        self.isPharmaProduct = [dictionary[IMIsPharmaProductKey] boolValue];
        NSArray* children = dictionary[IMSubCategoriesKey];
        if(children.count)
        {
            self.subCategories = [NSMutableArray array];
        }
        for (NSDictionary* categoryDictionary in children)
        {
            [self.subCategories addObject:[[IMCategory alloc] initWithDictionary:categoryDictionary] ];
        }
        
        self.imageURL = dictionary[IMImageURLKey];
        self.homeIconImageURL = dictionary[IMHomeIconImageURLKey];
    }
    return self;
}

@end
