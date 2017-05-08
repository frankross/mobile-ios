//
//  IMPharmacySubCategoryViewController.m
//  InstaMed
//
//  Created by Suhail K on 16/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPharmacySubCategoryViewController.h"
#import "IMProductListViewController.h"
#import "IMPharmacyManager.h"
#import "IMSubCategoryTableViewCell.h"
#import "IMCategoryProductListController.h"
#import "IMCategoryLevel2TableViewCell.h"
#import "IMOfferCollectionViewCell.h"
#import "IMCategoryCollectionViewCell.h"
#import "IMProductListHorizontalViewController.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import "IMOfferDetailViewController.h"

#define ROW_HEIGHT 57
#define HEADER_HEIGHT 160
#define LESS_LIMIT 4

#define TEST_BRAND_COUNT 10
#define AUTOSCROLL_FAST_INTERVAL 4

#define AUTOSCROLL_SLOW_INTERVAL 10
@interface IMPharmacySubCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,IMProductListHorizontalViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *contents;
@property (weak, nonatomic) IBOutlet RTExpandableTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (strong, nonatomic) NSArray *offers;
@property (strong, nonatomic) NSArray *brands;

@property (weak, nonatomic) IBOutlet UICollectionView *offerCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIPageControl *offerPageControl;
@property (weak, nonatomic) IBOutlet UIButton *showmorebutton;
@property (strong, nonatomic) NSMutableArray *showLessArray;
@property (strong, nonatomic) NSMutableArray *showMoreArray;
@property (weak, nonatomic) IBOutlet UIView *tableFooterView;
@property (assign, nonatomic) int selectedRow;
@property (weak, nonatomic) IBOutlet UICollectionView *brandCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *brandPageController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandViewHeight;
@property (assign, nonatomic) NSNumber* popularCount;

@property (nonatomic) NSUInteger subrowsInSelectedSection; //ka to keep track of expanded cell item count to adjust the category list table view height on back press

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation IMPharmacySubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Sub_Category";

    // Do any additional setup after loading the view.
    self.subrowsInSelectedSection = 0;
    [IMPharmacyManager sharedManager].isCatOfferLaunchDone = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self downloadFeed];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
}

- (void)loadUI
{
    [super loadUI];
//    self.showMoreArray = [self.modelArray mutableCopy];
//
//    if(self.showMoreArray.count <= LESS_LIMIT)
//    {
//        
//    }
//    else
//    {
//        self.showLessArray = [[self.modelArray
//                               subarrayWithRange:NSMakeRange(0, LESS_LIMIT)] mutableCopy];
//        [self.modelArray removeAllObjects];
//        [self.modelArray addObjectsFromArray:self.showLessArray];
//    }
    self.brandViewHeight.constant = 0;
    RTExpandableTableView *tableView = (RTExpandableTableView *)self.tableView;
    tableView.shouldExpandOnlyOneCell = YES;
    [self showActivityIndicatorView];
    SET_FOR_YOU_CELL_BORDER(self.showmorebutton, APP_THEME_COLOR, 8)
    self.showmorebutton.hidden = YES;
    [self downloadFeed];
}


/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    if (!_contents) {
//           ((IMCategory*)self.selectedModel).subCategories;
//        _contents = @[@[@[@"Hair Care", @"Hair treatment",@"Hair oil",@"Shampoo",@"Conditioner",@"Hair colour & dyes",@"All hair care"],
//                @[@"Oral Care", @"Oral treatment",@"Oral oil",@"Oral colour & dyes",@"All Oral care"],
//                        @[@"Bath & Beauty",@"Bath treatment",@"Bath oil",@"Bath Shampoo",@"All bath care"]],];
    }
//
    
  
   
//   if(self.modelArray.count)
//   {
//       [self updateUI];
//   }
//    else
//    {
        [self showActivityIndicatorView];
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        self.view.userInteractionEnabled = NO;
        [[IMPharmacyManager sharedManager] fetchSubCategoriesWithCategoryId:self.selectedModel.identifier Completion:^(NSMutableArray *categories, NSMutableArray *offers, NSMutableArray *popularBrands, NSNumber *popularCount,NSString *categoryName, NSError *error)
         {
             [self hideActivityIndicatorView];
//             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             self.view.userInteractionEnabled = YES;

             if(error)
             {
                 [self handleError:error withRetryStatus:YES];
             }
             else
             {
                 self.modelArray = categories;
                 self.showMoreArray = [self.modelArray mutableCopy];
                 self.popularCount = popularCount;
                 if(self.popularCount)
                 {
                     if(self.showMoreArray.count <= [self.popularCount integerValue])
                     {
                         
                     }
                     else
                     {
                         self.showLessArray = [[self.modelArray
                                                subarrayWithRange:NSMakeRange(0, [self.popularCount integerValue])] mutableCopy];
                         [self.modelArray removeAllObjects];
                         [self.modelArray addObjectsFromArray:self.showLessArray];
                     }
                 }

                 self.offers = offers;
                 self.brands = popularBrands;
                 [self updateUI];

                     dispatch_async(dispatch_get_main_queue(), ^(void) {
                         self.title = categoryName;
                     });
                 
             }

         }];
//    }
}

/**
 @brief To update ui after dowloading feed
 @returns void
 */
-(void)updateUI
{
    self.showmorebutton.hidden = NO;

    self.tableView.et_dataSource = self;
    self.tableView.et_delegate = self;
    
    self.offerCollectionView.dataSource = self;
    self.offerCollectionView.delegate = self;
    [self.offerCollectionView reloadData];
    
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    [self.brandCollectionView reloadData];
    
    if(self.brands.count == 0)
    {
        self.brandViewHeight.constant = 0;
    }
    else
    {
        self.brandViewHeight.constant = 200;

    }
    int headerHeight = 0;
    if(self.offers.count)
    {
        headerHeight = (7.0/18.0)*self.view.frame.size.width;
    }
    if (0 == headerHeight)
    {
        //n enable the code for offer section hiding.Once nil wont set back, so updateUI call after getiing offers
        self.tableView.tableHeaderView = nil;
    }
    else
    {
        CGRect frame = self.tableHeaderView.frame;
        frame.size.height =  (7.0/18.0)*self.view.frame.size.width;
        self.tableHeaderView.frame = frame;
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    
    //Show/Hide table footer view according to the data count
    if(self.popularCount)
    {
        if(self.showMoreArray.count <= [self.popularCount integerValue])
        {
            self.tableView.tableFooterView = nil;
        }
        else
        {
            self.tableView.tableFooterView = self.tableFooterView;;
        }
    }

    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.0 delay:0.00 usingSpringWithDamping:0.2 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableViewHeightConstraint.constant = [self.tableView numberOfSections] * ROW_HEIGHT + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
    [self.view layoutIfNeeded];
    } completion:^(BOOL finished)
     {
     }];


    //ka if a category is expanded before exiting the screen then adjust the table view height accordingly on revisiting the screen
  
//    if (0 == self.subrowsInSelectedSection)
//    {
//        self.tableViewHeightConstraint.constant = [self.tableView numberOfSections] * ROW_HEIGHT + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
//    }
//    else
//    {
//        
//        self.tableViewHeightConstraint.constant = ([self.tableView numberOfSections] + self.subrowsInSelectedSection) * ROW_HEIGHT + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
//    }
   
    self.offerPageControl.numberOfPages = self.offers.count;
    self.brandPageController.numberOfPages = self.brands.count;
    
    if(self.offers.count <= 1)
    {
        self.offerPageControl.hidden = YES;
    }
    else
    {
        self.offerPageControl.hidden = NO;
    }
    
    [self hideActivityIndicatorView];
    [self.view layoutIfNeeded];

}

#pragma mark - CollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.offerCollectionView)
    {
        return self.offers.count;
    }
    else
    {
        return self.brands.count;
    }
    return  0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.brandCollectionView)
    {
        IMBrand *brand = [self.brands objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"IMShopByBrandSegue" sender:brand];
        [IMFlurry logEvent:IMCategoryShopByBrandTapped withParameters:@{}];
    }
    else if(collectionView == self.offerCollectionView)
    {
        [IMFlurry logEvent:IMCategoryBannerTapped withParameters:@{}];

        IMOffer *offer = self.offers[indexPath.row];
        if (offer.promotionID != nil)
        {
            [self performSegueWithIdentifier:@"IMOfferSegue" sender:offer];
        }
        else
        {
            if (![offer.htmlURL isEqualToString:@""] && offer.htmlURL != nil) {
                [self performSegueWithIdentifier:@"IMOfferDetailSegue" sender:offer];
            }
        }
    }
    else
    {

    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.offerCollectionView)
    {
        IMOfferCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerCell" forIndexPath:indexPath];
        collectionViewCell.model = self.offers[indexPath.row];
        return collectionViewCell;
    }
    else
    {
        IMCategoryCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMCategoryCollectionCell" forIndexPath:indexPath];
        collectionViewCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        collectionViewCell.layer.borderWidth = 0.5;
        IMBrand *brand = self.brands[indexPath.row];
        collectionViewCell.imageView.image = [UIImage imageNamed:IMProductPlaceholderName];
        
        if(brand.imageURl != ((id)[NSNull null]))
        {
            [collectionViewCell.imageView setImageWithURL:[NSURL URLWithString:brand.imageURl]
                              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
        return collectionViewCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView == self.offerCollectionView)
    {
        size = CGSizeMake(self.view.frame.size.width, (7.0/18.0)*self.view.frame.size.width);
        return size;
    }
    else if(collectionView == self.brandCollectionView)
    {
        size = CGSizeMake(120,120);
        return size;
    }
    return size;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(RTExpandableTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [((IMCategory*)self.modelArray[indexPath.section]).subCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IMMenuCell";
    
    IMCategoryLevel2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.title.text = ((IMCategory*)self.modelArray[indexPath.section]).name;
    cell.title.textColor = APP_THEME_COLOR;
    cell.backgroundColor = [UIColor whiteColor];

    cell.isExpandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IMSubMenuCell";
    
    IMSubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.model = (IMCategory*)((IMCategory*)self.modelArray[indexPath.section]).subCategories[indexPath.subRow-1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isExpanded = NO;
    IMCategory *category = ((IMCategory*)self.modelArray[indexPath.section]);
    NSLog(@"IndexPath %ld",(long)indexPath.section);
    self.selectedRow = (int)indexPath.section;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[IMCategoryLevel2TableViewCell class]]) {
        isExpanded = [self.tableView isCellExpandedAtIndexPath:indexPath];
        if (!isExpanded) {
            self.subrowsInSelectedSection = 0;
        }
        NSDictionary *categoryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                        category.name, @"Category_Name",
                                        nil];
        [IMFlurry logEvent:IMCategoryLevel2Tapped withParameters:categoryParams];
    }
    else if ([cell isKindOfClass:[IMSubCategoryTableViewCell class]]) {
        isExpanded = YES;
    }
    
    NSInteger totalSections = [self.tableView numberOfSections];
    
    int headerHeight = 0;
    if(self.offers.count)
    {
        headerHeight = (7.0/18.0)*self.view.frame.size.width;;
    }

    [UIView animateWithDuration:0.0 delay:0.00 usingSpringWithDamping:0.2 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (isExpanded) {
            NSInteger subRowCount = [((IMCategory*)self.modelArray[indexPath.section]).subCategories count];
            self.subrowsInSelectedSection = subRowCount;
            self.tableViewHeightConstraint.constant = (subRowCount + totalSections) * ROW_HEIGHT + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
        }
        else{
            self.tableViewHeightConstraint.constant = totalSections * ROW_HEIGHT + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished)
     {
     }];
}

- (CGFloat)tableView:(RTExpandableTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"IMTopSellingSegue"])
    {
        IMCategory* currentCategory = (IMCategory*)self.selectedModel;
//
//        IMProductListViewController *productListVC = (IMProductListViewController *) segue.destinationViewController;
//        productListVC.delegate = self;
        
//        productListVC.productListType = IMTopSellingHomeScreen;
        
        IMProductListHorizontalViewController *productListVC = (IMProductListHorizontalViewController *) segue.destinationViewController;
        productListVC.delegate = self;
        productListVC.productListType = IMSubCategoryScreen;
        if(currentCategory)
        {
            productListVC.parameters =  [NSMutableDictionary dictionaryWithObject:currentCategory.identifier forKey:IMCategoryIdKey];
        }
        else
        {
            productListVC.parameters =  [NSMutableDictionary dictionaryWithObject:@(-1) forKey:IMCategoryIdKey];
        }
    }
    else if([segue.identifier isEqualToString:@"IMCategoryProductListSegue"])
    {
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        productListVC.categoryID = ((IMSubCategoryTableViewCell*)sender).model.identifier;
        productListVC.title =  ((IMSubCategoryTableViewCell*)sender).model.name;
        productListVC.productListType = IMProductListCategoryScreen;
        NSLog(@"%@",  ((IMSubCategoryTableViewCell*)sender).model.name);
        
        NSDictionary *categoryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                        ((IMSubCategoryTableViewCell*)sender).model.name, @"Category_Name",
                                        nil];
        [IMFlurry logEvent:IMCategoryLevel3Tapped withParameters:categoryParams];
    }
    else if([segue.identifier isEqualToString:@"IMShopByBrandSegue"])
    {
        IMBrand *brand = (IMBrand *)sender;
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        productListVC.categoryID = self.selectedModel.identifier;
        productListVC.title =   [brand.name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[brand.name  substringToIndex:1] uppercaseString]];
        productListVC.productListType = IMProductListScreen;
        productListVC.brandName = brand.name;
    }
    else if([segue.identifier isEqualToString:@"IMOfferDetailSegue"])
    {
        IMOffer *offer = (IMOffer *)sender;
        IMOfferDetailViewController *offerDetailVC = (IMOfferDetailViewController*) segue.destinationViewController;
        offerDetailVC.htmlURL = offer.htmlURL;
    }
    else if([segue.identifier isEqualToString:@"IMOfferSegue"])
    {
        IMOffer *offer = (IMOffer *)sender;
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        productListVC.categoryID = self.selectedModel.identifier;
        productListVC.title =  self.title;
        productListVC.productListType = IMProductListScreen;
        productListVC.promtionID = offer.promotionID;
    }
}




/**
 @brief horizontal product list height call back
 @returns void
 */
-(void)didLoadCollectionViewWithNumberOfRows:(CGFloat)rowCount rowHeight:(CGFloat)rowHeight andIsPager:(BOOL)pager
{
    CGFloat headerHeight = 60;
    CGFloat Pagerheight ;
    CGFloat viewMoreHeight = 50;
    CGFloat paddingHeight = 20;
    
    if(pager)
    {
        Pagerheight = 37;
    }
    else
    {
        Pagerheight = 0;
    }
    if(rowCount<= 5)
    {
        viewMoreHeight = 0;
    }
    if(rowCount)
    {
        self.containerViewHeightConstraint.constant = rowHeight + headerHeight +paddingHeight;
    }
    else
    {
        self.containerViewHeightConstraint.constant = 0;
    }
}

/**
 @brief To handle pager current page.
 @returns void
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.offerPageControl.currentPage = [[[self.offerCollectionView indexPathsForVisibleItems] firstObject] row];
    self.brandPageController.currentPage = [[[self.brandCollectionView indexPathsForVisibleItems] firstObject] row];
}

- (IBAction)showMorePressed:(UIButton *)sender
{
    [self.tableView collapseCurrentlyExpandedIndexPaths];
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        [self.showmorebutton setTitle:@"Show less" forState:UIControlStateNormal];
        self.modelArray = self.showMoreArray;
    }
    else
    {
        [self.showmorebutton setTitle:@"Show more" forState:UIControlStateNormal];
        self.modelArray = self.showLessArray;
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    [self updateUI];
}


- (void)addTimer
{
    NSTimer *timer;
    // reset to 4 second from 10 second after first round completion.
    if([IMPharmacyManager sharedManager].isCatOfferLaunchDone)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_FAST_INTERVAL target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_SLOW_INTERVAL target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    self.timer = timer;
}




- (void)nextPage
{
    //For fast scroll animation
    // 1.back to the middle of sections
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    // 2.next position
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.offers.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    
    self.offerPageControl.currentPage = nextIndexPath.row;
    if(nextItem == 0)
    {
        [IMPharmacyManager sharedManager].isCatOfferLaunchDone = YES;
        [self.timer invalidate];
        
        self.timer = nil;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_FAST_INTERVAL target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    // 3.scroll to next position
    if(nextIndexPath.item <= self.offers.count && self.offers.count > 0)
    {
        [self.offerCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
 
    
}


- (NSIndexPath *)resetIndexPath
{
    // currentIndexPath
    NSIndexPath *currentIndexPath = [[self.offerCollectionView indexPathsForVisibleItems] lastObject];
    // back to the middle of sections
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0];
    if(currentIndexPathReset.item <= self.offers.count && self.offers.count > 0)
    {
        [self.offerCollectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    return currentIndexPathReset;
}

- (void)removeTimer
{
    // stop NSTimer
    [self.timer invalidate];
    // clear NSTimer
    self.timer = nil;
    self.timer = nil;
}

// UIScrollView' delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Remove time while user drag manually
    [self removeTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

@end
