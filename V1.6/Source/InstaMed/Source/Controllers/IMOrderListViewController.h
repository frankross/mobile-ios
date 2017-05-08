//
//  IMOrderListViewController.h
//  InstaMed
//
//  Created by Arjuna on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing user's order list screen.

#import "IMBaseViewController.h"
#import "PaymentsSDK.h"

@interface IMOrderListViewController : IMBaseViewController <PGTransactionDelegate>

@property (nonatomic, assign) BOOL isDeepLinkingPush;
@property (nonatomic, strong) NSNumber *identifier;
@end
