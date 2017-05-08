//
//  IMOrderSummaryScreen.h
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing order summary screen.



#import "IMBaseViewController.h"
#import "IMCart.h"

@class IMOrder;

@interface IMOrderSummaryScreen : IMBaseViewController

@property(nonatomic,strong) IMCart* cart;
@property(nonatomic,strong) IMOrder* order;

@end
