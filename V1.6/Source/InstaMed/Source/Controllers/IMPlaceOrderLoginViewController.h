//
//  IMCartContainerViewController.h
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//Class for managing login from cart flow.

#import "IMBaseViewController.h"

@interface IMPlaceOrderLoginViewController : IMBaseViewController

@property(nonatomic,copy) void(^completionBlock)();

@end
