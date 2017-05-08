//
//  IMHomeViewController.h
//  InstaMed
//
//  Created by Suhail K on 19/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing home screen.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"
@class IMNotification;

@interface IMHomeViewController : IMBaseViewController

@property (nonatomic, assign) BOOL isDefferedDeepLinkingLaunch;
@property (nonatomic, strong) IMNotification *notification;

- (void)pushToDetailWithNotification:(IMNotification *)notification;

@end
