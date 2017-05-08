//
//  IMCategoryProductListController.h
//  InstaMed
//
//  Created by Arjuna on 16/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing category wise product listing.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"

#import "IMProductListViewController.h"

@interface IMCategoryProductListController : IMBaseViewController

@property (nonatomic,strong) NSNumber* categoryID;
@property(nonatomic,strong) NSString* categoryName;
@property(nonatomic ) IMProductListType productListType;
@property (nonatomic,strong) NSString* brandName;
@property (nonatomic,strong) NSNumber* promtionID;


@end
