//
//  IMCategoryProductListController.m
//  InstaMed
//
//  Created by Arjuna on 16/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCategoryProductListController.h"
#import "IMOptionsViewController.h"
#import "IMProductFilterViewController.h"
#import "IMPharmacyManager.h"

@interface IMCategoryProductListController ()<IMProductListViewControllerDelegate,IMProductFilterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (strong,nonatomic) IMSortType* sortType;
@property (strong,nonatomic) NSDictionary* facetInfo;
@property (strong,nonatomic) NSMutableDictionary* filterDictionary;
@property (strong,nonatomic) IMProductListViewController* productListController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *filterPanelView;

@property (weak, nonatomic) IBOutlet UIView *verticalSeparatorView;
@property (weak, nonatomic) IBOutlet UIView *horizontalSeparatorView;
@end

@implementation IMCategoryProductListController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Product_List";
}

/**
 @brief To setup initail Ui elements
 @returns void
 */
-(void)loadUI
{
    [super loadUI];
    [self downloadFeed];
}

-(void)downloadFeed
{
    [self updateUI];
}

/**
 @brief To update ui after feed downloading
 @returns void
 */
-(void)updateUI
{
    self.filterDictionary = [NSMutableDictionary dictionary] ;
//    NSMutableAttributedString * filteString = [[NSMutableAttributedString alloc] initWithString:@"Filter (None)"];
//    [filteString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,7)];
//    [filteString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(7,filteString.length-7)];
//    
//    [self.filterButton setAttributedTitle:filteString forState:UIControlStateNormal];
    
    [self updateFiltersAppliedLabel];
    
    
    NSMutableAttributedString* sortString = [[NSMutableAttributedString alloc] initWithString:@"Sort (None)"];
    [sortString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,4)];
    [sortString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(4,sortString.length-4)];
    
    [self.sortButton setAttributedTitle:sortString forState:UIControlStateNormal];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"productListSegue"])
    {
        IMProductListViewController* productListVC =   (IMProductListViewController*)segue.destinationViewController;
        productListVC.productListType = self.productListType;
        productListVC.delegate = self;
        
        if(self.title)
        {
            if (self.categoryID) {
                productListVC.parameters = [@{@"category_id":self.categoryID} mutableCopy];
            }
            if(![self.brandName isEqualToString:@""] && self.brandName != nil)
            {
                NSArray *array = [[NSArray alloc] initWithObjects:self.brandName, nil];
                NSDictionary *dict = [@{IMBrandNameKey:array} mutableCopy];
                [productListVC.parameters addEntriesFromDictionary:dict];
            }
            if(self.promtionID)
            {
                if(self.categoryID)
                {
                    NSDictionary *dict = [@{IMPromotionIDKey:self.promtionID} mutableCopy];
                    [productListVC.parameters addEntriesFromDictionary:dict];
                }
                else
                {
                    productListVC.parameters = [@{IMPromotionIDKey:self.promtionID} mutableCopy];
                }
            }
        }
        self.productListController = productListVC;
    }
    
    else if([segue.identifier isEqualToString:@"IMFilterSegue"])
    {
//        [IMFlurry logEvent:IMFilterEvent withParameters:@{}];
        IMProductFilterViewController* productListFilterController = segue.destinationViewController;
        productListFilterController.facetInfo = self.facetInfo;
        productListFilterController.filterDictionary = self.filterDictionary;
        productListFilterController.delegate = self;
        if(self.productListType == IMProductListCategoryScreen )
        {
            productListFilterController.filterType = IMFromCategory;
        }
        else
        {
            productListFilterController.filterType = IMOtherScreens;
        }
    }
    else if([segue.identifier isEqualToString:@"IMProductListSortViewController"])
    {
        IMOptionsViewController* optionsViewController = segue.destinationViewController;
        if(self.sortType)
          optionsViewController.selectedOptions = @[self.sortType];
        
        optionsViewController.modelArray = [NSMutableArray array];
        
        IMSortType* type = [[IMSortType alloc] init];
        
         type = [[IMSortType alloc] init];
        type.identifier = @(3);
        type.name = @"Price: low to high";
        type.option = IMSalesPriceLowToHigh;
        [optionsViewController.modelArray addObject:type];
        
        type = [[IMSortType alloc] init];
        type.identifier = @(4);
        type.name = @"Price: high to low";
        type.option = IMSalesPriceHighToLow;
        [optionsViewController.modelArray addObject:type];

        optionsViewController.optionType = IMSort;
        __weak IMCategoryProductListController* weakSelf = self;
        optionsViewController.completionBlock = ^(NSArray* options){
            weakSelf.sortType = options[0];
            weakSelf.filterDictionary[IMSortTypeKey] = weakSelf.sortType;
            weakSelf.productListController.parameters[IMSortTypeKey] = weakSelf.sortType;
            [weakSelf.productListController reloadProductListFromServer];
            NSMutableAttributedString* sortString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Sort (%@)",self.sortType.name]];
            [sortString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,4)];
            [sortString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(4,sortString.length-4)];
            
            [self.sortButton setAttributedTitle:sortString forState:UIControlStateNormal];
        };
    }
    
}





#pragma mark - IMProductListViewControllerDelegate

/**
 @brief To setup the tableview height (delegate call back)
 @returns void
 */

-(void) didLoadTableViewWithTableViewHeight:(CGFloat)height andTotalProductCount:(NSInteger)totalProductCount andFacetInfo:(NSDictionary *)facetInfo
{
    if(!self.facetInfo)
    {
        self.facetInfo = facetInfo;
    }
    
    if(totalProductCount <= 1 && !self.productListController.filterApplied)
    {
        self.filterHeightConstraint.constant = 0;
        
    }
    else
    {
        self.filterHeightConstraint.constant = 44;
    }
}
/**
 @brief To handle filter labels
 @returns void
 */
-(void)updateFiltersAppliedLabel
{

    NSMutableAttributedString * filteString;
    
    if( [self.filterDictionary[IMBrandNameKey] count] || self.filterDictionary[IMSalesPriceMinKey] || self.filterDictionary[IMDiscountMinKey]|| [self.filterDictionary[IMPrimaryCategoryKey] count]  )
    {
         filteString = [[NSMutableAttributedString alloc] initWithString:@"Filter (Applied)"];
        [filteString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,7)];
        [filteString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(7,filteString.length-7)];

    }
    else
    {
         filteString = [[NSMutableAttributedString alloc] initWithString:@"Filter (None)"];
        [filteString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,7)];
        [filteString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(7,filteString.length-7)];

    }
    
    [self.filterButton setAttributedTitle:filteString forState:UIControlStateNormal];

}

-(void)filtersApplied
{
    if (self.categoryID)
    {
        self.productListController.parameters = [@{@"category_id":self.categoryID} mutableCopy];
    }
    else
    {
        self.productListController.parameters = [NSMutableDictionary dictionary];
    }
    
    if(self.promtionID)
    {
        if (self.categoryID)
        {
            NSDictionary *dict = [@{IMPromotionIDKey:self.promtionID} mutableCopy];
            [self.productListController.parameters addEntriesFromDictionary:dict];

        }
        else
        {
            self.productListController.parameters = [@{IMPromotionIDKey:self.promtionID} mutableCopy];
        }
    }
    [self.productListController.parameters addEntriesFromDictionary:self.filterDictionary];
    if(![self.brandName isEqualToString:@""] && self.brandName != nil)
    {
        NSArray *array = [[NSArray alloc] initWithObjects:self.brandName, nil];
        NSDictionary *dict = [@{IMBrandNameKey:array} mutableCopy];
        [self.productListController.parameters addEntriesFromDictionary:dict];
    }
    [self updateFiltersAppliedLabel];
    self.productListController.filterApplied = YES;
    [self.productListController reloadProductListFromServer];
}

- (void)filterReset
{

}

-(void)didUpdateCartButton
{
    [self updateCartButton];
    [self animateBadgeIcon];
}

@end
