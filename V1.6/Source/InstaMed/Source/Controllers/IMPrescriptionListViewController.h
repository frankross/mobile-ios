//
//  IMPrescriptionListViewController.h
//  InstaMed
//
//  Created by Suhail K on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing user's prescription list.

#import "IMBaseViewController.h"

@interface IMPrescriptionListViewController : IMBaseViewController

@property (nonatomic, assign) BOOL isDeepLinkingPush;
@property (nonatomic, strong) NSNumber *identifier;

@end
