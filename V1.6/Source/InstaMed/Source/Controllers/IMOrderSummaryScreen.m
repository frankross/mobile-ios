//
//  IMOrderSummaryScreen.m
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderSummaryScreen.h"
#import "IMMyAccountViewController.h"
#import "IMLineItem.h"
#import "IMOrderSummaryTableViewCell.h"
#import "IMOrderSummaryPriceTableViewCell.h"
#import "IMPaymentMethodTableViewCell.h"
#import "IMCartManager.h"
#import "IMFacebookManager.h"
#import "IMApptentiveManager.h"
#import "IMOrderSuccessViewController.h"
#import "IMOrderListViewController.h"
#import "IMCartViewController.h"
#import "IMOrder.h"
#import "IMPayment.h"
#import "PaymentsSDK.h"
#import "IMSettingsUtility.h"
#import "IMAccountsManager.h"
#import "IMBranchServiceManager.h"
#import "IMPaymentInstrument.h"
#import "IMAppDelegate.h"

#define ALERT_FADE_DELAY 2


@interface IMOrderSummaryScreen()<UITableViewDelegate,UITableViewDataSource,PGTransactionDelegate,UIAlertViewDelegate,IMOrderSummaryPriceTableViewCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *orderSummaryTableView;
@property (weak, nonatomic) UITableViewCell *payUsingHeaderCell;
@property (nonatomic) CGFloat shippingCharge;
@property (weak, nonatomic) IBOutlet UIButton *confirmOrderButton;
@property(nonatomic,strong) IMOrderSummaryTableViewCell* prototypeCell;
@property (nonatomic, strong) IMOrderSummaryPriceTableViewCell *summaryPriceCell;


@property (strong,nonatomic) NSNumber* currentOrderId;


@property (nonatomic, assign, getter=isSelectedPayFromRewardPoints) BOOL payFromRewardPoints;



@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) PGTransactionViewController *txnController;


@property (nonatomic, strong) NSArray *paymentMethods;
@property (nonatomic, strong) IMPaymentMethod *selectedPaymentMethod;

@property (nonatomic, assign) BOOL isPlaceOrderThroughCOD;
@property (nonatomic, assign) BOOL isShowingPaymentGatewayScreen;

@end

@implementation IMOrderSummaryScreen

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.color = APP_THEME_COLOR;
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [self.view bringSubviewToFront:self.indicator];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [IMFlurry logEvent:IMCheckOutSummaryScreenVisited withParameters:@{}];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}

/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [super setUpNavigationBar];
    [IMFunctionUtilities setBackgroundImage:self.confirmOrderButton withImageColor:APP_THEME_COLOR];
    [self downloadFeed];
    
    
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{

    if(self.isPlaceOrderThroughCOD)
    {
        // to fix crash when presses back button
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    if(self.cart.cartOperationType == IMUserCartCheckout)
    {

        [self showActivityIndicatorView];
        //
        [[IMCartManager sharedManager] getCartDetailsForOrderSummaryWithCompletion:^(IMCart *cart, NSError *error)
         {
             [self hideActivityIndicatorView ];
             if(self.isPlaceOrderThroughCOD)
             {
                 // to fix crash when presses back button
                 [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             }
             if(!error)
             {

                 [self.cart updateWithCart:cart];
                 [self updateUI];
                 
                 if(self.isPlaceOrderThroughCOD)
                 {
                     self.isPlaceOrderThroughCOD = NO;
                     [self performOrderCheckout];
                 }
             }
             else
             {
                 [self handleError:error withRetryStatus:YES];
             }
         }];        
    }
    else
    {

        [self updateUI];
    }
    
    
}

/**
 @brief To update ui after feed
 @returns void
 */
-(void)updateUI
{
    //self.cart.isNewOrder indicate its a new fresh cart order flow

    if(self.cart.cartOperationType == IMUserCartCheckout)
    {
        self.modelArray = [[self.cart lineItems] copy];
        self.paymentMethods = [NSArray arrayWithArray:self.cart.paymentMethods];
        self.payFromRewardPoints = self.cart.isApplyWallet;
        if (self.paymentMethods.count)
        {
             //by default select first one as selected payment method
            self.selectedPaymentMethod = self.paymentMethods[0];
            self.cart.selectedPaymentMethod = self.selectedPaymentMethod;
            if(self.selectedPaymentMethod.isPrepaid)
            {
                [self.confirmOrderButton setTitle:@"Continue to payment" forState:UIControlStateNormal];
            }
            else
            {
                [self.confirmOrderButton setTitle:@"Confirm order" forState:UIControlStateNormal];
            }
            
        }
        else
        {
            self.selectedPaymentMethod = nil;
            self.cart.selectedPaymentMethod = nil;
            [self.confirmOrderButton setTitle:@"Confirm order" forState:UIControlStateNormal];
        }
    }
    else
    {
        self.modelArray = [self.cart.lineItems copy];
        self.paymentMethods = [NSArray arrayWithArray:self.cart.paymentMethods];
        self.payFromRewardPoints = self.cart.isApplyWallet;
        //by default select first one as selected payment method
        if (self.paymentMethods.count)
        {
            self.selectedPaymentMethod = self.paymentMethods[0];
            self.cart.selectedPaymentMethod = self.selectedPaymentMethod;
            if(self.selectedPaymentMethod.isPrepaid)
            {
                [self.confirmOrderButton setTitle:@"Continue to payment" forState:UIControlStateNormal];
            }
            else
            {
                [self.confirmOrderButton setTitle:@"Confirm order" forState:UIControlStateNormal];
            }
        }
        else
        {
            self.selectedPaymentMethod = nil;
            self.cart.selectedPaymentMethod = nil;
            [self.confirmOrderButton setTitle:@"Confirm order" forState:UIControlStateNormal];
        }
    }
    [self.orderSummaryTableView reloadData];
    
}




#pragma mark - TableView Delegate and Datasource Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.modelArray.count;
    }
    else if(section == 1)
    {
        if(self.modelArray.count > 0)
        {
            return 1;// only one cell in section . i.e Price cell
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return self.paymentMethods.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 && self.paymentMethods.count > 0) {
        
        if(!self.payUsingHeaderCell)
        {
            self.payUsingHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"PayUsingHeaderCell"];
        }
        return self.payUsingHeaderCell;
        
    }
    else // for all other cases there is no header
    {
        return  nil;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        IMOrderSummaryTableViewCell* summaryCell = (IMOrderSummaryTableViewCell*)[self.orderSummaryTableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryCell" forIndexPath:indexPath];
        summaryCell.model = self.modelArray[indexPath.row];
        [self configureCell:summaryCell forRowAtIndexPath:indexPath];
        
        return summaryCell;
    }
    else if(indexPath.section == 1)
    {
        IMOrderSummaryPriceTableViewCell *cell = (IMOrderSummaryPriceTableViewCell *)[self.orderSummaryTableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryPriceCell" forIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else
    {
        IMPaymentMethodTableViewCell *cell;
        IMPaymentMethod *paymentMethod = self.paymentMethods[indexPath.row];
        if([paymentMethod.ID isEqualToString:IMPaytmWalletPaymentmethod])
        {
            cell = [self.orderSummaryTableView dequeueReusableCellWithIdentifier:@"paymentCellType2" forIndexPath:indexPath];
            
        }
        else
        {
            cell = [self.orderSummaryTableView dequeueReusableCellWithIdentifier:@"paymentCellType1" forIndexPath:indexPath];
        }
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0)
    {
        if(!self.prototypeCell)
        {
            self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryCell"];
        }
        
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        
        
        self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.prototypeCell.bounds));
        
        
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }
    else if(indexPath.section == 1)
    {
        if(!self.summaryPriceCell)
        {
            self.summaryPriceCell = [self.orderSummaryTableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryPriceCell"];
        }
        [self configureCell:self.summaryPriceCell forRowAtIndexPath:indexPath];
        [self.summaryPriceCell setNeedsLayout];
        [self.summaryPriceCell layoutIfNeeded];
        
        CGSize size = [self.summaryPriceCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
        return 60;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 && self.paymentMethods.count > 0)
    {
        return 52;
    }
    else // for all other cases there is no header
    {
        return  0;
    }
}



/**
 @brief To handle dynamic height tablecell
 @returns void
 */
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        IMOrderSummaryTableViewCell *summeryCell = (IMOrderSummaryTableViewCell *)cell;
        IMLineItem * model = self.modelArray[indexPath.row];
        
        summeryCell.nameLabel.text = model.name;
        summeryCell.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)model.quantity];
        summeryCell.priceLabel.text = [NSString stringWithFormat:@"%@",model.totalPrice ];
    }
    else if(indexPath.section == 1)
    {
        IMOrderSummaryPriceTableViewCell *priceCell = (IMOrderSummaryPriceTableViewCell *)cell;
        if (!self.cart.isNewOrder) {
            [priceCell configureCellForOrder:self.order andRewardPointCheckBoxSelected:self.isSelectedPayFromRewardPoints];
        }
        else
        {
            IMCart *currentCart = [IMCartManager sharedManager].currentCart;
            [priceCell configureCellForCart:currentCart andRewardPointCheckBoxSelected:self.isSelectedPayFromRewardPoints];
            
        }
        
    }
    else
    {
        IMPaymentMethodTableViewCell *paymentMethodCell = (IMPaymentMethodTableViewCell *)cell;
        IMPaymentMethod *paymentMethod = self.paymentMethods[indexPath.row];
        paymentMethodCell.paymentMethodNameLabel.text = paymentMethod.name;
        if ([paymentMethod.ID isEqualToString:self.selectedPaymentMethod.ID])
        {
            paymentMethodCell.radioImageview.image = [UIImage imageNamed:@"SummaryRadioBtnActive"];
        }
        else
        {
            paymentMethodCell.radioImageview.image = [UIImage imageNamed:@"SummaryRadioBtnInActive"];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        self.selectedPaymentMethod = self.paymentMethods[indexPath.row];
        self.cart.selectedPaymentMethod = self.selectedPaymentMethod;
        if(self.selectedPaymentMethod.isPrepaid)
        {
            [self.confirmOrderButton setTitle:@"Continue to payment" forState:UIControlStateNormal];
        }
        else
        {
            [self.confirmOrderButton setTitle:@"Confirm order" forState:UIControlStateNormal];
        }
        
        [self.orderSummaryTableView reloadData];
    }
}

#pragma mark - Action Methods -

/**
 @brief To handle update order button action
 @returns void
 */
- (void)updateOrder
{
    [self showActivityIndicatorView];
    self.currentOrderId = self.order.identifier;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[IMCartManager sharedManager] updateOrder:self.order withCart:self.cart withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if (!error) {
            [IMFlurry logEvent:IMUpdateOrderEvent withParameters:@{}];
            
            [self performSegueWithIdentifier:@"IMOrderSuccessfulSegue" sender:self] ;
            //            [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];
        }
        else{
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else{
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
            }
        }
    }];
    
}

/**
 @brief To handle confirm order button action
 @returns void
 */
- (IBAction)confirmOrderPressed:(id)sender
{
    NSMutableDictionary *flurryDictionary = [NSMutableDictionary dictionary];
    flurryDictionary[@"Wallet_State"] = [NSNumber numberWithBool:self.isSelectedPayFromRewardPoints];
    
    IMPayment *payment = self.cart.paymentsArray.count > 0 ? self.cart.paymentsArray[0] : nil;
    NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
    
    if(self.cart.isPaymentFullyDoneByWallet)
    {
        flurryDictionary[@"Payment_Mode"] = paymentMethodWhenFullyDoneByWallet ? paymentMethodWhenFullyDoneByWallet : @"";

    }
    else
    {
        flurryDictionary[@"Payment_Mode"] = self.selectedPaymentMethod.ID;
    }

    [IMFlurry logEvent:IMConfirmOrder withParameters:flurryDictionary];

    [self confirmOrder];
    
}


/**
 @brief function to update the order if the order is in update state OR if the order is new then proceed for payment
 @returns void
 */
-(void) confirmOrder
{
    [IMCartManager sharedManager].doctorName = nil;
    [IMCartManager sharedManager].patientName = nil;
    if (!self.cart.isNewOrder) {
        [self updateOrder];
    }
    else
    {
        [self initiatePaymentAndCompleteTheOrder];
    }
    
}

/**
 @brief function to initiate payment for prepaid payment else it calls for Order checkout if the order is postpaid
 @returns void
 */
-(void)initiatePaymentAndCompleteTheOrder
{
    self.cart.paymentDetails = nil;
    if([self.selectedPaymentMethod.ID isEqualToString:IMCODPaymentmethod])
    {
        [self performOrderCheckout];
    }
    else if([self.selectedPaymentMethod.ID isEqualToString:IMPaytmWalletPaymentmethod])
    {
        [self initiatePaymentForPrepaidMethod];
    }
    else if([self.selectedPaymentMethod.ID isEqualToString:IMCreditCardPaymentmethod])
    {
        [self initiatePaymentForPrepaidMethod];
    }
    else if([self.selectedPaymentMethod.ID isEqualToString:IMDebitCardPaymentmethod])
    {
        [self initiatePaymentForPrepaidMethod];
    }
    else if([self.selectedPaymentMethod.ID isEqualToString:IMNetBankingPaymentmethod])
    {
        [self initiatePaymentForPrepaidMethod];
    }
    else
    {
        self.cart.selectedPaymentMethod = nil;
        [self performOrderCheckout];
    }
}

/**
 @brief function to initiate payment for prepaid payment by calling payment initiation API
 @returns void
 */
-(void)initiatePaymentForPrepaidMethod
{
    __weak IMOrderSummaryScreen* weakSelf = self;
    [self showActivityIndicator];
    [[IMCartManager sharedManager] initiatePrepaidPaymentWithOrderId:self.cart.orderId andCart:self.cart withCompletion:^(NSString *transactionID, NSError *error) {

        [self hideActivityIndicator];
        
        if(!error)
        {
            weakSelf.cart.transactionID = transactionID;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf payUsingPayTM];
            });
        }
        else
        {
            if(error.code == 422) //Inventory error
            {
                NSString *message = [self getErrorFromUserInfo:error.userInfo];
                // error could be due to insufficient inventory or coupon expiry
                if(message){
                    [self showAlertWithTitle:@"" andMessage:message];
                }
                else{
                    [self showAlertWithTitle:IMINsufficientInventory andMessage:IMPlsReduceQty];
                }
                
                //Go back to cart screen
                for(IMBaseViewController* viewController in self.navigationController.viewControllers)
                {
                    if([viewController isKindOfClass:[IMCartViewController class]])
                    {
                        IMCartViewController* cartViewController = (IMCartViewController*)viewController;
                        
                        cartViewController.cart = self.cart;
                        [self.navigationController popToViewController:cartViewController animated:YES];
                        [cartViewController downloadFeed];
                        break;
                        
                    }
                
                }

            }
            else
            {
                if(error.userInfo[IMMessage])
                {
                    [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                }
                else
                {
                    [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
                }
            }
            

        }
    }];
}
/**
 @brief function to perform order checkout by calling order checkout API
 @returns void
 */
-(void) performOrderCheckout
{

            [self showActivityIndicator];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            __weak typeof(self)weakSelf = self;
            [[IMCartManager sharedManager] checkOutUserCart:self.cart WithCompletion:^(NSNumber *orderId, NSError *error)
             {
                [self hideActivityIndicator];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                if(!error)
                {
                    [[IMFacebookManager sharedManager] logFacebookInitiatedCheckOutEvent];
                    [IMFlurry logEvent:IMPlaceOrderEvent withParameters:@{}];
                    if(self.cart.cartOperationType == IMUserCartCheckout)
                    {
                        [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];

                    [weakSelf completeTheOrder]; //call Complete order API if checkout successful
    
    
                }
                else
                {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
                    if(error.code == 422) //Inventory error
                    {
                        NSString *message = [self getErrorFromUserInfo:error.userInfo];
                        // error could be due to insufficient inventory or coupon expiry
                        if(message){
                            [self showAlertWithTitle:@"" andMessage:message];
                        }
                        else{
                            [self showAlertWithTitle:IMINsufficientInventory andMessage:IMPlsReduceQty];
                        }
    
                        //Go back to cart screen
                        for(IMBaseViewController* viewController in self.navigationController.viewControllers)
                        {
                            if([viewController isKindOfClass:[IMCartViewController class]])
                            {
                                IMCartViewController* cartViewController = (IMCartViewController*)viewController;
    
                                cartViewController.cart = self.cart;
                                [self.navigationController popToViewController:cartViewController animated:YES];
                                [cartViewController downloadFeed];
                                break;
    
                            }
                        }
                    }
                    else
                    {
                        if(error.userInfo[IMMessage])
                        {
                            [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                        }
                        else
                        {
                            [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
                        }
                    }
                }
                
            }];
    

}

/**
 @brief function to perform order completion by calling order Completion API
 @returns void
 */

-(void) completeTheOrder
{
    [self showActivityIndicatorView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[IMCartManager sharedManager] completeOrderWithId:self.cart.orderId withCart:self.cart withCompletion:^(NSError *error)
     {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         [self hideActivityIndicatorView];
         
         if(!error)
         {
                 self.currentOrderId = self.cart.orderId;
                 [[IMFacebookManager sharedManager] logFacebookPurchasedEventWithAmount:[self.cart.cartTotal doubleValue] andCurrency:@"INR"];
                 [self performSegueWithIdentifier:@"IMOrderSuccessfulSegue" sender:self] ;
                 
                 if(self.cart.cartOperationType == IMUserCartCheckout)
                 {
                     [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
                     
                 }
             
         }
         else
         {
             
             if(error.userInfo[IMMessage])
             {
                 [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
             }
             else
             {
                 [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
             }
         }
         
     }];
}


/**
 @brief function to call Payment failure API when payTM payment fails
 @returns void
 */

-(void) performOrderFailureRequest
{
    [self showActivityIndicator];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[IMCartManager sharedManager] paymentFailedForOrderWithId:self.cart.orderId withCart:self.cart withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self hideActivityIndicator];
        
        if(!error)
        {
            IMCart *cart = [[IMCart alloc] initWithDictionary:responseDictionary];
            if(NO == cart.isPaymentRetryable)
            {
                [self showRetryPopUp];
            }
        }
        else
        {
            
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
            {
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
            }
        }

    }];
}


/**
 @brief function to show retry popup when Payment retyable flag is false in Cart response.
 @returns void
 */
- (void) showRetryPopUp
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"You cannot prepay for your order. Do you want to cancel the order or pay using COD?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [IMFlurry logEvent:IMRetryCancelTapped withParameters:@{}];
                                       [self cancelTheOrder];
                                   }];
    UIAlertAction *continueAction = [UIAlertAction
                                   actionWithTitle:@"Continue"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       self.isPlaceOrderThroughCOD = YES;
                                       [IMFlurry logEvent:IMRetryContinueTapped withParameters:@{}];
                                       [self downloadFeed];
                                   }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 @brief function to got o order detail.
 @returns void
 */
- (void) gotoOrderDetail
{


    UIStoryboard* accountStoryboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
    IMOrderListViewController* orderListVC = [accountStoryboard instantiateViewControllerWithIdentifier:IMOrderListingViewControllerID];
    orderListVC.identifier = self.cart.orderId;
    orderListVC.isDeepLinkingPush = YES;
    self.txnController.delegate = orderListVC;
    
    
    IMAppDelegate *appDelegate = (IMAppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarController = appDelegate.tabBarController;
        [(UINavigationController*)[tabBarController.viewControllers objectAtIndex:HomeTabIndex] popToRootViewControllerAnimated:NO];
        [(UINavigationController*)[tabBarController.viewControllers objectAtIndex:CategoriesTabIndex] popToRootViewControllerAnimated:NO];
        [(UINavigationController*)[tabBarController.viewControllers objectAtIndex:MYAccountTabIndex] popToRootViewControllerAnimated:NO];
        [(UINavigationController*)[tabBarController.viewControllers objectAtIndex:SupportTabIndex] popToRootViewControllerAnimated:NO];
        [(UINavigationController*)[tabBarController.viewControllers objectAtIndex:MoreTabIndex] popToRootViewControllerAnimated:NO];
    
    [tabBarController setSelectedIndex:MYAccountTabIndex];
    IMMyAccountViewController *myAccountVC = (IMMyAccountViewController *)((UINavigationController *)tabBarController.viewControllers[2]).topViewController;
    

    UINavigationController *navController = [myAccountVC navigationController];
    [navController pushViewController:orderListVC animated:NO];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMOrderSuccessfulSegue"])
    {
        IMPayment *payment = self.cart.paymentsArray.count > 0 ? self.cart.paymentsArray[0] : nil;
        NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
        
        if(self.cart.isPaymentFullyDoneByWallet)
        {
            ((IMOrderSuccessViewController*)segue.destinationViewController).selectedPaymentMethod = paymentMethodWhenFullyDoneByWallet;
            
        }
        else
        {
            ((IMOrderSuccessViewController*)segue.destinationViewController).selectedPaymentMethod = self.selectedPaymentMethod.name;
        }
        ((IMOrderSuccessViewController*)segue.destinationViewController).orderId = self.currentOrderId;
        ((IMOrderSuccessViewController*)segue.destinationViewController).orderRevise = (self.cart.cartOperationType == IMUpdateOrder);
    }
}


- (NSString*) getErrorFromUserInfo: (NSDictionary*) userInfo
{
    NSString *error = nil;
    if (!userInfo || !userInfo[@"order"]) {
        return error;
    }
    
    NSDictionary *ordeErrorDict = userInfo[@"order"];
    NSArray *errors = ordeErrorDict[@"errors"];
    if(errors && errors.count > 0){
        error = errors[0];
    }
    return error;
}

/**
 @brief function to return apply wallet dictionary for Apply wallet API
 @returns dictionary
 */
-(NSDictionary *)dictionaryForApplyWallet
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    BOOL revertedStatus = !self.isSelectedPayFromRewardPoints;
    if(revertedStatus == YES)
    {
    
        dictionary[IMApplyWalletDebitKey] = [NSNumber numberWithInteger:1];
    }else
    {
        dictionary[IMApplyWalletDebitKey] = [NSNumber numberWithInteger:0];
    }
    return dictionary;
}

#pragma mark - IMOrderSummaryPriceTableViewCellDelegate

-(void) didClickApplyWalletCheckBox
{
    [self showActivityIndicatorView];
    
    __weak typeof(self)weakSelf = self;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[IMCartManager sharedManager] updateCart:self.cart withOrderId:self.cart.orderId andInfo:[self dictionaryForApplyWallet] forApplyWalletWithCompletion:^(IMCart *cart, NSError *error) {
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [weakSelf hideActivityIndicatorView];
        if(!error)
        {
            
            [self.cart updateWithCart:cart];
            [weakSelf updateUI];
            
        }
        else
        {
            
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
            {
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
            }
        }
        
    }];
    [self.orderSummaryTableView reloadData];
}



#pragma mark - Payment gateway
/**
 @brief function to initiate payTM Payment SDK.
 @returns void
 */
- (void) payUsingPayTM
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];

    mc.checksumGenerationURL = [IMSettingsUtility getpayTMCheckSumURL];
    mc.checksumValidationURL = [IMSettingsUtility getpayTMCheckSumValidationURL];
    

    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[IMPayTMMerchantIDKey] = [IMSettingsUtility getpayTMMerchantID];
    orderDict[IMPayTMChannelIDKey] = [IMSettingsUtility getpayTMChannelID];
    orderDict[IMPayTMIndustryTypeIDKey] = [IMSettingsUtility getpayTMIndustryType];
    orderDict[IMPayTMWebsiteKey] = [IMSettingsUtility getpayTMWebsite];
    orderDict[IMPayTMRequestTypeKey] = @"DEFAULT";
    orderDict[IMPayTMCustomerIDKey] = [[IMAccountsManager sharedManager] userToken];
    
    if (!self.cart.isNewOrder)
    {
        orderDict[IMPayTMTransactionAmountKey] = self.order.totalAmount;
        orderDict[IMPayTMOrderIDKey] = self.cart.transactionID;
        
    }
    else
    {
        orderDict[IMPayTMOrderIDKey] = self.cart.transactionID;
        orderDict[IMPayTMTransactionAmountKey] = self.cart.netPayableAmount;
        
    }
    
    
    
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];

    
    self.txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    
    
    if([IMSettingsUtility isProduction])
    {
        self.txnController.serverType =  eServerTypeProduction;
    }
    else
    {
       self.txnController.serverType = eServerTypeStaging;
    }
   self.txnController.merchant = mc;
    self.txnController.delegate = self;
    [self showController:self.txnController];

}


/**
 @brief function to show payTM SDK's payment controller.
 @returns void
 */

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
    self.isShowingPaymentGatewayScreen = YES;
    
}


/**
 @brief function to remove payTM SDK's payment controller.
 @returns void
 */
-(void)removeController:(PGTransactionViewController *)controller
{

    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
    self.isShowingPaymentGatewayScreen = NO;
}

#pragma mark PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response
{

    DEBUGLOG(@"ViewController::didSucceedTransactionresponse= %@", response);
    [IMFlurry logEvent:IMPayTMTransactionSucesssEvent withParameters:@{}];
    if(self.isShowingPaymentGatewayScreen)
    {
        [self removeController:controller];
    }
    IMPaymentDetails *paymentDetails = [[IMPaymentDetails alloc] initWithDictionary:response];
    self.cart.paymentDetails = paymentDetails;
    [self performOrderCheckout];

    if([response[IMPaytmResponseCodeKey] isEqualToString:@"01"])
    {
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Transaction Successful" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [messageAlert show];
        [self performSelector:@selector(dissmissAlert:) withObject:messageAlert afterDelay:ALERT_FADE_DELAY];
    }
    else
    {
        [self displayPayTMMessageForTransactionSuccessWithResponse:response];
    }
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{

    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    [IMFlurry logEvent:IMPayTMTransactionFailedEvent withParameters:@{}];
    if(self.isShowingPaymentGatewayScreen)
    {
        [self removeController:controller];
    }
    [self displayPayTMMessageForTransactionFailureWithResponse:response andError:error];
    if (response)
    {
        IMPaymentDetails *paymentDetails = [[IMPaymentDetails alloc] initWithDictionary:response];
        self.cart.paymentDetails = paymentDetails;
        [self performOrderFailureRequest];

    }
    else if (error)
    {
        
        self.cart.paymentDetails = [[IMPaymentDetails alloc] init];
        self.cart.paymentDetails.orderID = self.cart.transactionID;
        [self performOrderFailureRequest];
    }
    else
    {
        self.cart.paymentDetails = [[IMPaymentDetails alloc] init];
        self.cart.paymentDetails.orderID = self.cart.transactionID;
        [self performOrderFailureRequest];

    }
    
}


- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{

    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    [IMFlurry logEvent:IMPayTMTransactionCancelEvent withParameters:@{}];
    self.cart.paymentDetails = [[IMPaymentDetails alloc] init];
    self.cart.paymentDetails.orderID = self.cart.transactionID;
    [self performOrderFailureRequest];
    if(self.isShowingPaymentGatewayScreen)
    {
        [self removeController:controller];
    }
    if(!error)
    {

        [self showAlertWithTitle:@"" andMessage:@"Transaction cancelled"];
    }
    else
    {

        [self showAlertWithTitle:@"Transaction cancel Unsuccessful" andMessage:error.userInfo[NSLocalizedFailureReasonErrorKey]];
    }
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}


/**
 @brief function to get user freindly success or failure mesage of PayTM rsponse code.
 @returns void
 */
- (NSString *) getPayTMMessageWithResponseCode:(NSInteger) responseCode
{
    NSString *message;
    switch (responseCode) {
        case 1:
            message = @"Transaction Successful";
            break;
        case 141:
            message = @"Oops, you have cancelled the transaction";
        case 227:
            message = @"Payment Failed due to a technical error. Please try after some time";
        case 810:
            message = @"Oops, you have cancelled the transaction";
        case 8102:
            message = @"Oops, you have cancelled the transaction";
        case 8103:
            message = @"Oops, you have cancelled the transaction";
            
    }
    return message;
}

-(void)showActivityIndicator
{
    self.indicator.hidden = NO;

    [self.indicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

-(void)hideActivityIndicator
{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}



-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil];
    [alert show];
}


/**
 @brief function to display payTM transaction failure message .
 @returns void
 */
- (void) displayPayTMMessageForTransactionFailureWithResponse:(NSDictionary *)response andError: (NSError *)error
{
    if (response)
    {
        NSString *responseCode = response[IMPaytmResponseCodeKey];
        NSString *responseMsg = response[IMPaytmResponseMessageKey];
        NSInteger code;
        NSString *payTMAlertMessage ;
        if(responseCode.length != 0 && responseMsg.length != 0)
        {
            code = [responseCode integerValue];
            payTMAlertMessage =  [self getPayTMMessageWithResponseCode:code];
            if(payTMAlertMessage)
            {
                [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
            }
            else
            {
                [self showAlertWithTitle:@"" andMessage:responseMsg];
            }
        }
        else if(responseCode.length == 0 && responseMsg.length != 0)
        {
            payTMAlertMessage = responseMsg;
            [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
        }
        else if(responseCode.length != 0 && responseMsg.length == 0)
        {
            code = [responseCode integerValue];
            payTMAlertMessage = [self getPayTMMessageWithResponseCode:code];
            if(payTMAlertMessage )
            {
                [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
            }
            else
            {
                if(error)
                {
                    
                    [self showAlertWithTitle:error.localizedDescription andMessage:error.userInfo[NSLocalizedFailureReasonErrorKey]];
                }
                else
                {
                    [self showAlertWithTitle:@"" andMessage:@"Transaction Failed"];
                }
            }
        }
    }
    else if (error)
    {
        NSString *payTMMessage = [self getPayTMMessageWithResponseCode:error.code];
        if(payTMMessage)
        {
            [self showAlertWithTitle:@"" andMessage:payTMMessage];
        }
        else
        {
             [self showAlertWithTitle:error.localizedDescription andMessage:error.userInfo[NSLocalizedFailureReasonErrorKey]];
            
        }
        

    }
    else
    {

        [self showAlertWithTitle:@"" andMessage:@"Transaction Failed"];
    }
}
/**
 @brief function to display payTM transaction success message .
 @returns void
 */
- (void) displayPayTMMessageForTransactionSuccessWithResponse:(NSDictionary *)response
{
    NSString *responseCode = response[IMPaytmResponseCodeKey];
    NSString *responseMsg = response[IMPaytmResponseMessageKey];
    NSInteger code;
    NSString *payTMAlertMessage ;
    if(responseCode.length != 0 && responseMsg.length != 0)
    {
        code = [responseCode integerValue];
        payTMAlertMessage =  [self getPayTMMessageWithResponseCode:code];
        if(payTMAlertMessage)
        {
            [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
        }
        else
        {
            [self showAlertWithTitle:@"" andMessage:responseMsg];
        }
    }
    else if(responseCode.length == 0 && responseMsg.length != 0)
    {
        payTMAlertMessage = responseMsg;
        [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
    }
    else if(responseCode.length != 0 && responseMsg.length == 0)
    {
        code = [responseCode integerValue];
        payTMAlertMessage = [self getPayTMMessageWithResponseCode:code];
        if(payTMAlertMessage )
        {
            [self showAlertWithTitle:@"" andMessage:payTMAlertMessage];
        }
    }
}
/**
 @brief function to cancel the order.
 @returns void
 */
-(void) cancelTheOrder
{
    IMCancelReason *cancelReason = [[IMCancelReason alloc] init];
    cancelReason.reason = @"Payment failed";
    cancelReason.remarks = @"";
    [self showActivityIndicator];
    [[IMAccountsManager sharedManager] cancelOrderWithId:self.cart.orderId orderCanecelInfo:cancelReason completion:^(NSString *message, NSError *error) {
        

        [self hideActivityIndicator];
        if(!error && message)
        {
            [self showAlertWithTitle:IMCancellSuccess andMessage:message];
            if(self.cart.cartOperationType == IMUserCartCheckout)
            {
                [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
            }
            [self gotoOrderDetail];
            
        }
        else
        {
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
            {
                [self showAlertWithTitle:@"" andMessage:IMNoNetworkErrorMessage];
            }
        }
        
    }];
}


@end
