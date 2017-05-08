//
//  IMMoreViewController.h
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing more tab landing screen.

#import "IMBaseViewController.h"
@class IMNotification;

@interface IMMoreViewController : IMBaseViewController


- (void)pushToDetailWithNotification:(IMNotification *)notification;

@end
