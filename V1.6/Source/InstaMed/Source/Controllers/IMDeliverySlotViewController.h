//
//  IMDeliverySlotViewController.h
//  InstaMed
//
//  Created by Arjuna on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing delivery slot selection screen.

#import "IMBaseViewController.h"
#import "IMDeliverySlot.h"
#import "IMCart.h"

@protocol  IMDeliverySlotViewControllerDelegate <NSObject>

-(void)didSelectDeliverySlot:(IMDeliverySlot*)deliverySlot;

@end

@interface IMDeliverySlotViewController : IMBaseViewController

@property(nonatomic,strong)NSNumber* deliveryAreaId;
@property (nonatomic, strong) NSNumber *fullfillmentCenterID;

@property(nonatomic,weak) id<IMDeliverySlotViewControllerDelegate> delegate;
@property(nonatomic,strong) IMCart* cart;

@end
