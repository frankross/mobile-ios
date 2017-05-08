//
//  IMCartCell.m
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "IMCartCellModel.h"

@implementation IMCartCellModel


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    //self.identifier =
    
    //TODO
    self.quantity = [dictionary[@"quantity"] integerValue];
    self.isPrescriptionRequired = [dictionary[@"prescription_required"] boolValue];
    self.identifier = dictionary[@"variant_id"];
    self.mrp = dictionary[@"mrp_paise"];
    self.salesPrice = dictionary[@"sales_price_paise"];
    self.totalPrice = dictionary[@"total_paise"];
    self.name = dictionary[@"variant_name"];
    
    return self;
}


-(NSDictionary*)dictionaryForAddToCart
{
    return @{@"variant_id":self.identifier, @"quantity":@(self.quantity)};
}
@end
