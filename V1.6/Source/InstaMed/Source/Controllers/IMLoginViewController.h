//
//  IMLoginViewController.h
//  InstaMed
//
//  Created by Arjuna on 15/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing user login.


#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"

@interface IMLoginViewController : IMBaseViewController

@property(nonatomic,copy) void(^loginCompletionBlock)(NSError*) ;
@property(nonatomic) BOOL hidesBackButton;

@end
