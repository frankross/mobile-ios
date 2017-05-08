//
//  IMCart.m
//  InstaMed
//
//  Created by Arjuna on 25/07/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "IMCart.h"
#import "IMAccountsManager.h"

@implementation IMCart


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    dictionary = dictionary[@"cart"];
    
    self.lineItems = [NSMutableArray array];
    
    for(NSDictionary* lineItemDict in dictionary[@"line_items"])
    {
        IMLineItem* lineItem = [[IMLineItem alloc] initWithDictionary:lineItemDict];
        [self.lineItems addObject:lineItem];
        
    }
    
    self.shippingsTotal = dictionary[@"shipping_total"];
    self.cartTotal = dictionary[@"cart_total"];
    self.lineItemsTotal = dictionary[@"line_items_total"];
    self.discountTotal = dictionary[@"discount_total"];
    
    return self;
}


-(NSDictionary*)dictionaryForOrderComplete
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[@"delivery_slot_id"] = self.deliverySlot.identifier;
    dictionary[@"shipping_address_id"] = self.deliverAddress.identifier;
    dictionary[@"billing_address_id"] = self.deliverAddress.identifier;
    dictionary[@"payment_method"] = @"COD";
    if([IMAccountsManager sharedManager].currentOrderPrescriptionUploadId)
    {
            dictionary[@"prescription_upload_id"] = [IMAccountsManager sharedManager].currentOrderPrescriptionUploadId;
    }
    return @{@"order" : dictionary};
}
@end
