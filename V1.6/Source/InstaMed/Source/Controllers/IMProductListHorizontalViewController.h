//
//  IMProductListHorizontalViewController.h
//  InstaMed
//
//  Created by Suhail K on 26/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"

typedef enum
{
    IMHomeScreen       = 0,
    IMSubCategoryScreen      = 1
}
IMProductListScreenType;

@protocol IMProductListHorizontalViewControllerDelegate <NSObject>

- (void)didLoadCollectionViewWithNumberOfRows:(CGFloat)rowCount rowHeight:(CGFloat)rowHeight andIsPager:(BOOL) pager;

@end

@interface IMProductListHorizontalViewController : IMBaseViewController

@property(nonatomic, weak) id<IMProductListHorizontalViewControllerDelegate> delegate;
@property(nonatomic ) IMProductListScreenType productListType;
@property(nonatomic,strong) NSMutableDictionary* parameters;

@end
