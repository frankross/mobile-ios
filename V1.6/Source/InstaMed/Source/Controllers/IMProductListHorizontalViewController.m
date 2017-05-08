//
//  IMProductListHorizontalViewController.m
//  InstaMed
//
//  Created by Suhail K on 26/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#define PRODUCT_LIST_ROW_HEIGHT 168


#import "IMProductListHorizontalViewController.h"
#import "IMProductListCollectionViewCell.h"
#import "IMProduct.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMPharmacyManager.h"
#import "IMAccountsManager.h"
#import "IMProductListViewController.h"
#import "IMCategoryProductListController.h"
#import "IMViewMoreCollectionViewCell.h"

NSInteger const IMMaxFeaturedProductsToShow = 5;
NSInteger const IMTotalFeaturedProductsToFetch = 6;

@interface IMProductListHorizontalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation IMProductListHorizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self downloadFeed];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self downloadFeed];
}

-(void)loadUI
{
//    [self downloadFeed];
     SET_FOR_YOU_CELL_BORDER(self.viewMoreButton, APP_THEME_COLOR, 8)
    self.backgroundView.backgroundColor = [UIColor whiteColor];

}

/**
 @brief To handle featured product downloading from algolia
 @returns void
 */
-(void)downloadFeed
{
    self.modelArray = nil;
    self.modelArray = [[NSMutableArray alloc] init];
//    IMProduct *product = [[IMProduct alloc] init];
//    product.identifier = @(13361);
//    product.name = @"Kellogg's Muesli Fruit Magic 500 g";
//    product.brand = @"Kellogg'S";
//    product.manufacturer = @"Kellogg India Pvt. Ltd.";
//    product.sellingPrice = @"100";
//    product.promotionalPrice = @"100";
//    product.mrp = @"265.00";
//    product.discountPercent = @"12";
//    product.isPharma = NO;
//    product.thumbnailImageURL = @"http://emami-staging.s3.amazonaws.com/variant_images/files/000/003/326/small/HFD_412.png?1440398509";
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self.modelArray addObject:product];
//    [self updateUI];
    NSUInteger productsPerPage = IMTotalFeaturedProductsToFetch;
    NSUInteger currentPage = 0;
    if (!self.parameters) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    switch (_productListType) {
        case IMHomeScreen:
            self.parameters[IMFilterKey] = IMFeaturedKey;
            break;
        case IMSubCategoryScreen:
            self.parameters[IMFilterKey] = IMFeaturedKey;
            break;
        default:
            break;
    }
   
    [self showActivityIndicatorView];
    
    __weak IMProductListHorizontalViewController *weakself = self;
    [[IMPharmacyManager sharedManager] fetchProductsForParametrs:self.parameters inPage:currentPage productsPerPage:productsPerPage  withCompletion:^(NSArray *products, NSInteger totalPageCount,NSInteger totalProductCount, NSDictionary* facetInfo,  NSError *error) {
        
        [weakself hideActivityIndicatorView];
        
        if(!error)
        {
            [weakself.modelArray addObjectsFromArray:products];
            self.backgroundView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];

            [weakself updateUI];
        }
        else
        {
//            [self handleError:error withRetryStatus:YES];
            [weakself.modelArray removeAllObjects];
            [weakself updateUI];
        }
    }];
    
}

/**
 @brief To update `Ui after feed downlod
 @returns void
 */
-(void)updateUI
{
    self.pageController.numberOfPages = self.totalFeaturedProductstoShow;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    BOOL pager = YES;
    if(self.modelArray.count <=1)
    {
        self.pageController.hidden = YES;
        pager = NO;
    }
    else
    {
        self.pageController.hidden = NO;
        pager = YES;
    }
    if([self.delegate respondsToSelector:@selector(didLoadCollectionViewWithNumberOfRows:rowHeight: andIsPager:)])
    {
        [self.delegate didLoadCollectionViewWithNumberOfRows:self.modelArray.count rowHeight:PRODUCT_LIST_ROW_HEIGHT andIsPager:pager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageController.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pharmaProductSegue"])
    {
        ((IMPharmaDetailViewController*)segue.destinationViewController).product = (IMProduct*) sender;
    }
    else if([segue.identifier isEqualToString:@"nonPharmaProductSegue"])
    {
        ((IMNonPharmaDetailViewController*)segue.destinationViewController).selectedModel = (IMProduct*) sender;
    }
    else if([segue.identifier isEqualToString:@"IMFeaturedSegue"])
    {   
        IMProductListViewController *productListVC = (IMProductListViewController *) segue.destinationViewController;
        if([self.parameters valueForKey:IMCategoryIdKey])
        {
            productListVC.parameters =  [NSMutableDictionary dictionaryWithObject:[self.parameters valueForKey:IMCategoryIdKey] forKey:IMCategoryIdKey];
        }
        if(self.productListType == IMHomeScreen)
        {
            productListVC.productListType = IMFeaturedFromHome;
        }
        else
        {
            productListVC.productListType = IMFeaturedFromCategory;
        }
    }
    else if([segue.identifier isEqualToString:@"featuredProductSegue"])
    {
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        if([self.parameters valueForKey:IMCategoryIdKey])
        {
            productListVC.categoryID = [self.parameters valueForKey:IMCategoryIdKey];
        }
        productListVC.title =  IMFeaturedProductScreenTitle;
        if(self.productListType == IMHomeScreen)
        {
            productListVC.productListType = IMFeaturedFromHome;
        }
        else
        {
            productListVC.productListType = IMFeaturedFromCategory;
        }
    }
}

//download 6 items for placing view more button
- (NSInteger) totalFeaturedProductstoShow
{
    if (self.modelArray.count > IMMaxFeaturedProductsToShow) {
        return IMMaxFeaturedProductsToShow;
    }
    return self.modelArray.count;
}

#pragma mark - CollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.modelArray.count<=IMMaxFeaturedProductsToShow)
    {
        return self.totalFeaturedProductstoShow;
    }
    else
    {
        return self.totalFeaturedProductstoShow + 1;

    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMProduct* product = self.modelArray[indexPath.row];
    if (indexPath.row < IMMaxFeaturedProductsToShow)    {
        if(product.isPharma)
        {
            [self performSegueWithIdentifier:@"pharmaProductSegue" sender:product];
        }
        else
        {
            [self performSegueWithIdentifier:@"nonPharmaProductSegue" sender:product];
        }
        if(self.parameters[IMCategoryIdKey])
        {
            [IMFlurry logEvent:IMCategoryFeaturedTapped withParameters:@{}];
        }
        else
        {
            [IMFlurry logEvent:IMHomeFeaturedTapped withParameters:@{}];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"featuredProductSegue" sender:nil];
        if(self.parameters[IMCategoryIdKey])
        {
            [IMFlurry logEvent:IMViewMoreFeaturedCategory withParameters:@{}];
        }
        else
        {
            [IMFlurry logEvent:IMViewMoreFeaturedHome withParameters:@{}];
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < IMMaxFeaturedProductsToShow) {
        IMProductListCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductThumbCell" forIndexPath:indexPath];
        collectionViewCell.model = self.modelArray[indexPath.row];
       
        return collectionViewCell;
    }
    else
    {
        IMViewMoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMFeaturedViewMoreCell" forIndexPath:indexPath];
        cell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.imageView.layer.borderWidth = 0.50;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (indexPath.row < IMMaxFeaturedProductsToShow)
    {
        size = CGSizeMake(120,PRODUCT_LIST_ROW_HEIGHT);
    }
    else
    {
        size = CGSizeMake(44,PRODUCT_LIST_ROW_HEIGHT);

    }
    return size;
}


-(void)showActivityIndicatorView
{
    if(self.activityIndicator == nil)
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.center = self.view.center;
        [self.activityIndicator hidesWhenStopped];
        self.activityIndicator.color = [UIColor colorWithRed:46.0/255.0 green:89.0/255.0 blue:82.0/255.0 alpha:1.0];
    }
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.view.userInteractionEnabled = NO;
    
}

-(void)hideActivityIndicatorView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [self.activityIndicator removeFromSuperview];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    self.view.userInteractionEnabled = YES;


}

- (IBAction)viewMorePressed:(UIButton *)sender
{

}

@end
