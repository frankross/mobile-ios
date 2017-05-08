//
//  IMOrderSuccessViewController.h
//  InstaMed
//
//  Created by Arjuna on 01/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing order success(Thank you) screen.


#import "IMBaseViewController.h"

@interface IMOrderSuccessViewController : IMBaseViewController

@property (nonatomic,strong) NSNumber* orderId;
@property (nonatomic) BOOL orderRevise;
@property (nonatomic, strong) NSString *selectedPaymentMethod;

@end
