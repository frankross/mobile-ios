//
//  IMProductListViewController.h
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing product listing from algolia.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"


typedef enum
{
    IMRelatedScreen       = 0,
    IMYouMayScreen      = 1,
    IMTopSellingHomeScreen   = 2,
    IMSearcResulthScreen   = 3,
    IMProductListScreen   = 4,
    IMTopSellingListScreen,
    IMOfferProductListScreen,
    IMrecentlyOrderd,
    IMRecentlyOrderedPharmacy,
    IMProductListCategoryScreen,
    IMFeaturedFromHome,
    IMFeaturedFromCategory
}
IMProductListType;

@protocol IMProductListViewControllerDelegate <NSObject>

- (void)didLoadTableViewWithTableViewHeight:(CGFloat ) height andTotalProductCount:(NSInteger)totalProductCount andFacetInfo:(NSDictionary*)facetInfo;
- (void)didUpdateCartButton;
@optional
- (void)didScrollTableViewDown:(BOOL)scrollDown;
@end

@interface IMProductListViewController : IMBaseViewController

@property(nonatomic, weak) id<IMProductListViewControllerDelegate> delegate;
@property(nonatomic ) IMProductListType productListType;
@property(nonatomic,strong) NSMutableDictionary* parameters;
@property(nonatomic,assign) NSInteger totalProductCount;
@property (nonatomic) BOOL filterApplied;

-(void)reloadProductListFromServer;

@end
