//
//  IMCancelReasonsViewController.h
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing cancel reason screen.

#import "IMBaseViewController.h"
#import "IMCancelReason.h"


@protocol IMCancelReasonsViewControllerDelegate <NSObject>

-(void)didFinishWithCanelReason:(IMCancelReason*)cancelReason;
- (void) didDismissCancelReason;

@end


@interface IMCancelReasonsViewController : IMBaseViewController

@property(nonatomic,weak) id<IMCancelReasonsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isOrderRefundable;

@end
