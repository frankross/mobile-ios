//
//  IMDeliveryAddressViewController.h
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing delivery address,delivery slot and patient details screen.

#import "IMBaseViewController.h"
#import "IMDeliverySlot.h"
#import "IMCartManager.h"
@interface IMDeliveryAddressViewController : IMBaseViewController

@property(nonatomic,copy)void(^completionBlock)(IMDeliverySlot* deliverySlot);
@property(nonatomic,strong) IMCart* cart;
@property(nonatomic,strong) IMOrder* order;

@end
