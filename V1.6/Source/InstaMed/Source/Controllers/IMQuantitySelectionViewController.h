//
//  IMQuantitySelectionViewController.h
//  InstaMed
//
//  Created by Arjuna on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing product quandity selection.

#import "IMBaseViewController.h"
#import "IMLineItem.h"


@class IMQuantitySelectionViewController;

@protocol IMQuantitySelectionViewControllerDelegate <NSObject>

-(void)quantitySelectionController:(IMQuantitySelectionViewController*)quantitySelectionController didFinishWithWithQuanity:(NSInteger)quanity;

@end

@interface IMQuantitySelectionViewController : IMBaseViewController

@property(nonatomic,strong) IMLineItem* product;
@property(nonatomic,weak) id<IMQuantitySelectionViewControllerDelegate> delgate;

@end
