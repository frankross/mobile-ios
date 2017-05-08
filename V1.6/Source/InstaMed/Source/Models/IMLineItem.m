//
//  IMCartCell.m
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMLineItem.h"

@implementation IMLineItem


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    //self.identifier =
    //TODO
    self.quantity = [dictionary[@"quantity"] integerValue];
    self.isPrescriptionRequired = [dictionary[@"prescription_required"] boolValue];
    self.prescriptionMessage = dictionary[@"prescription_message"];
    self.identifier = dictionary[@"variant_id"];
    self.mrp = dictionary[@"mrp"];
    self.salesPrice = dictionary[@"sales_price"];
    self.promotionalPrice = dictionary[@"promotional_price"];
    self.discountPercentage = dictionary[@"discount_percent"];

    self.totalPrice = dictionary[@"total"];
    self.unitOfSales = dictionary[@"unit_of_sale"];
    self.isPrescriptionAvailable = [dictionary[@"prescription_available"] boolValue];
    self.innerPackingQuantity = dictionary[@"inner_package_quantity"];
    self.name = dictionary[@"variant_name"];
    self.imageURL = dictionary[@"main_image_url"];

    
    self.maxOrderQuanitity = dictionary[@"max_orderable_quantity"];
    self.isAvailable = [dictionary[@"available"] boolValue];
    self.isActive = [dictionary[@"active"] boolValue];
    self.isPharma = [dictionary[@"pharma"] boolValue];
    
    self.cashback = [dictionary[@"cash_back"] boolValue];
    self.cashbackDescription = dictionary[@"cash_back_desc"];
    
    self.offerPrice = [NSNumber numberWithFloat:100.00];
    return self;
}


-(NSDictionary*)dictionaryForAddToCart
{
    if (nil == self.identifier) {
        return nil;
    }
    return @{@"variant_id":self.identifier, @"quantity":@(self.quantity)};
}
@end
