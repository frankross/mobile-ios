//
//  IMCartViewController.m
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartViewController.h"
#import "IMLineItem.h"
#import "IMCartTableViewCell.h"
#import "IMQuantitySelectionViewController.h"
#import "IMPrescriptionPendingViewController.h"
#import "IMAccountsManager.h"
#import "IMPlaceOrderLoginViewController.h"
#import "UIView+ProgressView.h"
#import "IMDefines.h"
#import "IMDeliveryAddressViewController.h"
#import "IMConstants.h"
#import "IMCartUtility.h"
#import "IMProduct.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMCartOfferCollectionViewCell.h"
#import "IMTagCollectionViewCell.h"
#import "IMCoupon.h"
#import "NSString+IMStringSupport.h"
#import <AudioToolbox/AudioToolbox.h>

typedef enum {
    IMOrderPlace = 1,
    IMApplyCoupon = 2,
} IMCartUserAction;

typedef enum {
    IMApplyButtonStateApply = 1,
    IMApplyButtonStateRemove = 2,
} IMApplyButtonState;

NSInteger const IMLoginConfirmAlertTag = 200;

@interface IMCartViewController ()<UITableViewDataSource,UITableViewDelegate,IMQuantitySelectionViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mismatchDescriptionLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mismatchDescriptionLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *mismatchDescriptionView;//This we need to hide and show according to the screen type
@property (weak, nonatomic) IBOutlet UILabel *mismatchDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *couponTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pinTxtField;
@property (weak, nonatomic) IBOutlet UILabel *totalSavingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleveryChargPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totallabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic)  UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *itemsTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingChargesLabel;
@property (weak, nonatomic) IBOutlet UILabel *cartTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountTotalLabel;
@property(nonatomic,strong) IMCartTableViewCell* prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *savingsContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewUnderOrderTotal;
- (IBAction)placeOrderPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *shippingDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shippingDescriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *shopNowButton;
@property (assign, nonatomic) BOOL isCalledOnce;
// offer related controls displayed at the top
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerImageWidthConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerImageLeadingSpaceConstraint;
//@property (weak, nonatomic) IBOutlet UILabel *offerTextLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
// offer related controls displayed below items total
@property (weak, nonatomic) IBOutlet UILabel *offerTitle;
@property (weak, nonatomic) IBOutlet UILabel *offerTotalPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerTitleBottomSpaceConstraint;
// cart offers displayed at the top of cart screen
@property (strong, nonatomic) IBOutlet UICollectionView *cartOfferCollectionView;
@property (nonatomic) IMCartUserAction userAction;
// coupon tags displayed below the enter coupon code field
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponTagCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponTagCollectionviewBottomConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *couponTagsCollectionView;
// coupon message displayed below the enter coupon code field
@property (weak, nonatomic) IBOutlet UILabel *couponMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponMessageBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponMessageHeightConstraint;
@property (nonatomic) BOOL needToApplyCouponAutomatically;


@property (weak, nonatomic) IBOutlet UILabel *cashbackDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackDescriptionLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackDescriptionLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *cashbackDescriptionsBottomView;


@end

@implementation IMCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Cart";
    self.applyButton.tag = IMApplyButtonStateApply;

    // Do any additional setup after loading the view.
    // set screen title
    if (self.cart != nil && self.cart.screenTitle != nil) {
        self.navigationItem.title = self.cart.screenTitle;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMCartScreenVisited withParameters:@{}];
    //[IMFlurry logEvent:IMTimeSpendInCart withParameters:@{} timed:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadDone:)
                                                 name:@"IMUploadDone"
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self downloadFeed];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[IMFlurry endTimedEvent:IMTimeSpendInCart withParameters:@{}];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)uploadDone:(NSNotification *)notification
{
    if(!self.isCalledOnce)
    {
        self.isCalledOnce = YES;
        [self.navigationController popToViewController:self animated:NO];
        [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];
    }
}

-(void)loadUI
{
    [self setUpNavigationBar];
    [self addSearchButton];

    [IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId = nil;
    [IMAccountsManager sharedManager].currentOrderPrescriptionUploadId = nil;

//    SET_FOR_YOU_CELL_BORDER(self.couponTxtField,[UIColor lightGrayColor]);
//    SET_FOR_YOU_CELL_BORDER(self.pinTxtField,[UIColor lightGrayColor]);
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self roundCornersOnView:self.applyButton onTopLeft:NO topRight:YES bottomLeft:NO bottomRight:YES radius:8.0];
    [self roundCornersOnView:self.checkButton onTopLeft:NO topRight:YES bottomLeft:NO bottomRight:YES radius:8.0];
    [IMFunctionUtilities setBackgroundImage:self.applyButton withImageColor:APP_THEME_COLOR];
    [IMFunctionUtilities setBackgroundImage:self.checkButton withImageColor:APP_THEME_COLOR];
    [IMFunctionUtilities setBackgroundImage:self.placeOrderButton withImageColor:APP_THEME_COLOR];
    SET_FOR_YOU_CELL_BORDER(self.couponTxtField, [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0], 2.0)
    self.modelArray = [[NSMutableArray alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, self.couponTxtField.frame.size.height)];
    self.couponTxtField.leftView = label;
    self.couponTxtField.leftViewMode = UITextFieldViewModeAlways;
    self.offerViewHeightConstraint.constant = 0;
    SET_FOR_YOU_CELL_BORDER(self.shopNowButton, [UIColor colorWithRed:20/255.0 green:144/255.0 blue:111/255.0 alpha:1.0], 8.0)

    self.scrollView.hidden = YES;
    self.shopNowButton.hidden = YES;

    self.placeOrderButton.hidden = YES;
//    if (IS_IOS8_OR_ABOVE)
//    {
//        self.tableView.estimatedRowHeight =180;;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//    }
//    [self downloadFeed];
    
}

- (void)downloadFeed
{
    //Dummy data
    //    for(NSInteger index = 0; index < 5; index++)
    //    {
    //        IMCartCellModel *cellModel = [[IMCartCellModel alloc] init];
    //        cellModel.name = [NSString stringWithFormat:@"Absorb absorbent dusting powder %ld",index ];
    //        cellModel.brand = @"Ranbaxy laboratories Ltd";
    //        cellModel.price = 125.0;
    //        cellModel.unitOfSales = @"Strip";
    //        cellModel.quantity = 1;
    //        cellModel.innerPackingQuantity = @"15 tablets";
    //        cellModel.isPrescriptionRequired = YES;
    //        cellModel.innerPackingUnit = @"tablet";
    //        [self.modelArray addObject:cellModel];
    //    }
    
    //    [self.view addProgressView];
  
    if(self.order)
    {
        if (self.order.isCompleteDetailPresent) {
            self.modelArray = [self.cart lineItems];
            [self updateUI];
            return;
        }
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] fetchOrderDetailWithOrderId:self.order.identifier completion:^(IMOrder *order, NSError *error) {
            [self hideActivityIndicatorView ];
            if(!error)
            {
                if(self.order)
                {
                    IMCart *cart = [IMCartUtility getCartFromOrder:order forType:IMUpdateOrder];
                    [self.cart updateWithCart:cart];
                    [self.order updateWithOrder:order];
                }
                else
                {
                    self.order = order;
                    
                }
                self.modelArray = [order orderedItems];
                [self updateUI];
            }
            else
            {
                [self handleError:error withRetryStatus:YES];
            }
        }];
        
    }
    else
    {
        [self showActivityIndicatorView];

        [[IMCartManager sharedManager] fetchCartWithCompletion:^(IMCart *cart, NSError *error)
         {
             [self hideActivityIndicatorView ];
             //         [self.view removeProgressView];
             if(!error)
             {
                 if(self.cart)
                 {
                     [self.cart updateWithCart:cart];

                 }
                 else
                 {
                     self.cart = cart;

                 }
                 self.modelArray = [cart lineItems];
                 [self updateUI];
             }
             else
             {
                 [self handleError:error withRetryStatus:YES];
             }
         }];
    }
    
}

- (void)updateUI
{
    self.scrollView.hidden = NO;
    self.shopNowButton.hidden = YES;

    self.placeOrderButton.hidden = NO;
    IMCart* cart = self.cart;
    
    if(self.cart.lineItems.count)
    {
        self.scrollView.hidden = NO;
        [self setNoContentTitle:@""];

        self.placeOrderButton.hidden = NO;
        // set place order button title
        if (self.cart != nil && self.cart.placeOrderButtonTitle != nil) {
            [self.placeOrderButton  setTitle:self.cart.placeOrderButtonTitle forState:UIControlStateNormal];
        }
        // in revise order flow get these from order as they are returned as string instead of number by the server
        if (!self.cart.isNewOrder) {
            self.itemsTotalPriceLabel.text = [NSString stringWithFormat:@"₹ %@",self.order.lineItemsTotal];
            self.shippingChargesLabel.text = [NSString stringWithFormat:@"₹ %@",self.order.shippingCharges];
            self.cartTotalLabel.text = [NSString stringWithFormat:@"₹ %@",self.order.totalAmount];
            self.discountTotalLabel.text = [NSString stringWithFormat:@"₹ %@",self.order.discountsTotal];
        }
        else{
            self.itemsTotalPriceLabel.text = [NSString stringWithFormat:@"₹ %@",cart.lineItemsTotal];
            self.shippingChargesLabel.text = [NSString stringWithFormat:@"₹ %@",cart.shippingsTotal];
            self.cartTotalLabel.text = [NSString stringWithFormat:@"₹ %@",cart.cartTotal];
            self.discountTotalLabel.text = [NSString stringWithFormat:@"₹ %@",cart.discountTotal];
        }
        [self configureOfferTotal];
        
        //ka display shipping description
        if (cart.shippingDescription != nil && cart.shippingDescription.length > 0) {
            self.shippingDescription.text = cart.shippingDescription;
        }
        else
        {
            self.shippingDescription.text = @"";
            self.shippingDescriptionHeightConstraint.constant = 0;
        }
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //ka set offer as table view header (if present)
        [self configureTableViewHeader];
        [self.tableView reloadData];
        

        
        CGFloat height = 0 ;
        
        for(NSInteger index=0;index<self.modelArray.count;index++)
        {
            height += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        //ka consider header view height also while calculating the table view height
        CGRect headerFrame = self.tableView.tableHeaderView.frame;
        height += headerFrame.size.height;
        
        self.tableViewHeightConstraint.constant = height;//self.modelArray.count
        // in revise order flow check discount total against order discount total
        if((self.cart.isNewOrder && [self.cart.discountTotal isEqual:@"0.00"]) ||
           ([self.order.discountsTotal isEqual:@"0.00"]))
        {
            self.savingsContainerHeightConstraint.constant = 0;
            self.viewUnderOrderTotal.backgroundColor = [UIColor clearColor];
        }
        else
        {
            self.savingsContainerHeightConstraint.constant = 50;
            self.viewUnderOrderTotal.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];

        }
    }
    else
    {
        self.scrollView.hidden = YES;
        self.placeOrderButton.hidden = YES;
        self.shopNowButton.hidden = NO;
//        [self setNoContentTitle:IMShopNow];
    }
    
    // in update order hide coupon view, shipping description
    // in normal cart flow, hide update order reason text displayed at the top
    if (self.cart != nil){
        switch (self.cart.cartOperationType) {
            case IMUpdateOrder:
            {
                // if order revise reason not present hide the controls
                if (self.order.orderReviseReason != nil && self.order.orderReviseReason.length > 0) {
                    self.mismatchDescriptionLabel.attributedText = [IMCartUtility bulletedParagraphString:self.order.orderReviseReason];
                }
                else{
                    [self hidePrescriptionMismatchControls];
                }
                [self hideCouponTags];
                [self hideCouponMessage];
                self.couponHeightConstraint.constant = 0;
                break;
            }
            default:
                //ka display the already applied coupons below the enter coupon code field
                [self configureCouponTags];
                [self configureCouponMessage];
                [self showAppliedCoupon];
                [self hidePrescriptionMismatchControls];
                [self checkAndApplyCoupon];
                break;
        }
    }
    else{
        [self hidePrescriptionMismatchControls];
    }
    self.couponTxtField.delegate = self;
    
    
    if(self.cart.isCashBackAvailable && self.cart.cashbackDescription)
    {
        self.cashbackDescriptionLabel.text = self.cart.cashbackDescription;
        self.cashbackDescriptionLabelTopConstraint.constant = 16.0f;
        self.cashbackDescriptionLabelBottomConstraint.constant = 20.0f;
        self.cashbackDescriptionsBottomView.hidden = NO;
    }
    else
    {
        self.cashbackDescriptionLabel.text = @"";
        self.cashbackDescriptionLabelTopConstraint.constant = 0.0f;
        self.cashbackDescriptionLabelBottomConstraint.constant = 0.0f;
        self.cashbackDescriptionsBottomView.hidden = YES;
    }
}

- (void) checkAndApplyCoupon
{
    if (self.needToApplyCouponAutomatically &&
        ![self.couponTxtField.text isOnlyWhitespaceCharacters] &&
        ![self.cart hasAppliedCouponCode]) {
        [self couponApply];
    }
    self.needToApplyCouponAutomatically = NO;
}

- (void) hidePrescriptionMismatchControls{
    self.mismatchDescriptionLabel.text = @"";
    self.mismatchDescriptionLabelBottomConstraint.constant = 0;
    self.mismatchDescriptionLabelTopConstraint.constant = 0;
}

#pragma mark  - Textfield Delegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
    if (self.activeField == self.couponTxtField) {
        NSInteger applyButtonTag = self.applyButton.tag;
        if (applyButtonTag == IMApplyButtonStateRemove) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
    if (self.activeField == self.couponTxtField) {
        [self changeApplyCouponState:false];
    }
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

#pragma mark  - Keyboard Handling Methods -

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.scrollView convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) )
    {
        [self.scrollView scrollRectToVisible:[self.scrollView convertRect:self.activeField.frame fromView:self.activeField.superview] animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark Coupon
/**
 @brief Method invoked to change the coupon related controls to apply or remove coupon
 @param couponApplied Boolean indicating whether coupon is applied or not
 @returns void
 */
- (void) changeApplyCouponState: (BOOL) couponApplied
{
    if(couponApplied)
    {
        [self setCouponFieldBackgroundColorForAppliedState];
        [self.applyButton setTitle:IMApplied forState:UIControlStateNormal];
        self.applyButton.tag = IMApplyButtonStateRemove;
    }
    else
    {
        self.couponTxtField.backgroundColor = [UIColor whiteColor];
        [self.applyButton setTitle:IMApply forState:UIControlStateNormal];
        self.applyButton.tag = IMApplyButtonStateApply;
    }
}
-(void) setCouponFieldBackgroundColorForAppliedState
{
    self.couponTxtField.backgroundColor = COUPON_LABEL_BACKGROUND_COLOR;
    NSArray *coupons = [self.cart appliedCoupons];
    if (coupons && coupons.count) {
        IMCoupon *coupon = coupons[0];
        if (coupon && coupon.isExpired){
            self.couponTxtField.backgroundColor = COUPON_LABEL_BACKGROUND_COLOR_FOR_EXPIRED_STATE;
        }
    }
}

/**
 @brief Sets Enter coupon code field with the coupon applied earlier
 @returns void
 */
- (void) showAppliedCoupon
{
    if (self.cart.appliedCoupons && self.cart.appliedCoupons.count) {
        IMCoupon *coupon = self.cart.appliedCoupons[0];
        self.couponTxtField.text = coupon.couponCode;
        [self changeApplyCouponState:true];
    }
}

/**
 @brief Applies user entered coupon to the cart
 @returns void
 */
- (void) couponApply

{
    NSString *coupon = self.couponTxtField.text;
    [self.couponTxtField endEditing:true];
    // ignore only whitespaces text
    if (![coupon isOnlyWhitespaceCharacters]) {
        // if user not logged in then load login page
        if([[IMAccountsManager sharedManager] userToken])
        {
            [self showActivityIndicatorView];
            [[IMCartManager sharedManager] applyCoupon:self.couponTxtField.text withCart:self.cart withCompletion:^(IMCart *cart, NSError *error) {
                [self hideActivityIndicatorView];
                if(!error)
                {
                    if(self.cart)
                    {
                        [self.cart updateWithCart:cart];
                        
                    }
                    else
                    {
                        self.cart = cart;
                        
                    }
                    self.modelArray = [cart lineItems];
                    [self updateUI];
                    [self vibrate];
                }
                else
                {
                    [self handleError:error withRetryStatus:YES];

//                    NSString *message = (error.userInfo[IMMessage] && ![error.userInfo[IMMessage] isEqualToString:@""])?error.userInfo[IMMessage]:IMGeneralRequestFailureMessage;
//                    [self showAlertWithTitle:IMError andMessage:message];
                }
            }];
        }
        else{
            [self.couponTxtField endEditing:true];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:IMLoginToApplycouponMessage delegate:self cancelButtonTitle:IMOK otherButtonTitles: nil] ;
//            alert.tag = IMLoginConfirmAlertTag;
//            [alert show];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:IMLoginToApplycouponMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:IMOK
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self performSegueWithIdentifier:@"IMPlaceOrderLoginSegue" sender:self];
                                           }];
            
            
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else{
        [self showAlertWithTitle:@"" andMessage:IMInvalidCoupenCode];
    }
}

/**
 @brief Removes earlier entered coupon to the cart
 @returns void
 */
- (void) couponRemove
{
    NSString *coupon = self.couponTxtField.text;
    // if coupon is expired/ineligible do not make server call, just clear the coupon text field
    NSArray *coupons = [self.cart appliedCoupons];
    if (coupons && coupons.count) {
        IMCoupon *coupon = coupons[0];
        if (coupon && coupon.isExpired){
            self.couponTxtField.text = @"";
            [self changeApplyCouponState:false];
            [self hideCouponMessage];
            return;
        }
    }
    
    [self showActivityIndicatorView];
    [[IMCartManager sharedManager] removeCoupon:coupon withCart:self.cart withCompletion:^(IMCart *cart, NSError *error) {
        [self hideActivityIndicatorView];

        if(!error)
        {
            if(self.cart)
            {
                [self.cart updateWithCart:cart];
                
            }
            else
            {
                self.cart = cart;
                
            }
            self.modelArray = [cart lineItems];
            [self updateUI];
            self.couponTxtField.text = @"";
            [self changeApplyCouponState:false];
            [self hideCouponMessage];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];

//            NSString *message = (error.userInfo[IMMessage] && ![error.userInfo[IMMessage] isEqualToString:@""])?error.userInfo[IMMessage]:IMGeneralRequestFailureMessage;
//            [self showAlertWithTitle:IMError andMessage:message];
        }
    }];
}

#pragma mark Configure table view header
/**
 @brief Sets header view for the Line items table.
 @brief When cart has offer that needs to be shown at the top of the cart screen.
 @returns void
 */
- (void) configureTableViewHeader
{
    if (self.cart.promotionalOffers && self.cart.promotionalOffers.count) {
        self.cartOfferCollectionView.delegate = self;
        self.cartOfferCollectionView.dataSource = self;
        [ self.cartOfferCollectionView reloadData];
        self.tableView.tableHeaderView = self.cartOfferCollectionView;
    }
    else{
        // if no promotional offers then hide the offer view displayed at the top
        self.tableView.tableHeaderView = nil;
    }
    
    // configure offer header
   /* NSString *offerTitle = @"Thermometer worth Rs. 200 free";
    NSString *offerDescription = @"on purchase of Rs. 1500 or above";
    NSString *offertext = [NSString stringWithFormat:@"%@ %@",offerTitle, offerDescription];
    
    // offer with only text
//    self.offerImageWidthConstraint.constant = 0;
//    self.offerImageLeadingSpaceConstraint.constant = 0;
    self.offerTextLabel.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedString = [IMCartUtility bold:offerTitle inText:offertext];
    self.offerTextLabel.attributedText = attributedString;

    // offer with text and image
//    self.offerTextLabel.text = [NSString stringWithFormat:@"%@ %@",offerTitle, offerDescription];
    */
}
#pragma mark Configure offer

/**
 @brief Sets line item wise offer below the line item price field.
 @brief When each line item has offer (on prescription availability) same needs to be shown in every line item
 @param cartCell: IMCartTableViewCell* The table view cell
 @param lineItem: IMLineItem* The cart line item detail
 @returns void
 */
- (void) configureCartItemOffer:(IMCartTableViewCell *)cartCell
                                     lineItem: (IMLineItem*) lineItem
{
    // hide offer controls
    [self hideCartItemOfferControls:cartCell];
    /*
    cartCell.offerTextLabel.text  = @"Extra 10% off on prescription available.";
    cartCell.offerPriceLabel.text = [NSString stringWithFormat:@"₹ %.02lf",[lineItem.offerPrice doubleValue]];
    cartCell.offerPriceLabel.textColor  = [UIColor blackColor];
     */
}
/**
 @brief Hides line item wise offer related UI controls
 @param cartCell: IMCartTableViewCell* The table view cell
 @returns void
 */
- (void) hideCartItemOfferControls:(IMCartTableViewCell *)cartCell
{
    cartCell.offerPriceLabel.text = @"";
    cartCell.offerTextLabel.text = @"";
    cartCell.offerLabelHeightConstraint.constant = 0;
    cartCell.offerLabelBottomSpaceConstraint.constant = 0;
}

/**
 @brief Sets offer total (below the items total controls) if offer is available. Else hides offer related controls.
 @returns void
 */
- (void) configureOfferTotal
{
    NSString *offerTitleLabel = IMDiscountTitle;
    NSString *offerTotal = nil;
//self.cart.promotionDiscountTotal = @(40.00);
    NSNumber *promotionDiscount = @(self.cart.promotionDiscountTotal.floatValue);
    if (!self.cart.promotionDiscountTotal ||
        [self.cart.promotionDiscountTotal isEqual:@"0.00"] || [promotionDiscount isEqualToNumber:@(0.00)]){
        // hide offer related controls
        self.offerTitle.text = @"";
        self.offerTotalPriceLabel.text = @"";
        self.offerTitleHeightConstraint.constant = 0;
        self.offerTitleBottomSpaceConstraint.constant = 0;
    }
    else{
        // set offer text and price if available
        offerTotal = [NSString stringWithFormat:@"- ₹ %.02lf",[self.cart.promotionDiscountTotal doubleValue]];
        // set offer text and price if available
        self.offerTitle.text = offerTitleLabel;
        self.offerTotalPriceLabel.text = offerTotal;
    }
}

/**
 @brief Prepares displaying the coupon tags  below the enter coupon code field
 @returns void
 */
- (void) configureCouponTags
{
    // For the time being hide the coupon tags collection view
    [self hideCouponTags];

    // to enable coupon tags collection view
    /*self.couponTagsCollectionView.dataSource = self;
    self.couponTagsCollectionView.delegate = self;
    [self reloadCouponTags];*/
}

- (void) hideCouponTags
{
    self.couponTagCollectionViewHeight.constant = 0;
    self.couponTagCollectionviewBottomConstraint.constant = 0;
    [self setDefaultCouponFieldHeight];
}

/**
 @brief Prepares displaying the coupon message  below the enter coupon code field
 @returns void
 */
- (void) configureCouponMessage
{
    NSArray *coupons = [self.cart appliedCoupons];
    if (coupons && coupons.count) {
        IMCoupon *coupon = coupons[0];
        if (coupon && coupon.message && ![coupon.message isEqualToString:@""]) {
            self.couponMessageBottomSpaceConstraint.constant = 10.0f;
            self.couponMessageLabel.text = coupon.message;
            // if coupon is expired then set red color for the message text; else gray
            if (coupon.isExpired) {
                self.couponMessageLabel.textColor = [UIColor redColor];
            }
            else{
                self.couponMessageLabel.textColor = COUPON_LABEL_TEXT_COLOR_FOR_APPLIED_STATE;
            }
            [self.couponMessageLabel sizeToFit];
            [self setCouponFieldwithMessageHeightWithMessage:coupon.message];
        }
       else{
           // hide the coupon message if no applied coupons available
           [self hideCouponMessage];
           [self setDefaultCouponFieldHeight];
       }
    }
    else{
        // hide the coupon message if no applied coupons available
        [self clearCouponCode];
        [self hideCouponMessage];
        [self setDefaultCouponFieldHeight];
    }
}

- (void) clearCouponCode
{
    if (![self.couponTxtField.text isOnlyWhitespaceCharacters] &&
        self.applyButton.tag == IMApplyButtonStateRemove) {
        self.couponTxtField.text = @"";
        [self changeApplyCouponState:false];
    }
}
/**
 @brief Hides coupon message related controls
 @returns void
 */
- (void) hideCouponMessage
{
    self.couponMessageLabel.text = @"";
    self.couponMessageHeightConstraint.constant = 0;
    self.couponMessageBottomSpaceConstraint.constant = 0;
    [self setDefaultCouponFieldHeight];
}

/**
 @brief Shows coupon message related controls
 @returns void
 */
- (void) showCouponMessage
{
    [self configureCouponMessage];
}

- (void) setDefaultCouponFieldHeight
{
    self.couponHeightConstraint.constant = 70.0;
    //[self.view layoutIfNeeded];
    //[self.view setNeedsUpdateConstraints];
}
- (void) setCouponFieldwithMessageHeightWithMessage:(NSString *)message
{
    CGFloat messageHeight = self.couponMessageLabel.frame.size.height;
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                                    initWithString:message
                                                    attributes:@{
                                                                 NSFontAttributeName: self.couponMessageLabel.font
                                                                }];
    CGSize expectedLabelSize = [attributedText boundingRectWithSize:maximumLabelSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil].size;

    if (messageHeight == 0) {
        messageHeight = 25.0;
    }
    self.couponHeightConstraint.constant = 70.0 + expectedLabelSize.height + 13.0;
}

//- (void) setCouponFieldwithMessageHeight
//{
//    CGFloat messageHeight = self.couponMessageLabel.frame.size.height;
//    if (messageHeight == 0) {
//        messageHeight = 19.0;
//    }
//    self.couponMessageHeightConstraint.constant = messageHeight;
//    self.couponHeightConstraint.constant = 70.0 + messageHeight + 15.0;
//    //[self.view layoutIfNeeded];
//    //[self.view setNeedsUpdateConstraints];
//}

#pragma mark - TableView Datasource and delegate Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.modelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMCartTableViewCell* cartCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMCartCellIdentitifier" forIndexPath:indexPath];
    [self configureCell:cartCell forRowAtIndexPath:indexPath];

    cartCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cartCell;
}

- (void)configureCell:(IMCartTableViewCell *)cartCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMLineItem *model = [self.modelArray objectAtIndex:indexPath.row];

    cartCell.qtyButton.tag = indexPath.row;
    cartCell.deleteButton.tag = indexPath.row;
    cartCell.qtyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cartCell.qtyButton.layer.borderWidth = 1;
    cartCell.nameLabel.text = model.name;
    cartCell.priceLabel.text = @"";
    if([model.discountPercentage isEqual:@"0.0"])
    {
        cartCell.priceLabel.text = [NSString stringWithFormat:@"₹ %.02lf",[model.salesPrice doubleValue]];
    }
    else
    {
        cartCell.priceLabel.text = [NSString stringWithFormat:@"₹ %.02lf",[model.promotionalPrice doubleValue]];
    }
    cartCell.unitLabel.text = @"";
    if(model.unitOfSales)
        cartCell.unitLabel.text = model.unitOfSales;

    
    
    if(model.innerPackingQuantity.length > 9)
    {
        model.innerPackingQuantity = [model.innerPackingQuantity substringToIndex:9];
        model.innerPackingQuantity = [NSString stringWithFormat:@"%@...",model.innerPackingQuantity];
        cartCell.unitLabel.text =  [NSString stringWithFormat:@"%@ (1x%@)", cartCell.unitLabel.text,model.innerPackingQuantity];
    }
    else if(model.innerPackingQuantity.length > 0)
    {
        cartCell.unitLabel.text =  [NSString stringWithFormat:@"%@ (1x%@)", cartCell.unitLabel.text,model.innerPackingQuantity];
        
    }
    cartCell.totalPriceLabel.text =  [NSString stringWithFormat:@"₹ %.02lf",[model.totalPrice doubleValue] ];
    [cartCell.qtyButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.quantity] forState:UIControlStateNormal]  ;
    
    cartCell.prescriptionrequiredLabel.text = @"";
    
    cartCell.insufficientInventoryLabel.text = @"";
    cartCell.insufficientInventoryTopConstraint.constant = 0;
    
    cartCell.insufficientInventoryBottomSpaceConstraint.constant = 10;
    cartCell.prescriptionRequiredBottomSpaceConstraint.constant = 0;

    
    //ka to fix product unavailable issue while adding product to cart from prescription
    // in case of update order no need to check for product unavailability
    if((self.cart.needToCheckForProductAvailability && model.isActive) ||
       !self.cart.needToCheckForProductAvailability)
    {
        // hide the price overlay label added on top of price/quantity field
        cartCell.priceOverlayLabel.hidden = YES;
        cartCell.prescriptionRequiredBottomSpaceConstraint.constant = 10;

        if(model.isPrescriptionAvailable)
        {
            if([[IMAccountsManager sharedManager] userToken])
            {
                if(model.prescriptionMessage && ![model.prescriptionMessage isEqualToString:@""])
                {
                    cartCell.prescriptionrequiredLabel.text  = model.prescriptionMessage;
                }
                else
                {
                    cartCell.prescriptionrequiredLabel.text = IMPrescriptionPresent;
                }
            }
            else
            {
                cartCell.prescriptionrequiredLabel.text = IMPrescriptionPresent;
            }
            //IMPrescriptionPresent;
            cartCell.prescriptionrequiredLabel.textColor  = [UIColor blackColor];
        }
        else if(model.isPrescriptionRequired)
        {
            if([[IMAccountsManager sharedManager] userToken])
            {
                if(model.prescriptionMessage && ![model.prescriptionMessage isEqualToString:@""])
                {
                    cartCell.prescriptionrequiredLabel.text  = model.prescriptionMessage;
                }
                else
                {
                    cartCell.prescriptionrequiredLabel.text = IMPrescriptionRequired;
                }
            }
            else
            {
                cartCell.prescriptionrequiredLabel.text = IMPrescriptionRequired;
            }
            //cartCell.prescriptionrequiredLabel.text  = model.prescriptionMessage;//IMPrescriptionRequired;
            cartCell.prescriptionrequiredLabel.textColor  = [UIColor colorWithRed:150.0/255.0 green:61.0/255.0  blue:45.0/255.0  alpha:1];//APP_THEME_COLOR;
        }
        else
        {
            cartCell.prescriptionRequiredBottomSpaceConstraint.constant = 0;
        }
        [self configureCartItemOffer:cartCell lineItem:model];

        [cartCell.qtyButton setEnabled:YES];
        
        // do not allow editing quantity for order revise flow
        if (self.cart != nil &&
            !self.cart.canEditQuantity) {
            [cartCell.qtyButton setEnabled:NO];
        }

        cartCell.contentView.backgroundColor = CART_CELL_BACKGROUND_COLOR_ENABLED;

        // TODO:Check against available 14-sep-15
        if (self.cart.shouldCheckLineItemsQuantity) {
            if([model.maxOrderQuanitity  integerValue]== 0 )
            {
                cartCell.insufficientInventoryLabel.text = IMNotAvaialble;
                cartCell.insufficientInventoryTopConstraint.constant = 10;
                // do not allow quantity editing if product not available
                [cartCell.qtyButton setEnabled:NO];
                cartCell.contentView.backgroundColor = CART_CELL_BACKGROUND_COLOR_DISABLED;
            }
            else if(model.quantity > [model.maxOrderQuanitity integerValue])
            {
                cartCell.insufficientInventoryLabel.text = [NSString stringWithFormat:@"Only %@ left in stock",model.maxOrderQuanitity];
                cartCell.insufficientInventoryTopConstraint.constant = 10;
            }
        }
        
        if(model.isCashBackAvailable && model.cashbackDescription)
        {
            cartCell.cashbackDescriptionLabel.text = model.cashbackDescription;
            cartCell.cashbackIconHeightConstraint.constant = 14.0f;
            cartCell.cashbackIconBottomConstraint.constant = 10.f;
        }
        else
        {
            cartCell.cashbackDescriptionLabel.text = @"";
            cartCell.cashbackIconHeightConstraint.constant = 0;
            cartCell.cashbackIconBottomConstraint.constant = 0;
        }
    }
    else{
		// if active = false then do not show price, quantity, unit fields, cashback fields
        [cartCell.qtyButton setEnabled:NO];
        cartCell.priceOverlayLabel.hidden = NO;
        cartCell.priceOverlayLabel.text = IMNotAvailable;
        cartCell.contentView.backgroundColor = CART_CELL_BACKGROUND_COLOR_DISABLED;
        [self hideCartItemOfferControls:cartCell];
        //
        cartCell.insufficientInventoryBottomSpaceConstraint.constant = 0;
        cartCell.prescriptionRequiredBottomSpaceConstraint.constant = 0;
        cartCell.prescriptionRequiredHeightConstraint.constant = 0;
        cartCell.insufficientInventoryHeightConstraint.constant = 0;
        
        cartCell.cashbackDescriptionLabel.text = @"";
        cartCell.cashbackIconHeightConstraint.constant = 0;
        cartCell.cashbackIconBottomConstraint.constant = 0;
        
    }
    // do not allow to remove the product in case of update order
    if (self.cart != nil &&
        !self.cart.canRemoveLineItem) {
        cartCell.deleteButton.hidden = YES;
    }
    else{
        cartCell.deleteButton.hidden = NO;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
//    if (IS_IOS8_OR_ABOVE) {
//        return UITableViewAutomaticDimension;
//    }
    
    if(!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMCartCellIdentitifier"];
    }
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
//    [self.prototypeCell updateConstraintsIfNeeded];
//    [self.prototypeCell layoutIfNeeded];
    
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"cell height = %lf",height);
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMLineItem *lineItem = self.modelArray[indexPath.row];
    if(lineItem.isActive)
    {
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = lineItem.identifier;
        
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if(lineItem.isPharma)
        {
            IMPharmaDetailViewController* pharmaVC = [storyboard instantiateViewControllerWithIdentifier:IMPharmaDetailViewControllerID];
            pharmaVC.product = product;
            [self.navigationController pushViewController:pharmaVC animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];

        }
        else
        {
            IMNonPharmaDetailViewController* pharmaVC = [storyboard instantiateViewControllerWithIdentifier:IMNonPharmaDetailViewControllerID];
            pharmaVC.selectedModel = product;
            [self.navigationController pushViewController:pharmaVC animated:YES];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];

        }
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:IMProductNotInCity];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(void)checkForPrescriptionRequiredProducts
{
    
    NSMutableArray *pendingArray = [self filterPresciptionrequiredProducts];
    
    if(pendingArray.count)
    {
        if(IS_IOS8_OR_ABOVE)
        {
            if(self.cart.atTheTimeOfDeliveryAllowed)
            {
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:IMYourOrderRquiresPrescription message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:IMUploadNow style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      [self performSegueWithIdentifier:@"IMPrescriptionPendingSegue" sender:pendingArray];
                                      [IMFlurry logEvent:IMUploadPrescriptionNow withParameters:@{}];
                                      
                                  }]];
                [alert addAction:[UIAlertAction actionWithTitle:IMAtDelivery style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      
                                      [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:self];
                                      [IMFlurry logEvent:IMTimeOfDelivery withParameters:@{}];
                                      
                                      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];
                                      
                                  }]];
                [alert addAction:[UIAlertAction actionWithTitle:IMCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                  }]];
                alert.view.tintColor = APP_THEME_COLOR;
                [self presentViewController:alert animated:YES completion:nil];
                alert.view.tintColor = APP_THEME_COLOR;
            }
            else
            {
                [self performSegueWithIdentifier:@"IMPrescriptionPendingSegue" sender:pendingArray];
                [IMFlurry logEvent:IMUploadPrescriptionNow withParameters:@{}];
            }
        }
        else
        {
            if(self.cart.atTheTimeOfDeliveryAllowed)
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:IMYourOrderRquiresPrescription delegate:self cancelButtonTitle:IMCancel destructiveButtonTitle:nil otherButtonTitles:IMUploadNow,IMAtDelivery, nil];
                
                [actionSheet showFromTabBar:self.tabBarController.tabBar];
            }
            else
            {
                [self performSegueWithIdentifier:@"IMPrescriptionPendingSegue" sender:pendingArray];
                [IMFlurry logEvent:IMUploadPrescriptionNow withParameters:@{}];
            }
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:self];
    }
}

#pragma mark - Action sheet delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableArray *pendingArray = [self filterPresciptionrequiredProducts];

    switch (buttonIndex) {
        case 0:
            
            [self performSegueWithIdentifier:@"IMPrescriptionPendingSegue" sender:pendingArray];
            [IMFlurry logEvent:IMUploadPrescriptionNow withParameters:@{}];

            break;
            
        case 1:
        {
            [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:self];
            [IMFlurry logEvent:IMTimeOfDelivery withParameters:@{}];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];
//            [self showAlertWithTitle:@"Alert" andMessage:@"This option is not available for you"];


        }
            break;
        case 2:
        {
            break;
        }
        default:
            break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        }
    }
}
/**
 @brief Returns a  boolean value indicating whether the apply coupon alert has to be displayed or not
 @brief If user taps on Place Order button with coupon code entered and not applied then YES is returned, NO otherwise.
 @brief User need to apply the coupon first to proceed further after entering a coupon code
 @returns void
 */

- (BOOL) shouldShowApplyCouponAlert
{
    return (![self.couponTxtField.text isOnlyWhitespaceCharacters] &&
            self.couponTxtField.text.length > 0 &&
            self.applyButton.tag == IMApplyButtonStateApply);
}

- (IBAction)placeOrderPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMPlaceOrderFromCart withParameters:@{}];
    // to decide what needs to be done after logging in
    self.userAction = IMOrderPlace;
    
//    if ([self shouldShowApplyCouponAlert]) {
//        [self showAlertWithTitle:IMCouponNotAppliedTitle andMessage:IMCouponNotAppliedMessage];
//        return;
//    }
    if(self.cart.shouldCheckLineItemsQuantity)
    {
        if(![self.cart checkLineItemsQuantity])
        {
            [self showAlertWithTitle:IMINsufficientInventory andMessage:IMPlsReduceQty];
            return;
        }
    }
    //Uncomment for enabling max allowed POD check
//    if(![self.cart checkMaxAllowedPOD])
//    {
//        [self showAlertWithTitle:IMPODExceededTitle andMessage:IMPODExceededMessage];
//        return;
//    }

    if (self.cart.isNewOrder) {
        if([[IMAccountsManager sharedManager] userToken])
        {
            if([IMAccountsManager sharedManager].currentOrderPrescriptionUploadId)
            {
                [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:self];
            }
            else
            {
                [self checkForPrescriptionRequiredProducts];
            }
        }
        else
        {
            [self performSegueWithIdentifier:@"IMPlaceOrderLoginSegue" sender:self];
        }
    }
    // revise order
    else{
        if([[IMAccountsManager sharedManager] userToken])
        {
            if([IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId)
            {
                [self performSegueWithIdentifier:@"IMDeliveryAddressSegue" sender:self];
            }
            else
            {
                [self checkForPrescriptionRequiredProducts];
            }
        }
    }
}

- (IBAction)editQuantityPressed:(UIButton *)sender
{
    self.selectedModel = self.modelArray[sender.tag];
    IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
    quantitySelectionViewController.delgate = self;
    quantitySelectionViewController.product = (IMLineItem*)self.selectedModel;
//    quantitySelectionViewController.view.frame = self.navigationController.view.bounds;
//    [self.navigationController addChildViewController:quantitySelectionViewController];
//    [self.navigationController.view addSubview:quantitySelectionViewController.view];
//    [self didMoveToParentViewController:self.navigationController];
    quantitySelectionViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:quantitySelectionViewController animated:NO completion:nil];
}

- (IBAction)deleteCartItemPressed:(UIButton*)sender
{
    self.selectedModel = self.modelArray[sender.tag];
    [self showActivityIndicatorView];
    
    [[IMCartManager sharedManager] deleteCartItemWithId:self.selectedModel.identifier withCompletion:^(IMCart* cart, NSError *error) {
        
        [self hideActivityIndicatorView];
        if(!error)
        {
            [self.cart updateWithCart: cart];
            self.modelArray = cart.lineItems;
            NSLog(@"deleted cart");
            [self updateUI];
        }
        else
        {
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
    }];

}

-(void)quantitySelectionController:(IMQuantitySelectionViewController *)quantitySelectionController didFinishWithWithQuanity:(NSInteger)quanity
{
    ((IMLineItem*)self.selectedModel).quantity = quanity;
    
    [self showActivityIndicatorView];
    
    [[IMCartManager sharedManager] updateCartItems:@[self.selectedModel] withCompletion:^(IMCart* cart, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            [self.cart updateWithCart: cart];
            self.modelArray = [cart lineItems];

            NSLog(@"updated cart");
            [self updateUI];

        }
        else
        {
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
    }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"IMPrescriptionPendingSegue"])
    {
        IMPrescriptionPendingViewController *pendingVC = (IMPrescriptionPendingViewController *) segue.destinationViewController;
        pendingVC.modelArray = sender;
        pendingVC.cart = self.cart;
        pendingVC.order = self.order;
    }
    else if([segue.identifier isEqualToString:@"IMPlaceOrderLoginSegue"])
    {
        IMPlaceOrderLoginViewController* loginViewController = segue.destinationViewController;
        loginViewController.completionBlock = ^(){
            [self.navigationController popToViewController:self animated:YES];
            self.modelArray = [IMCartManager sharedManager].currentCart.lineItems;
            self.cart = [IMCartManager sharedManager].currentCart;
            switch (self.userAction) {
                // If user has tapped on "Place Order" button without log-in, then after login load either delivery address segue or put up action sheet to choose prescription upload
                case IMOrderPlace:
                    [self checkForPrescriptionRequiredProducts];
                    break;
                // If user has tapped on coupon "Apply" button without log-in, then after login load keypad to enter the coupon code
                case IMApplyCoupon:
                    self.needToApplyCouponAutomatically = YES;
//                    [self.couponTxtField becomeFirstResponder];
                    break;
                default:
                    break;
            }
        };
    }
    else if([segue.identifier isEqualToString:@"IMDeliveryAddressSegue"])
    {
        IMDeliveryAddressViewController* addressViewController = (IMDeliveryAddressViewController*)segue.destinationViewController;
        addressViewController.cart = self.cart;
        addressViewController.order = self.order;
    }
}

- (NSMutableArray *)filterPresciptionrequiredProducts
{
    NSMutableArray *prescriptionProduct = [[NSMutableArray alloc] init];
    for( IMLineItem* cartModel in self.modelArray)
    {
        if (cartModel.isPrescriptionRequired && !cartModel.isPrescriptionAvailable) {
            [prescriptionProduct addObject:cartModel];
        }
    }
    return prescriptionProduct;
}

//-(void)uploadDone:(NSNotification*)notification
//{
//    [self.navigationController popToViewController:self animated:YES];
//}

- (IBAction)applyCuopenPressed:(id)sender {
    
    [IMFlurry logEvent:IMCuoponCodeApplied withParameters:@{}];
    // to decide what needs to be done after logging in to proceed with cart checkout
    self.userAction = IMApplyCoupon;
    
    NSInteger buttonTag = self.applyButton.tag;
    if (buttonTag == IMApplyButtonStateApply) {
        [self couponApply];
    }
    else{
        [self couponRemove];
    }
}

-(UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    }
    else
    {
        return view;
    }
}


- (IBAction)shopNowPressed:(UIButton *)sender
{

    NSInteger selectedTab = self.tabBarController.selectedIndex;
 //Select home tab
    [self.tabBarController setSelectedIndex:0];
    //Pop only home and selected tab to root.
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:selectedTab] popToRootViewControllerAnimated:NO];

    //pop all tabs to root.Resetting App.
//    for(UIViewController *viewController in self.tabBarController.viewControllers)
//    {
//        if([viewController isKindOfClass:[UINavigationController class]])
//            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
//    }
}

- (void)loadSearch
{
    [super loadSearch];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMUploadDone" object:nil];

}

#pragma mark - CollectionView -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // for cart offers collection view displayed at the top of the Cart screen
    if (collectionView == self.cartOfferCollectionView) {
        return self.cart.promotionalOffers.count;
    }
    // for coupon tags collection view displayed below the Coupon code controls in the Cart screen
    else if (collectionView == self.couponTagsCollectionView) {
        return self.cart.appliedCoupons.count;
    }
    return 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // for cart offers collection view displayed at the top of the Cart screen
    if (collectionView == self.cartOfferCollectionView) {
        IMCartOfferCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cartOfferCell" forIndexPath:indexPath];
        collectionViewCell.model = self.cart.promotionalOffers[indexPath.row];
        
        return collectionViewCell;
    }
    // for coupon tags collection view displayed below the Coupon code controls in the Cart screen
    else if (collectionView == self.couponTagsCollectionView) {
        IMTagCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
        [collectionViewCell setModel:self.cart.appliedCoupons[indexPath.row]];
        collectionViewCell.crossButton.tag = indexPath.row;
        [collectionViewCell.crossButton addTarget:self action:@selector(crossMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        return collectionViewCell;
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    // for cart offers collection view displayed at the top of the Cart screen
    if (collectionView == self.cartOfferCollectionView) {
        size = CGSizeMake(self.view.frame.size.width, 75.0f);
    }
    // for coupon tags collection view displayed below the Coupon code controls in the Cart screen
    else if (collectionView == self.couponTagsCollectionView) {
        size = CGSizeMake(125.0f, 44.0f);
    }
    return size;
}

/**
 @brief Removes the coupon from the coupons list on tapping cross mark (X) next to the coupon code.
 @param sender: UIButton* Cross mark button
 @returns void
 */

-(void)crossMarkPressed:(UIButton*)sender
{
    // remove the coupon code and reload the collection view
    [self.cart.appliedCoupons removeObjectAtIndex:sender.tag];
    [self reloadCouponTags];
}

/**
 @brief Loads the coupons applied by the user below the coupon code controls.
 @returns void
 */
- (void) reloadCouponTags
{
    if (self.cart.appliedCoupons.count) {
        [self.couponTagsCollectionView reloadData];
    }
    else{
        self.couponTagCollectionViewHeight.constant = 0;
        self.couponTagCollectionviewBottomConstraint.constant = 0;
    }
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
//#pragma mark UIAlertViewDelegate methods
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	// load login screen once the login confirmation alert is dismissed
//    if(IMLoginConfirmAlertTag == alertView.tag)
//    {
//        [self performSegueWithIdentifier:@"IMPlaceOrderLoginSegue" sender:self];
//    }
//}

@end
