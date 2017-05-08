//
//  IMProductListSortViewController.h
//  InstaMed
//
//  Created by Arjuna on 17/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing options like brands, offers,sort etc.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"
#import "IMOptionsTableViewCell.h"


typedef enum
{
    IMSort = 0,
    IMOffers,
    IMBrands,
    IMCat
    
}IMOptionType;

@interface IMOptionsViewController : IMBaseViewController

@property(nonatomic)IMOptionType optionType;
@property(nonatomic,copy) void(^completionBlock)(NSMutableArray* options);
@property(nonatomic,strong) NSArray* selectedOptions;

@end
