//
//  IMDeliverySlot.h
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"
#import "IMTimeSlot.h"

@interface IMDeliverySlot : IMBaseModel

@property(nonatomic,strong) NSDate* slotDate;
@property(nonatomic,strong) NSString* slotDescription;
@property(nonatomic,strong) NSString* slotId;


@end
