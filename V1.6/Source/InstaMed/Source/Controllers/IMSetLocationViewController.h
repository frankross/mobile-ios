//
//  IMSetLocationViewController.h
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing location setting.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"

@protocol IMSetLocationViewControllerDelegate <NSObject>

- (void)didFinishSettingLocation;

@end


@interface IMSetLocationViewController : IMBaseViewController

@property (nonatomic, weak) id<IMSetLocationViewControllerDelegate> delegate;

@end
