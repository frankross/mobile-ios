//
//  IMNotificationsListingViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 18/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//viewcontrollers
#import "IMNotificationsListingViewController.h"
#import "IMPharmacyViewController.h"
#import "IMPharmacySubCategoryViewController.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMOfferDetailViewController.h"
#import "IMCartViewController.h"
#import "IMCategoryProductListController.h"
#import "IMMoreViewController.h"
#import "IMMyAccountViewController.h"
#import "IMLoginViewController.h"
#import "IMOrderListViewController.h"
#import "IMPrescriptionListViewController.h"
#import "IMReferAFriendViewController.h"
#import "IMHealthArticlesViewController.h"

//tableviewcells
#import "IMBackInStockItemNotificationTableViewCell.h"
#import "IMDefaultNotificationTableViewCell.h"
#import "IMDefaultNotificationWithImageTableViewCell.h"
#import "IMOfferImageNotificationTableViewCell.h"
#import "IMProductDetailTypeNotificationTableViewCell.h"

//managers
#import "IMServerManager.h"
#import "IMAccountsManager.h"
#import "IMCartManager.h"

//models
#import "IMInAppNotification.h"
#import "IMProduct.h"
#import "IMCategory.h"


//category
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"


//utilities
#import "IMFunctionUtilities.h"


#define ALERT_FADE_DELAY 2


static NSString *const IMNotificationsKey = @"notifications";

//cell reuse identifiers
static NSString *const IMBackInStockItemNotificationTableViewCellIdentifer = @"IMBackInStockItemNotificationTableViewCell";
static NSString *const IMDefaultNotificationTableViewCellIdentifer = @"IMDefaultNotificationTableViewCell";
static NSString *const IMDefaultNotificationWithImageTableViewCellIdentifer = @"IMDefaultNotificationWithImageTableViewCell";
static NSString *const IMOfferImageNotificationTableViewCellIdentifier = @"IMOfferImageNotificationTableViewCell";
static NSString *const IMProductDetailTypeNotificationTableViewCellIdentifier = @"IMProductDetailTypeNotificationTableViewCell";

@interface IMNotificationsListingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (weak, nonatomic) IBOutlet UIView *noNotificationsContainerView;


@end

@implementation IMNotificationsListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notifications";
    self.notificationsTableView.estimatedRowHeight = UITableViewAutomaticDimension;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
    [self downloadFeed];
    
    //to fetch again when user changes location
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFeed) name:IMLocationChangedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] fetchNotificationsWithCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.modelArray = [[NSMutableArray alloc] init];
            NSArray *notificationsArray = responseDictionary[IMNotificationsKey];
            NSInteger index  = 1;
            for (NSDictionary *notificationDictionary in notificationsArray) {
                IMInAppNotification *notification = [[IMInAppNotification alloc] initWithDictionary:notificationDictionary];
                if(index <= self.unreadNotificationCount)
                {
                    notification.isUnread = YES;
                }
                [self.modelArray addObject:notification];
                index++;
            }
            [self updateUI];
            [self updateNotificationCount];
        }
        else
        {
           [self handleError:error withRetryStatus:YES];
        }
    }];
}

-(void)updateUI
{
    if(0 == self.modelArray.count)
    {
        self.noNotificationsContainerView.hidden = NO;
        self.notificationsTableView.hidden = YES;
    }
    else
    {
        self.noNotificationsContainerView.hidden = YES;
        self.notificationsTableView.hidden = NO;
        [self.notificationsTableView reloadData];
    }
}

/**
 @brief To call notification update count API
 @returns void
 */
- (void)updateNotificationCount
{
    if(self.unreadNotificationCount > 0)
    {
        [[IMServerManager sharedManager] updateNotificationsCountWithCompletion:^(NSError *error) {
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateNotificationUnreadCount)])
                    {
                        [self.delegate didUpdateNotificationUnreadCount];
                    }
                });
            }
        }];
    }
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self returnConfiguredCellForIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IMInAppNotification *notification = (IMInAppNotification *)self.modelArray[indexPath.row];

    
    if(notification.isUnread)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:230/255.0 green:245/255.0 blue:240/255.0 alpha:1.0];
        
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}


- (UITableViewCell *) returnConfiguredCellForIndexPath:(NSIndexPath *)indexPath
{
    IMInAppNotification *notification = (IMInAppNotification *)self.modelArray[indexPath.row];
    switch (notification.notificationType)
    {
        case IMDigitizationFailedNotification:
        case IMCartPreparedForYouNotification:
        case IMOrderRevisionNotification:
        case IMOrderStatusUpdationNotification:
        case IMGeneralForUserNotification:
        case IMGeneralForCommonNotification:
        case IMPrescriptionDetailNotification:
        case IMHomeNotification:
        case IMCategoryPageNotification:
        case IMPromotionDetailNotification:
        case IMHomePromotionNotification:
        case IMCategoryPromotionNotification:
        case IMReferAFriendNotification:
        case IMHealthArticlesNotification:{
            
            if(notification.imageURL && ![notification.imageURL isEqualToString:@""])
            {
                IMDefaultNotificationWithImageTableViewCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:IMDefaultNotificationWithImageTableViewCellIdentifer];
                [self configureDefaultNotificationWithImageTableViewCell:cell withNotification:notification];
                return cell;
            }
            else
            {
                IMDefaultNotificationTableViewCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:IMDefaultNotificationTableViewCellIdentifer];
                [self configureDefaultNotifcationTableViewCell:cell withNotification:notification];
                return cell;
            }
        }
        case IMPromotionWebPageNotification:
        {
            IMOfferImageNotificationTableViewCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:IMOfferImageNotificationTableViewCellIdentifier];
            [self configureOfferImageNotificationTableViewCell:cell withNotification:notification];
            return cell;
          
        }
        case IMProductDetailNotification:
        {
            IMProductDetailTypeNotificationTableViewCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:IMProductDetailTypeNotificationTableViewCellIdentifier];
            [self configureProductDetailTypeNotificationTableViewCell:cell withNotification:notification];
            return cell;
        }

    }
    return nil;
    
}

- (void)configureDefaultNotifcationTableViewCell:(IMDefaultNotificationTableViewCell *)cell
                                withNotification:(IMInAppNotification *)notification
{
    cell.notificationTitleLabel.text = notification.title;
    cell.notificationDescriptionLabel.text = notification.message;
    cell.notificationDateLabel.text = [IMFunctionUtilities timeAgoStringFromDate:notification.sentDate];
}

- (void) configureDefaultNotificationWithImageTableViewCell:(IMDefaultNotificationWithImageTableViewCell *)cell
                                              withNotification:(IMInAppNotification *)notification
{
    cell.notificationTitleLabel.text = notification.title;
    cell.notificationDescriptionLabel.text = notification.message;
    cell.notificationDateLabel.text = [IMFunctionUtilities timeAgoStringFromDate:notification.sentDate];
    [cell.notificationImageView setImageWithURL:[NSURL URLWithString:notification.imageURL]
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void) configureOfferImageNotificationTableViewCell:(IMOfferImageNotificationTableViewCell *)cell
                                              withNotification:(IMInAppNotification *)notification
{
    cell.imageViewHeightConstaint.constant = (7.0/18.0) * self.view.frame.size.width;
    [cell.notificationImageview setImageWithURL:[NSURL URLWithString:notification.imageURL]
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void) configureProductDetailTypeNotificationTableViewCell:(IMProductDetailTypeNotificationTableViewCell *)cell
                                     withNotification:(IMInAppNotification *)notification
{
    cell.notificationTitleLabel.text = notification.title;
    cell.notificationDescriptionLabel.text = notification.message;
    cell.notificationDateLabel.text = [IMFunctionUtilities timeAgoStringFromDate:notification.sentDate];
    cell.imageViewHeightConstaint.constant = (7.0/18.0) * self.view.frame.size.width;
    [cell.notificationImageView setImageWithURL:[NSURL URLWithString:notification.imageURL]
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     IMInAppNotification *notification = (IMInAppNotification *)self.modelArray[indexPath.row];
    notification.isUnread = NO;
    [self.notificationsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self gotoNotificationDetailPageForNotification:notification];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self returnConfiguredCellForIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
}

#pragma mark - Actions

- (IBAction)pressedContinueShoppingButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Private
/**
 @brief function to goto detailpage of the notification
 @returns void
 */
- (void)gotoNotificationDetailPageForNotification:(IMInAppNotification *)notification
{
    switch (notification.notificationType) {
            
        case IMDigitizationFailedNotification: 
        case IMPrescriptionDetailNotification: {

            [self gotoPrescriptionDetailScreenForNotification:notification];
            break;
        }
        case IMCartPreparedForYouNotification: {
            
            [self gotoCartScreen];
            break;
        }
        case IMOrderRevisionNotification:
        case IMOrderStatusUpdationNotification: {

            [self gotoOrderDetailScreenForNotification:notification];
            break;
            
        }
        case IMGeneralForUserNotification:
        case IMGeneralForCommonNotification: {
            
            [self showAlertWithTitle:@"Promotional message" andMessage:notification.message];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        }

        case IMHomeNotification: {
            
            [self.navigationController popViewControllerAnimated:NO];
            break;
        }
        case IMCategoryPageNotification: {

            [self gotoSubCategoryScreenWithNotification:notification];
            break;
        }
        case IMPromotionDetailNotification: {
            
            [self gotoCategoryProductListingScreenWithNotification:notification];
            break;
            
        }
        case IMHomePromotionNotification: {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self copyCouponCode:notification.couponCode];
            break;
        }
        case IMCategoryPromotionNotification: {
            
            [self gotoSubCategoryScreenWithNotification:notification];
            [self copyCouponCode:notification.couponCode];
            break;
        }
        case IMPromotionWebPageNotification: {
            
            [self gotoPromotionDetailWebviewWithNotification:notification];
            break;
        }
        case IMReferAFriendNotification: {
            
            [self gotoReferAfriendScreen];
            break;
        }
        case IMProductDetailNotification: {
            
            [self gotoProductDetailScreenForNotification:notification];
            break;
        }
        case IMHealthArticlesNotification:{
            
                [self gotoHealthArticleWithNotification:notification];
            }
            break;
    }
}


/**
 @brief function to goto cart screen
 @returns void
 */
- (void) gotoCartScreen
{
    UIStoryboard* cartStoryboard =[UIStoryboard storyboardWithName:IMCartSBName bundle:nil];

    if( [[IMAccountsManager sharedManager] userToken])
    {
        [IMCartManager sharedManager].orderInitiatedViewController = self;
        IMCartViewController* cartVC = [cartStoryboard instantiateInitialViewController];
        [self.navigationController pushViewController:cartVC animated:YES];
    }
    else
    {
        __weak typeof(self)weakSelf = self;
         UIStoryboard* accountStoryboard = [UIStoryboard storyboardWithName:IMAccountSBName bundle:nil];
        IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
        loginViewController.loginCompletionBlock = ^(NSError* error ){
            if(!error)
            {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                
                UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMCartSBName bundle:nil];
                [IMCartManager sharedManager].orderInitiatedViewController = self;
                IMCartViewController* cartVC = [storyboard instantiateInitialViewController];
                [self.navigationController pushViewController:cartVC animated:YES];
                
                
            }
        };
        if(loginViewController)
        {
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
    }
}


/**
 @brief function to goto order detail screen
 @returns void
 */
- (void) gotoOrderDetailScreenForNotification:(IMInAppNotification *) notification
{
    if(notification.orderID)
    {
        UIStoryboard* accountStoryboard =[UIStoryboard storyboardWithName:IMAccountSBName bundle:nil];
        if( [[IMAccountsManager sharedManager] userToken])
        {
            //Push to order list vc , from ther push to detail Vc
            IMOrderListViewController* orderListVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMOrderListingViewControllerID];
            orderListVC.identifier = notification.orderID;
            orderListVC.isDeepLinkingPush = YES;
            [self.navigationController pushViewController:orderListVC animated:NO];

        }
        else
        {
            __weak typeof(self)weakSelf = self;
            IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
            loginViewController.loginCompletionBlock = ^(NSError* error ){
                if(!error)
                {
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    
                    IMOrderListViewController* orderListVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMOrderListingViewControllerID];
                    orderListVC.identifier = notification.orderID;
                    orderListVC.isDeepLinkingPush = YES;
                    [weakSelf.navigationController pushViewController:orderListVC animated:NO];
                    
                
                }
            };
            if(loginViewController)
            {
                [self.navigationController pushViewController:loginViewController animated:YES];
            }
        }
    }
}


/**
 @brief function to goto prescription detail screen
 @returns void
 */
- (void) gotoPrescriptionDetailScreenForNotification:(IMInAppNotification *) notification
{
    if (notification.prescriptionID)
    {
        UIStoryboard* accountStoryboard =[UIStoryboard storyboardWithName:IMAccountSBName bundle:nil];
        if( [[IMAccountsManager sharedManager] userToken])
        {
            //Push to prescription list vc , from ther push to detail Vc
            IMPrescriptionListViewController *prescriptionlVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMPrecriptionListingViewControllerID];
            prescriptionlVC.identifier = notification.prescriptionID;
            prescriptionlVC.isDeepLinkingPush = YES;
            [self.navigationController pushViewController:prescriptionlVC animated:NO];
        }
        else
        {
            __weak typeof(self)weakSelf = self;
            IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
            loginViewController.loginCompletionBlock = ^(NSError* error ){
                if(!error)
                {
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    
                    //Push to prescription list vc , from ther push to detail Vc
                    
                    IMPrescriptionListViewController *prescriptionlVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMPrecriptionListingViewControllerID];
                    prescriptionlVC.identifier = notification.prescriptionID;
                    prescriptionlVC.isDeepLinkingPush = YES;
                    [self.navigationController pushViewController:prescriptionlVC animated:NO];
                    
                    
                }
            };
            if(loginViewController)
            {
                [self.navigationController pushViewController:loginViewController animated:YES];
            }
        }
    }

}


/**
 @brief function to goto product detail screen
 @returns void
 */
- (void) gotoProductDetailScreenForNotification:(IMInAppNotification *) notification
{
    if(notification.isPharma && notification.variantID)
    {
        IMPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMPharmaDetailViewControllerID];
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = notification.variantID ;
        pharmaDetailVC.product = product;
        [self.navigationController pushViewController:pharmaDetailVC animated:YES];
    }
    else if(!notification.isPharma && notification.variantID)
    {
        IMNonPharmaDetailViewController *pharmaDetailVC = [ self.storyboard instantiateViewControllerWithIdentifier:IMNonPharmaDetailViewControllerID];
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = notification.variantID;
        pharmaDetailVC.selectedModel = product;
        [self.navigationController pushViewController:pharmaDetailVC animated:YES];
    }
}

/**
 @brief function to goto sub category screen
 @returns void
 */
- (void) gotoSubCategoryScreenWithNotification:(IMInAppNotification *)notification
{
    if(notification.categoryID)
    {
        IMCategory *model = [[IMCategory alloc] init];
        model.identifier = notification.categoryID;
        IMPharmacySubCategoryViewController *subCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:IMSubCategoryViewControllerID];
        subCategoryVC.selectedModel = model;
        [self.navigationController pushViewController:subCategoryVC animated:YES];
    }
}


/**
 @brief function to goto product listing screen
 @returns void
 */
- (void) gotoCategoryProductListingScreenWithNotification:(IMInAppNotification *)notification
{
    IMCategoryProductListController *categoryProductListController = [self.storyboard instantiateViewControllerWithIdentifier:IMCategoryProductListingViewControllerID];
    categoryProductListController.title =  @"Products";
    categoryProductListController.productListType = IMProductListScreen;
    categoryProductListController.promtionID = notification.promotionID;
    [self.navigationController pushViewController:categoryProductListController animated:YES];
}


/**
 @brief function to goto ppromotional detail webview screen
 @returns void
 */
- (void) gotoPromotionDetailWebviewWithNotification:(IMInAppNotification *)notification
{
    if(notification.htmlURL && ![notification.htmlURL isEqualToString:@""] )
    {
        IMOfferDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:IMPromotionDetailWebviewViewControllerID];
        vc.htmlURL = notification.htmlURL;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 @brief function to goto Refer a friend screen
 @returns void
 */
- (void) gotoReferAfriendScreen
{

    UIStoryboard* accountStoryboard = [UIStoryboard storyboardWithName:IMSupportSBName bundle:nil];
    IMReferAFriendViewController *referAFriendVC = [ accountStoryboard instantiateViewControllerWithIdentifier:IMReferAFriendViewControllerID];
    if( [[IMAccountsManager sharedManager] userToken])
    {

        [self.navigationController pushViewController:referAFriendVC animated:YES];
        
    }
    else
    {
        UIStoryboard *accountStoryboard =[UIStoryboard storyboardWithName:IMAccountSBName bundle:nil];
        __weak typeof(self)weakSelf = self;
        IMLoginViewController *loginViewController = [accountStoryboard instantiateViewControllerWithIdentifier:IMLoginVCID];
        loginViewController.loginCompletionBlock = ^(NSError* error ){
            if(!error)
            {
                [weakSelf.navigationController popViewControllerAnimated:NO];
                [self.navigationController pushViewController:referAFriendVC animated:YES];
                
            }
        };
        if(loginViewController)
        {
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
    }
}

/**
 @brief function to goto Health articles screen
 @returns void
 */

- (void)gotoHealthArticleWithNotification:(IMInAppNotification *)notification
{
    UIStoryboard *supportStoryboard = [UIStoryboard storyboardWithName:IMSupportSBName bundle:nil];
    IMHealthArticlesViewController *healthArticlesViewController = [supportStoryboard instantiateViewControllerWithIdentifier:IMHealthArticlesViewControllerID];
    healthArticlesViewController.isDeepLinkingPush = YES;
    healthArticlesViewController.webPageUrl = notification.htmlURL;
    [self.navigationController pushViewController:healthArticlesViewController animated:YES];
}


/**
 @brief function to copy coupon code to clipboard
 @returns void
 */
- (void) copyCouponCode:(NSString *)couponCode
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

/**
 @brief function to dismissm coupon code copied alert
 @returns void
 */
-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

@end
