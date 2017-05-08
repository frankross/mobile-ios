//
//  IMOrderUpdateCart.m
//  InstaMed
//
//  Created by Kavitha on 25/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderUpdateCart.h"
#import "IMAccountsManager.h"

@implementation IMOrderUpdateCart

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        self = [super init];
    }
    else{
        self = [super initWithDictionary:dictionary];
    }

    self.canShowCoupon = false;
    self.canEditQuantity = false;
    self.canUpdateAddress = true;
    self.isNewOrder = false; // not new order
    self.screenTitle = IMReviseOrderScreenTitle;
    self.placeOrderButtonTitle = IMUpdateOrderButtontitle;
    self.shouldCheckLineItemsQuantity = NO;
    self.needToCheckForProductAvailability = NO;
    self.canRemoveLineItem = NO;
    self.cartOperationType = IMUpdateOrder;
    return self;
}

//ka if user chose prescription upload at the time of delivery then prescriptionUploadId will be nil
-(BOOL) isPrescriptionPresent
{
    return ([IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId != nil);
}

@end
