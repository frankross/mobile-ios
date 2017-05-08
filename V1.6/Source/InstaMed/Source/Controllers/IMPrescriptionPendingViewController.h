//
//  IMPrescriptionPendingViewController.h
//  InstaMed
//
//  Created by Suhail K on 24/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing prescription pending medicins screen.

#import "IMBaseViewController.h"
#import "IMCartManager.h"

@interface IMPrescriptionPendingViewController : IMBaseViewController

@property(nonatomic,strong) IMCart* cart;
@property(nonatomic,strong) IMOrder* order;

@end
