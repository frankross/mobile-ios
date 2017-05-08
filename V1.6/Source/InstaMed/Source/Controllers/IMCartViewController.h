//
//  IMCartViewController.h
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing cart screen.

#import "IMBaseViewController.h"
#import "IMOrder.h"
#import "IMCartManager.h"

@interface IMCartViewController : IMBaseViewController

@property(nonatomic,strong) IMOrder* order;
@property(nonatomic,strong) IMCart* cart;

@property (weak, nonatomic) IBOutlet UIButton *qtyButton;


@property(nonatomic)IMCartOperationType cartOperationType;

@end
