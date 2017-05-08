//
//  IMHomeViewController.m
//  InstaMed
//
//  Created by Suhail K on 19/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#define PHARMA_CATEGORY_ID 810
#define AUTOSCROLL_FAST_INTERVAL 4
#define AUTOSCROLL_FAST_INTERVAL2 5

#define AUTOSCROLL_SLOW_INTERVAL 10
#define AUTOSCROLL_SLOW_INTERVAL2 11
#define CAROUSEL_VISIBLE_ITEM_COUNT 10
#define ALERT_FADE_DELAY 3


#import "IMHomeViewController.h"
#import "IMDefines.h"
#import "IMNotification.h"
#import "IMProductListViewController.h"
#import "IMOfferCollectionViewCell.h"
#import "IMPharmacyManager.h"
#import "IMLocationManager.h"
#import "IMServerManager.h"
#import "IMApptentiveManager.h"
#import "IMAppSettingsManager.h"
#import "IMSetLocationViewController.h"
#import "IMPlaceOrder.h"
#import "IMLineItem.h"
#import "IMOrderDetailViewController.h"
#import "IMPrescriptionListViewController.h"
#import "IMAccountsManager.h"
#import "IMLoginViewController.h"
#import "UITextField+IMSearchBar.h"
#import "IMCartRevisionViewController.h"
#import "IMCartManager.h"
#import "IMUploadPrescriptionViewController.h"

#import "IMOrderDetailViewController.h"
#import "IMPrescriptionDetailViewController.h"
#import "IMCartViewController.h"

#import "IMPrescriptionListViewController.h"
#import "IMOrderListViewController.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMNotificationsListingViewController.h"

#import "IMCategoryCollectionViewCell.h"
#import "IMPharmacySubCategoryViewController.h"
#import "IMProductListHorizontalViewController.h"
#import "IMDeviceManager.h"
#import "IMCategoryProductListController.h"
#import "IMOfferDetailViewController.h"
#import "IMBadgeButton.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import "UIBarButtonItem+Badge.h"

static NSString* IMAlreadyLaunched = @"alreadyLaunched";
static NSString* const IMSetLocationSegue = @"setLocationSegue";
static NSString *const IMNotificationListingSegue = @"SegueToNotificationListing";


@interface IMHomeViewController ()<IMProductListHorizontalViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,IMSetLocationViewControllerDelegate,IMNotificationsListingViewControllerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerCollectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *uploadPrescription;
@property (nonatomic, strong) IMBadgeButton *cartButton;
@property (nonatomic, strong) UIBarButtonItem *notificationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (nonatomic,strong) NSArray* offerBanners;
@property (nonatomic,strong) NSMutableArray* offerStores;

@property (nonatomic,strong) NSArray* categories;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UICollectionView *offerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *offerCollectionView2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerCollectionView2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offer2SeparatorViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIPageControl *offerPageControl;

@property (nonatomic, assign) BOOL isPrescriptionPresented;

- (IBAction)uploadPrescriptionPressed:(UIButton *)sender;


@property (nonatomic,strong) NSMutableArray* notifications;


@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CategoryViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *offer2PageControl;

@property(nonatomic, assign) NSNumber *popularCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isOfferLaunchDone;
@property (nonatomic, assign) BOOL isOffer2LaunchDone;
@property (nonatomic, strong) NSTimer *timer2;

@property (strong, nonatomic) IMProductListHorizontalViewController *featuredVC;

@end

@implementation IMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Home";
    
}

-(void)showSuppotedLocationsFetchFailedAlert
{

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error while fetching data"
                                          message:@"Error while fetching supported cities."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Try Again"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 @brief To show location UI- if one location show alert else location selection screen.
 @returns void
 */
-(void)showSetLocationUI
{
    [self showActivityIndicatorView];
    [[IMLocationManager sharedManager] fetchDeliverySupportedLocationsWithCompletion:^(NSArray *deliveryLocations,IMCity* currentCity, NSError *error)
     {
         [self hideActivityIndicatorView];

        if (!error)
        {
            if(deliveryLocations)
            {
                if(deliveryLocations.count == 1)
                {
                    [IMLocationManager sharedManager].currentLocation = currentCity;
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@ only.",IMCurrentlydeliveredTo,currentCity.name ]
                                                          message:IMMoreCtiesSoon
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:IMGotIt
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       
                                                   }];
                    
                    
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self downloadFeed];
                    if(self.featuredVC)
                    {
                        [self.featuredVC downloadFeed];
                    }
                }
                else
                {
                    self.modelArray = [deliveryLocations mutableCopy];
                    self.selectedModel = currentCity;
                    [self performSegueWithIdentifier:IMSetLocationSegue sender:self];
                }
            }
            else
            {
                [self showSuppotedLocationsFetchFailedAlert];
            }            
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTimer];
    [self addTimer2];

    [IMFlurry logEvent:IMHomeScreenVisited withParameters:@{}];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadDone:)
                                                 name:@"IMUploadDone"
                                               object:nil];
   //Call APi for categories and cart for refreshing purpose.
    [self downloadCategories];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMApptentiveManager sharedManager] logAppLaunchedEventFromViewController:self];
    [[IMApptentiveManager sharedManager] logHomeScreenVisitedEventFromViewController:self];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];

}

/**
 @brief Prescription uoload done callback.
 @returns void
 */
- (void)uploadDone:(NSNotification *)notification
{
    if (self.isPrescriptionPresented) {
        self.isPrescriptionPresented = NO;
        [self.navigationController popToViewController:self animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)loadUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFeed) name:IMLocationChangedNotification object:nil];

    [self setUpNavigationBar];
    [self addCartAndNotificationButton];
    
    self.CategoryViewHeightConstraint.constant = 0;

    SET_CELL_CORER(self.uploadPrescription,8.0);
    
    [IMFunctionUtilities setBackgroundImage:self.uploadPrescription withImageColor:APP_THEME_COLOR];

    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
    [self.searchField configureAsSearchBar];

    [self downloadFeed];
}


/**
 @brief To download categories feed
 @returns void
 */
- (void)downloadCategories
{

    [[IMPharmacyManager sharedManager] fetchFeaturedCategoriesWithCompletion:^(NSMutableArray *categories, NSMutableArray *promotions, NSError *error) {
        [self hideActivityIndicatorView];
        
        if(!error)
        {
            self.categories = categories;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
    
    if([[IMAccountsManager sharedManager] userToken]) //Fetch cart to show cart count
    {
        [[IMCartManager sharedManager] fetchCartWithCompletion:^(IMCart *cart, NSError *error) {
            [self hideActivityIndicatorView];
            
            if(!error)
            {
                [self updateCartButton];
            }
            else
            {
                [self handleError:error withRetryStatus:YES];
            }
        }];
    }
}

/**
 @brief Common download feed for all API call.
 @returns void
 */
-(void)downloadFeed
{
    //clear badge count
    self.notificationButton.badgeValue = nil;
    IMCity* currentLocation = [[IMLocationManager sharedManager] currentLocation];
    
    if(!currentLocation)
    {
        [self showSetLocationUI];
    }
    //fetch appsettings
    [self fetchAppSettings];
    [self fetchUnreadNotificationCount];
    
    [self showActivityIndicatorView];
    [[IMPharmacyManager sharedManager] fetchOffersWithCompletion:^(NSArray *offerBanners, NSArray *offerStores, NSError *error) {

        [self hideActivityIndicatorView];
        if(!error)
        {
            self.offerBanners = offerBanners;
            self.offerStores = [offerStores mutableCopy];

            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
    
    [self downloadCategories];
}

/**
 *  Function to fetch App settings by calling App settings API
 */
- (void) fetchAppSettings
{
    [self showActivityIndicatorView];

    [[IMAppSettingsManager sharedManager] fetchAppSettingsDetailswithCompletion:^(NSError *error)
     {
        [self hideActivityIndicatorView];
        if(error)
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
    
}

/**
 *  Function to fetch unread notification count by calling unread notification count API
 */
- (void) fetchUnreadNotificationCount
{
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] fetchUnreadNotificationCountWithCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        [self hideActivityIndicatorView];
       NSInteger notificationCount = [responseDictionary[@"device_notification_count"] integerValue];
        if(notificationCount > 0)
        {
            // set unread notification count
            dispatch_async(dispatch_get_main_queue(), ^{
                self.notificationButton.badgeBGColor = [UIColor redColor];
                self.notificationButton.badgeValue = [NSString stringWithFormat:@"%ld",(long)notificationCount];
            });
        }
        
    }];
}


- (void)updateUI
{
    self.offerCollectionView.dataSource = self;
    self.offerCollectionView.delegate = self;
    self.offerCollectionView2.dataSource = self;
    self.offerCollectionView2.delegate = self;
    self.categoryCollectionView.dataSource = self;
    self.categoryCollectionView.delegate = self;
    
    self.offerPageControl.numberOfPages = self.offerBanners.count;
    self.offer2PageControl.numberOfPages = self.offerStores.count;

    if(self.offerBanners.count <= 1)
    {
        self.offerPageControl.hidden = YES;
    }
    else
    {
        self.offerPageControl.hidden = NO;
    }
    if(self.offerStores.count <= 1)
    {
        self.offer2PageControl.hidden = YES;
    }
    else
    {
        self.offer2PageControl.hidden = NO;
    }
    if(self.offerBanners.count)
    {
        self.offerCollectionViewHeightConstraint.constant =  (7.0/18.0)*self.view.frame.size.width;
    }
    else
    {
        self.offerCollectionViewHeightConstraint.constant =  0;
    }
    if(self.offerStores.count)
    {
        self.offerCollectionView2HeightConstraint.constant =  (7.0/18.0)*self.view.frame.size.width ;
        self.offer2SeparatorViewHeightConstraint.constant = 14;

    }
    else
    {
        self.offerCollectionView2HeightConstraint.constant =  0;
        self.offer2SeparatorViewHeightConstraint.constant = 0;
    }

    if(self.categories.count == 0)
    {
        self.CategoryViewHeightConstraint.constant = 0;
    }
    else
    {
        self.CategoryViewHeightConstraint.constant = 195;
    }
    
    [self.offerCollectionView reloadData];
    [self.offerCollectionView2 reloadData];
    [self.categoryCollectionView reloadData];
    
    [UIView animateWithDuration:0.75 animations:^{
        [self.categoryCollectionView layoutIfNeeded];
    }];
}

#pragma mark - Navigation - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TopSellingSegue"])
    {
        IMProductListHorizontalViewController *productListVC = (IMProductListHorizontalViewController *) segue.destinationViewController;
        productListVC.delegate = self;
        productListVC.productListType = IMHomeScreen;
        self.featuredVC = productListVC;
    }
    else if([segue.identifier isEqualToString:@"offerSegue"])
    {
        IMProductListViewController *productListVC = (IMProductListViewController *) segue.destinationViewController;
        productListVC.productListType = IMOfferProductListScreen;
    }
    else if([segue.identifier isEqualToString:IMSetLocationSegue])
    {
        ((IMSetLocationViewController*)segue.destinationViewController).modelArray = self.modelArray;
        ((IMSetLocationViewController*)segue.destinationViewController).selectedModel = self.selectedModel;
        ((IMSetLocationViewController*)segue.destinationViewController).delegate = self;
    }

    else if([segue.identifier isEqualToString:@"IMNonPharmaCategorySegue"])
    {
        IMCategory* selectedCategory = ((IMCategoryCollectionViewCell*)sender).model;
        
        NSString *event = selectedCategory.name;
        NSDictionary *categoryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                        event, @"Category_Name",
                                        nil];
        [IMFlurry logEvent:IMCategoryHome withParameters:categoryParams];

        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).selectedModel = selectedCategory;
    }
    else if([segue.identifier isEqualToString:@"OfferProductListSegue"])
    {
        IMOffer *offer = (IMOffer *)sender;
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        productListVC.title =  @"Products";
        productListVC.productListType = IMProductListScreen;
        productListVC.promtionID = offer.promotionID;
    }
    else if([segue.identifier isEqualToString:@"IMOfferDetailSegue"])
    {
        IMOffer *offer = (IMOffer *)sender;
        IMOfferDetailViewController *offerDetailVC = (IMOfferDetailViewController*) segue.destinationViewController;
        offerDetailVC.htmlURL = offer.htmlURL;
    }
    else if([segue.identifier isEqualToString:@"SearchBarSegue"])
    {
        NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.screenName, @"Screen_Name",
                                        nil];
        [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
    }
    else if ([segue.identifier isEqualToString:IMNotificationListingSegue])
    {
        IMNotificationsListingViewController *vc = (IMNotificationsListingViewController *)segue.destinationViewController;
        vc.unreadNotificationCount = [self.notificationButton.badgeValue integerValue];
        vc.delegate = self;
    }
    
}

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


#pragma mark - CollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.offerCollectionView)
    {
        return self.offerBanners.count;
    }
    else if(collectionView == self.offerCollectionView2)
    {
        return self.offerStores.count;
    }
    else
    {
        if (self.categories.count ) {
            return  self.categories.count + 1;
        }
       return self.categories.count;
    }

}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.offerCollectionView)
    {
        IMOfferCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerCell" forIndexPath:indexPath];
        collectionViewCell.model = self.offerBanners[indexPath.row];
        return collectionViewCell;
    }
    else if(collectionView == self.offerCollectionView2)
    {
        IMOfferCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerCell" forIndexPath:indexPath];
        collectionViewCell.model = self.offerStores[indexPath.row];
        return collectionViewCell;
    }
    else
    {
        if (indexPath.row < self.categories.count) {
            IMCategoryCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMCategoryCollectionCell" forIndexPath:indexPath];
            collectionViewCell.model = self.categories[indexPath.row];
            return collectionViewCell;
        }
        else
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMCategoryViewMoreCell" forIndexPath:indexPath];
            cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.layer.borderWidth = 0.5;
            return cell;
        }
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.categoryCollectionView)
    {
        if (indexPath.row < self.categories.count)
        {
            IMCategoryCollectionViewCell* cell = (IMCategoryCollectionViewCell* )[collectionView cellForItemAtIndexPath:indexPath];
            IMCategory *model = [self.categories objectAtIndex:indexPath.row];
            if([model.identifier integerValue] == PHARMA_CATEGORY_ID)
            {
                [self performSegueWithIdentifier:@"IMPrescriptionMedicinsSegue" sender:cell];
            }
            else
            {
                [self performSegueWithIdentifier:@"IMNonPharmaCategorySegue" sender:cell];
            }
        }
        else
        {
            [IMFlurry logEvent:IMViewMoreCategories withParameters:@{}];
            [self.tabBarController setSelectedIndex:1];
            [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];
        }
    }
    else if(collectionView == self.offerCollectionView)
    {
        [IMFlurry logEvent:IMHomeBannerTapped withParameters:@{}];
        IMOffer *offer = self.offerBanners[indexPath.row];
        if (offer.promotionID != nil)
        {
            [self performSegueWithIdentifier:@"OfferProductListSegue" sender:offer];
        }
        else
        {
            if (![offer.htmlURL isEqualToString:@""] && offer.htmlURL != nil) {
                [self performSegueWithIdentifier:@"IMOfferDetailSegue" sender:offer];
            }
        }
    }
    else if(collectionView == self.offerCollectionView2)
    {
        IMOffer *offer = self.offerStores[indexPath.row];
        if (offer.promotionID != nil)
        {
            [self performSegueWithIdentifier:@"OfferProductListSegue" sender:offer];
        }
        else
        {
            if (![offer.htmlURL isEqualToString:@""] && offer.htmlURL != nil) {
                [self performSegueWithIdentifier:@"IMOfferDetailSegue" sender:offer];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView == self.offerCollectionView)
    {
        // (7/18) for maintaining aspect ratio.
        size = CGSizeMake(self.view.frame.size.width, (7.0/18.0)*self.view.frame.size.width);
        return size;
    }
    else if(collectionView == self.offerCollectionView2)
    {
        // (7/18) for maintaining aspect ratio.
        size = CGSizeMake(self.view.frame.size.width, (7.0/18.0)*self.view.frame.size.width);
        return size;
    }
    else
    {
        if (indexPath.row < self.categories.count)
        {
            size = CGSizeMake(120,120);

        }
        else
        {
            size = CGSizeMake(44,120);

        }
        return size;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.offerPageControl.currentPage = [[[self.offerCollectionView indexPathsForVisibleItems] firstObject] row];
    self.offer2PageControl.currentPage = [[[self.offerCollectionView2 indexPathsForVisibleItems] firstObject] row];

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"IMSearchSegue" sender:nil];
}

- (IBAction)setLocationPressed:(id)sender
{
    NSLog(@"Set location pressed");
}

/**
 @brief To handle upload prescription button action
 @returns void
 */
- (IBAction)uploadPrescriptionPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMUploadPrescriptionFromHome withParameters:@{}];
   if( [[IMAccountsManager sharedManager] userToken])
   {
       self.isPrescriptionPresented = YES;
       UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
       
       IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
       prescriptionVC.prescriptionType = IMFromOthers;
       [self.navigationController pushViewController:prescriptionVC animated:YES];
   }
   else
   {
       UIStoryboard *storybord;
       storybord =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
       __weak IMHomeViewController* weakSelf = self;
       
       IMLoginViewController *loginViewController = [storybord instantiateViewControllerWithIdentifier:IMLoginVCID];
       loginViewController.loginCompletionBlock = ^(NSError* error ){
           if(!error)
           {
               weakSelf.isPrescriptionPresented = YES;
               UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
               [weakSelf.navigationController popViewControllerAnimated:NO];
               
               IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
               prescriptionVC.prescriptionType = IMFromOthers;
               [weakSelf.navigationController pushViewController:prescriptionVC animated:YES];
           }
       };
       if(loginViewController)
       {
           [weakSelf.navigationController pushViewController:loginViewController animated:YES];
       }
   }
}

-(void)allPrescriptionPressed
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
    
    IMPrescriptionListViewController* prescriptionListVC = [storyboard instantiateViewControllerWithIdentifier:IMPrecriptionListingViewControllerID];
    [self.navigationController pushViewController:prescriptionListVC animated:YES];
}

- (IBAction)viewAllPressed:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:NO];

}

/**
 @brief To handle screen flows from deeplinking and push notifications
 @returns void
 */
- (void)pushToDetailWithNotification:(IMNotification *)notification
{
    NSString *screenID = notification.notificationType;
    NSString *oId = notification.ID;
    NSString *couponCode = notification.couponCode;
    NSString *message = notification.message;
    NSString *htmlURL = notification.htmlURL;
    if ([screenID isEqualToString:NOTIFICAION_TYPE_TWELVE])
    {
        IMCategoryProductListController *categoryProductListController = [self.storyboard instantiateViewControllerWithIdentifier:IMCategoryProductListingViewControllerID];
        categoryProductListController.title =  @"Products";
        categoryProductListController.productListType = IMProductListScreen;
        categoryProductListController.promtionID = @([oId intValue]);
        [self.navigationController pushViewController:categoryProductListController animated:NO];
        
    }
    else if ([screenID isEqualToString:NOTIFICATION_TYPE_THIRTEEN])
    {
        if (couponCode != nil && ![couponCode isEqualToString:@""])
        {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:couponCode];
            NSString *alertMsg = [NSString stringWithFormat:IMCouponCodeCopiedToClipboardMessageFormat,couponCode];
            UIAlertView *clipBoardAlert = [[UIAlertView alloc] initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [clipBoardAlert show];
            [self performSelector:@selector(dissmissAlert:) withObject:clipBoardAlert afterDelay:ALERT_FADE_DELAY];
        }
    }
    else if ([screenID isEqualToString:NOTIFICATION_TYPE_FIFTEEN])
    {
        if (![htmlURL isEqualToString:@""] && htmlURL != nil)
        {
            IMOfferDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:IMPromotionDetailWebviewViewControllerID];
            vc.htmlURL = htmlURL;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    else if ([screenID isEqualToString:NOTIFICATION_TYPE_SEVENTEEN])
    {
        if(notification.isPharma)
        {
            IMPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMPharmaDetailViewControllerID];
            IMProduct *product = [[IMProduct alloc] init];
            product.identifier = @([notification.ID intValue]);
            pharmaDetailVC.product = product;
            [self.navigationController pushViewController:pharmaDetailVC animated:YES];
        }
        else if(!notification.isPharma)
        {
            IMNonPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMNonPharmaDetailViewControllerID];
            IMProduct *product = [[IMProduct alloc] init];
            product.identifier = @([notification.ID intValue]);
            pharmaDetailVC.selectedModel = product;
            [self.navigationController pushViewController:pharmaDetailVC animated:YES];
        }
    }
    
    
    else if([screenID isEqualToString:PHARMA_DETAIL])
    {

        
        IMPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMPharmaDetailViewControllerID];
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = @([notification.ID intValue]);
        pharmaDetailVC.product = product;
        [self.navigationController pushViewController:pharmaDetailVC animated:NO];
    
    }
    else if([screenID isEqualToString:NON_PHARMA_DETAIL])
    {

        IMNonPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMNonPharmaDetailViewControllerID];
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = @([notification.ID intValue]);
        pharmaDetailVC.selectedModel = product;
        [self.navigationController pushViewController:pharmaDetailVC animated:NO];
    }
    else
    {
        if( [[IMAccountsManager sharedManager] userToken])
        {
            UIStoryboard* accountStoryboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
            
            
            if([screenID isEqualToString:ORDER_REVISION] || [screenID isEqualToString:ORDER_STATUS_UPDATION])
            {
                //Push to order list vc , from ther push to detail Vc
                IMOrderListViewController* orderListVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMOrderListingViewControllerID];
                orderListVC.identifier = @([oId intValue]);
                orderListVC.isDeepLinkingPush = YES;
                [self.navigationController pushViewController:orderListVC animated:NO];
            }
            else if([screenID isEqualToString:DIGITIZATION_FAILD])
            {
                //Push to prescription list vc , from ther push to detail Vc
                IMPrescriptionListViewController *prescriptionlVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMPrecriptionListingViewControllerID];
                prescriptionlVC.identifier = @([oId intValue]);
                prescriptionlVC.isDeepLinkingPush = YES;
                [self.navigationController pushViewController:prescriptionlVC animated:NO];
            }
            else if([screenID isEqualToString:CART_PREPARED_FOR_YOU])
            {
                UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMCartSBName bundle:nil];
                [IMCartManager sharedManager].orderInitiatedViewController = self;
                IMCartViewController* cartVC = [storyboard instantiateInitialViewController];
                [self.navigationController pushViewController:cartVC animated:YES];
            }
            else if([screenID isEqualToString:GENERAL_FOR_USER])
            {
                if(message)
                {
                    [self showAlertWithTitle:@"Promotional message" andMessage:message];
                }
            }
            else if([screenID isEqualToString:GENERAL_FOR_COMMON])
            {
                if(message)
                {
                    [self showAlertWithTitle:@"Promotional message" andMessage:message];
                }
            }
        }
        else
        {
            UIStoryboard *storybord;
            storybord =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
            __weak IMHomeViewController* weakSelf = self;
            if([screenID isEqualToString:GENERAL_FOR_COMMON])
            {
                if(message)
                {
                    [self showAlertWithTitle:@"Promotional message" andMessage:message];
                }
            }
            else if([screenID isEqualToString:ORDER_REVISION] || [screenID isEqualToString:ORDER_STATUS_UPDATION] || [screenID isEqualToString:GENERAL_FOR_USER] || [screenID isEqualToString:CART_PREPARED_FOR_YOU] ||[screenID isEqualToString:PRESCRIPTION_DETAIL])
            {
                IMLoginViewController *loginViewController = [storybord instantiateViewControllerWithIdentifier:IMLoginVCID];
                loginViewController.loginCompletionBlock = ^(NSError* error ){
                    if(!error)
                    {
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        
                        UIStoryboard* accountStoryboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
                        
                      if([screenID isEqualToString:ORDER_REVISION] || [screenID isEqualToString:ORDER_STATUS_UPDATION])
                        {
                            IMOrderListViewController* orderListVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMOrderListingViewControllerID];
                            orderListVC.identifier = @([oId intValue]);
                            orderListVC.isDeepLinkingPush = YES;
                            [self.navigationController pushViewController:orderListVC animated:NO];
                            
                        }
                        else if([screenID isEqualToString:DIGITIZATION_FAILD])
                        {
                            //Push to prescription list vc , from ther push to detail Vc
                            
                            IMPrescriptionListViewController *prescriptionlVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMPrecriptionListingViewControllerID];
                            prescriptionlVC.identifier = @([oId intValue]);
                            prescriptionlVC.isDeepLinkingPush = YES;
                            [self.navigationController pushViewController:prescriptionlVC animated:YES];
                        }
                        else if([screenID isEqualToString:CART_PREPARED_FOR_YOU])
                        {
                            UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMCartSBName bundle:nil];
                            [IMCartManager sharedManager].orderInitiatedViewController = self;
                            IMCartViewController* cartVC = [storyboard instantiateInitialViewController];
                            [self.navigationController pushViewController:cartVC animated:NO];
                        }
                        else if([screenID isEqualToString:GENERAL_FOR_USER])
                        {
                            if(message)
                            {
                                [self showAlertWithTitle:@"Promotional message" andMessage:message];
                            }
                        }
                    }
                };
                if(loginViewController)
                {
                    [weakSelf.navigationController pushViewController:loginViewController animated:YES];
                }
            }
        }
    }
}

#pragma mark AutoScroll

- (void)addTimer
{
    NSTimer *timer;
    // reset to 4 second from 10 second after first round completion.
    if(self.isOfferLaunchDone)
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

- (void)addTimer2
{
    NSTimer *timer2;
    // reset to 4 second from 10 second after first round completion.
    if(self.isOffer2LaunchDone)
    {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_FAST_INTERVAL2 target:self selector:@selector(nextPage2) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    }
    else
    {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_SLOW_INTERVAL2 target:self selector:@selector(nextPage2) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    }
    
    self.timer2 = timer2;
}


- (void)nextPage
{
    //For fast scroll animation
    // 1.back to the middle of sections
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    // 2.next position
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.offerBanners.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    
    self.offerPageControl.currentPage = nextIndexPath.row;
    if(nextItem == 0)
    {
        self.isOfferLaunchDone = YES;
        [self.timer invalidate];

        self.timer = nil;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_FAST_INTERVAL target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    // 3.scroll to next position
    if(nextIndexPath.item <= self.offerBanners.count && self.offerBanners.count > 0)
    {
        [self.offerCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }

}

- (void)nextPage2
{
    //For fast scroll animation
    // 1.back to the middle of sections
    NSIndexPath *currentIndexPathReset = [self resetIndexPath2];
    
    // 2.next position
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.offerStores.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    
    self.offer2PageControl.currentPage = nextIndexPath.row;
    if(nextItem == 0)
    {
        self.isOffer2LaunchDone = YES;
        [self.timer2 invalidate];
        
        self.timer2 = nil;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLL_FAST_INTERVAL2 target:self selector:@selector(nextPage2) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer2 = timer;
    }
    // 3.scroll to next position
    if(nextIndexPath.item <= self.offerStores.count && self.offerStores.count > 0)
    {
        [self.offerCollectionView2 scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    
}

- (NSIndexPath *)resetIndexPath
{
    // currentIndexPath
    NSIndexPath *currentIndexPath = [[self.offerCollectionView indexPathsForVisibleItems] lastObject];
    // back to the middle of sections
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0];
    if(currentIndexPathReset.item <= self.offerBanners.count && self.offerBanners.count > 0)
    {
        [self.offerCollectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    return currentIndexPathReset;
}

- (NSIndexPath *)resetIndexPath2
{
    // currentIndexPath
    NSIndexPath *currentIndexPath = [[self.offerCollectionView2 indexPathsForVisibleItems] lastObject];
    // back to the middle of sections
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0];
    if(currentIndexPathReset.item <= self.offerStores.count && self.offerStores.count > 0)
    {
        [self.offerCollectionView2 scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    return currentIndexPathReset;
}

- (void)removeTimer
{
    // stop NSTimer
    [self.timer invalidate];
    [self.timer2 invalidate];
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
    [self addTimer2];

}
/**
 @brief Function to add cart & notification button to navigation bar
 @returns void
 */
-(void) addCartAndNotificationButton
{
    self.cartButton = [[IMBadgeButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40) withBadgeString:@"0" badgeInsets:UIEdgeInsetsMake(22, -2, 0, 18)];
    [self.cartButton setImage:[UIImage imageNamed:@"CartIcon.png"] forState:UIControlStateNormal];
    
    [self.cartButton addTarget:self action:@selector(loadCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
    self.notificationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notification_icn"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoNotificationListingScreen)];
    self.navigationItem.rightBarButtonItems = @[cartButtonItem,self.notificationButton];
    self.notificationButton.badgeBGColor = [UIColor redColor];
}

-(void) gotoNotificationListingScreen
{
    [self performSegueWithIdentifier:IMNotificationListingSegue sender:self];
}



-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

#pragma mark - IMSetLocationViewControllerDelegate

- (void)didFinishSettingLocation
{
    if(self.isDefferedDeepLinkingLaunch && self.notification)
    {
        [self pushToDetailWithNotification:self.notification];
        self.isDefferedDeepLinkingLaunch = NO;
    }
}


#pragma mark - IMNotificationsListingViewControllerDelegate

-(void)didUpdateNotificationUnreadCount
{
    self.notificationButton.badgeValue = nil;
}

@end
