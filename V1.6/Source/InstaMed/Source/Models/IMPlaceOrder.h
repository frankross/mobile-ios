//
//  IMPlaceOrder.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMCartItem.h"

@interface IMPlaceOrder : IMBaseModel

@property (nonatomic,strong) NSArray* cartItems;
@property (nonatomic,strong) NSString* shippingAddressId;
@property (nonatomic,strong) NSString* deliverySlotId;

@end
