//
//  IMPharmacyViewController.h
//  InstaMed
//
//  Created by Suhail K on 04/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing product categories.

#import "IMBaseViewController.h"
@class IMNotification;

@interface IMPharmacyViewController : IMBaseViewController

- (void)pushToDetailWithNotification:(IMNotification *)notification;


@end
