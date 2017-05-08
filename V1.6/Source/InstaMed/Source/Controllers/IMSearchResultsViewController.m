//
//  IMSearchResultsViewController.m
//  InstaMed
//
//  Created by Arjuna on 13/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSearchResultsViewController.h"
#import "IMProductListViewController.h"
#import "UITextField+IMSearchBar.h"
#import "IMProductFilterViewController.h"
#import "IMSortType.h"
#import "IMPharmacyManager.h"
#import "IMOptionsViewController.h"

#define COUNT_LABEL_HEIGHT 50
#define FILTER_VIEW_HEIGHT 44
#define COUNT_LABEL_ANIMATION_INTERVAL 0.2


@interface IMSearchResultsViewController () <IMProductListViewControllerDelegate,UISearchBarDelegate,IMProductFilterViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparatorView;
@property (strong,nonatomic) IMSortType* sortType;
@property (strong,nonatomic) NSMutableDictionary* filterDictionary;
@property (strong,nonatomic) IMProductListViewController* productListController;
@property (strong,nonatomic) NSDictionary* facetInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serchCountLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *filterPanelView;

@end

@implementation IMSearchResultsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMSearchResultScreenVisited withParameters:@{}];

}

-(void)loadUI
{
    [self setUpNavigationBar];
    [self addCartButton];
    [self addBackButton];
    self.screenName = @"Search_Result";
    [IMFunctionUtilities setBackgroundImage:self.searchBar withImageColor:APP_THEME_COLOR];
    NSString* searchBarText = @"";
    
    searchBarText = self.searchTerm;
    
    if(self.categoryName)
    {
        searchBarText = [NSString stringWithFormat:@"%@ in %@",searchBarText,self.categoryName];
    }
    self.searchField.text = searchBarText;
    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
    [self.searchField configureAsSearchBar];
    
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

/**
 @brief To handle filter labels
 @returns void
 */
-(void)updateFiltersAppliedLabel
{
    
    NSMutableAttributedString * filteString;
    
    if( [self.filterDictionary[IMBrandNameKey] count] || self.filterDictionary[IMSalesPriceMinKey] || self.filterDictionary[IMDiscountMinKey] || [self.filterDictionary[IMPrimaryCategoryKey] count])
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMProductListSegue"])
    {
        IMProductListViewController* productListVC = segue.destinationViewController;
        productListVC.productListType = IMSearcResulthScreen;
        productListVC.delegate = self;
        NSMutableDictionary* parameterDict = [NSMutableDictionary dictionary];
        
        if(self.searchTerm)
            parameterDict[@"search_term"]= self.searchTerm;
        
        if(self.categoryName)
             parameterDict[@"category_name"]= self.categoryName;
        productListVC.parameters = parameterDict;
        self.productListController = productListVC;

    }
    else if([segue.identifier isEqualToString:@"IMFilterSegue"])
    {
        //        [IMFlurry logEvent:IMFilterEvent withParameters:@{}];
        IMProductFilterViewController* productListFilterController = segue.destinationViewController;
        productListFilterController.facetInfo = self.facetInfo;
        productListFilterController.filterDictionary = self.filterDictionary;
        productListFilterController.delegate = self;
         productListFilterController.filterType = IMOtherScreens;
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
        __weak IMSearchResultsViewController* weakSelf = self;
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
/**
 @brief apply button delegate call back
 @returns void
 */
-(void)filtersApplied
{
    if(self.searchTerm)
    {
        self.productListController.parameters = [@{@"search_term":self.searchTerm} mutableCopy];
    }
    else
    {
        self.productListController.parameters = [NSMutableDictionary dictionary];
    }
    [self.productListController.parameters addEntriesFromDictionary:self.filterDictionary];
    [self updateFiltersAppliedLabel];
    self.productListController.filterApplied = YES;
    [self.productListController reloadProductListFromServer];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchFieldTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.screenName, @"Screen_Name",
                            nil];
    [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
}


#pragma mark - IMProductListViewControllerDelegate

/**
 @brief To setup the tableview height (delegate call back)
 @returns void
 */


-(void)didLoadTableViewWithTableViewHeight:(CGFloat)height andTotalProductCount:(NSInteger)totalProductCount andFacetInfo:(NSDictionary *)facetInfo
{
    if(!self.facetInfo)
    {
        self.facetInfo = facetInfo;
    }
    NSMutableAttributedString * filteString;
    filteString = [[NSMutableAttributedString alloc] initWithString:self.filterButton.titleLabel.text];
    
    if(totalProductCount<= 1 && !self.productListController.filterApplied)
    {
        self.filterButton.hidden = YES;
        self.sortButton.hidden = YES;
        self.verticalSeparatorView.hidden = YES;
        self.filterViewHeightConstraint.constant = 0;
    }
    else
    {
        self.filterButton.hidden = NO;
        self.sortButton.hidden = NO;
        self.verticalSeparatorView.hidden = NO;
        self.filterViewHeightConstraint.constant = FILTER_VIEW_HEIGHT;
        
    }
    if(totalProductCount > 1)
    {
        self.productCountLabel.text = [NSString stringWithFormat:@"%ld products found",(long)totalProductCount];
    }
    else if(totalProductCount == 1)
    {
        self.productCountLabel.text = [NSString stringWithFormat:@"%ld product found",(long)totalProductCount];
    }
    else
    {
        self.productCountLabel.text =  IMNoProduct;
    }
}

-(void)filterReset
{

}

-(void)didScrollTableViewDown:(BOOL)scrollDown
{
    if(scrollDown)
    {
        if(self.serchCountLabelHeightConstraint.constant == COUNT_LABEL_HEIGHT)
        {
            self.serchCountLabelHeightConstraint.constant = 0;
            [UIView animateWithDuration:COUNT_LABEL_ANIMATION_INTERVAL animations:^{
                
                [self.view layoutIfNeeded];
            }];
        }
    }
    else
    {
        if(self.serchCountLabelHeightConstraint.constant == 0)
        {
            self.serchCountLabelHeightConstraint.constant = COUNT_LABEL_HEIGHT;
            [UIView animateWithDuration:COUNT_LABEL_ANIMATION_INTERVAL animations:^{
                
                [self.view layoutIfNeeded];
            }];
        }

    }
}

-(void)didUpdateCartButton
{
    [self updateCartButton];
    [self animateBadgeIcon];
}

@end
