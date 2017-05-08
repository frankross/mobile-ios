//
//  IMOrderDetailViewController.m
//  InstaMed
//
//  Created by Arjuna on 01/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderDetailViewController.h"
#import "IMOrder.h"
#import "IMOrderSummaryTableViewCell.h"
#import "IMOrderReminderViewController.h"
#import "IMCartViewController.h"
#import "IMAccountsManager.h"
#import "IMCancelReasonsViewController.h"
#import "IMCartUtility.h"
#import "IMOrderListViewController.h"
#import "IMProduct.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMReturnProductsListingViewController.h"

const NSInteger IMReminderContainerViewHeight = 120;
const  NSInteger IMReminderSwitchContainerViewHeight = 46;
const  NSInteger IMReminderDataContainerViewHeight = 74;

@interface IMOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,IMOrderReminderViewControllerDelgate,IMCancelReasonsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryProgressHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToDeliveryProgressVConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *stateDisplayNameCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDisplayNameProgressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDateContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveredDateContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryProgressContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderedItemsTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reorderRemainderHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;
@property (weak, nonatomic) IBOutlet UIView *patientViewTopSeaparatorView;


@property (weak, nonatomic) IBOutlet UIView *patientInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *doctorIcon;
@property (weak, nonatomic) IBOutlet UIImageView *patientIcon;
@property (weak, nonatomic) IBOutlet UILabel *patientTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientNameTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientNameBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorNameTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doctorNameBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *patientSeparatorView;

@property (weak, nonatomic) IBOutlet UILabel *orderedDateAfterDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderedDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *orderedItemsTableView;
@property (weak, nonatomic) IBOutlet UILabel *deliveredDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *shippingChargesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPhoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *shippedAddressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippedFromAddress;
@property (weak, nonatomic) IBOutlet UILabel *shippedFromPhoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *drugLicenseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelOrReturnOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *etalLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reorderReminderHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;
@property (weak, nonatomic) IBOutlet UIView *reorderReminderContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reorderRemainderContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reorderReminderSwitchContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reorderReminderDataContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *frequencyStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reorderSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelOrReturnOrderButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelOrReorderButtonTopConstraint;

@property (nonatomic, strong) IMOrderSummaryTableViewCell *prototypeCell;
@property (nonatomic,weak) IMCancelReasonsViewController* cancelReasonsController;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

// Discount related outlets
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountPriceTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountPriceLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountPriceHeightConstraint;
@end

@implementation IMOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMOrderDetailTimeSpent withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMOrderDetailScreenVisited withParameters:@{}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMOrderDetailTimeSpent withParameters:@{}];
}

-(void)loadUI
{
    [super setUpNavigationBar];
    self.scrollView.hidden = YES;
    self.reorderButton.hidden = YES;
    [self downloadFeed];
    SET_CELL_CORER(self.cancelOrReturnOrderButton, 8.0);
    [IMFunctionUtilities setBackgroundImage:self.cancelOrReturnOrderButton withImageColor:APP_THEME_COLOR];
    self.reorderSwitch.onTintColor = APP_THEME_COLOR;

}

-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] fetchOrderDetailWithOrderId:self.orderId completion:^(IMOrder *order, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.selectedModel = order;
            [self updateUI];
        }
        else if(error.userInfo[IMMessage])
        {
            [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
        }
        else
        {
            [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
    }];

}

-(void)updateUI
{
    self.scrollView.hidden = NO;
    self.reorderButton.hidden = NO;
    IMOrder* order = (IMOrder*)self.selectedModel;
    self.reorderSwitch.on = order.hasReoorderReminder;
    self.patientSeparatorView.hidden = NO;
    self.patientViewTopSeaparatorView.hidden = NO;
    if(order.patientName && ![order.patientName isEqualToString:@""])
    {
        self.patientIcon.hidden = NO;
        self.patientTitleLabel.hidden = NO;
        self.patientNameBottomConstraint.constant = 16;
        self.patientNameTopConstraint.constant = 16;
        self.patientNameLabel.attributedText = [self attributedStringForString:order.patientName];
    }
    else
    {
        self.patientNameLabel.text = @"";
        self.patientIcon.hidden = YES;
        self.patientTitleLabel.hidden = YES;
        self.patientNameBottomConstraint.constant = 0;
        self.patientNameTopConstraint.constant = 0;
        self.patientSeparatorView.hidden = YES;
    }
    if(order.doctorName && ![order.doctorName isEqualToString:@""])
    {
        self.doctorIcon.hidden = NO;
        self.doctorTitleLabel.hidden = NO;
        self.doctorNameTopConstraint.constant = 16;
        self.doctorNameBottomConstraint.constant = 16;
        self.doctorNameLabel.attributedText = [self attributedStringForString:order.doctorName];
    }
    else
    {
        self.doctorIcon.hidden = YES;
        self.doctorTitleLabel.hidden = YES;
        self.doctorNameTopConstraint.constant = 0;
        self.doctorNameBottomConstraint.constant = 0;
        self.patientSeparatorView.hidden = YES;
        self.doctorNameLabel.text = @"";
    }
    if((order.patientName == nil || [order.patientName isEqualToString:@""]) && (order.doctorName == nil || [order.doctorName isEqualToString:@""]))
    {
        self.patientViewTopSeaparatorView.hidden = YES;
    }
    
   
    if(order.hasReoorderReminder)
    {
        self.reorderReminderDataContainerHeightConstraint.constant = IMReminderDataContainerViewHeight;
        self.reorderRemainderContainerHeightConstraint.constant = IMReminderContainerViewHeight;
        NSString* durationUnit = order.reorderReminder.unit;
    
        if([durationUnit isEqualToString:@"days"])
        {
            durationUnit = @"day";
        }
        else if([durationUnit isEqualToString:@"weeks"])
        {
            durationUnit = @"week";
        }
        else if([durationUnit isEqualToString:@"months"])
        {
            durationUnit = @"month";
        }
        
        if(order.reorderReminder.duration.integerValue > 1)
        {
            durationUnit = [durationUnit stringByAppendingString:@"s"];
        }
        
        self.frequencyStringLabel.text = [NSString stringWithFormat:@"After every %@ %@",order.reorderReminder.duration,durationUnit];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd MMMM YYYY";
        
        self.nextDateLabel.text = [NSString stringWithFormat:@"Next on %@",[dateFormatter stringFromDate:order.reorderReminder.date]];
    }
    else
    {
        self.reorderRemainderContainerHeightConstraint.constant = IMReminderSwitchContainerViewHeight;
        self.reorderReminderDataContainerHeightConstraint.constant = 0;
    }
    
    if(order.identifier)
    {
        self.title = [NSString stringWithFormat:@"Order %@",order.identifier];
    }
    else
    {
        self.title = @"Order";
    }
    
    self.orderedItemsTableView.dataSource = self;
    self.orderedItemsTableView.delegate = self;
    [self.orderedItemsTableView setNeedsLayout];
    [self.orderedItemsTableView layoutIfNeeded];
   [self.orderedItemsTableView reloadData];
    self.orderedDateAfterDeliveryLabel.text = [self formatDateWithDate:order.orderDate];
    self.deliveredDateLabel.text = [self formatDateWithDate:order.orderDate];
    self.stateDisplayNameCompleteLabel.text = order.stateDisplayName;
    self.stateDisplayNameProgressLabel.text = order.stateDisplayName;
    if([order.state isEqualToString:@"cancelled"] )
    {
        self.orderDateContainerHeightConstraint.constant = 0;
        self.deliveryProgressContainerHeightConstraint.constant = 0;
        self.deliveredDateContainerHeightConstraint.constant = 54;
    }
    else
    {
        self.orderedDateLabel.text = [self formatDateWithDate:order.orderDate];
        self.deliveredDateContainerHeightConstraint.constant = 0;
        self.stateDisplayNameCompleteLabel.hidden = NO;
        if([order.state isEqualToString:@"delivered"])
        {
            self.deliveredDateContainerHeightConstraint.constant = 54;
            self.orderDateContainerHeightConstraint.constant = 0;
            self.stateDisplayNameCompleteLabel.hidden = YES;
            self.deliveryProgressHeightConstraint.constant = 0;
            self.topToDeliveryProgressVConstraint.constant = 0;
            self.deliveryProgressContainerHeightConstraint.constant = 65;
        }
        
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                        fromDate:[NSDate date]];
        NSDate *currentDate = [[NSCalendar currentCalendar]
                             dateFromComponents:components];
        NSDate *slotDate  = order.deliverySlot.slotDate;
        if (slotDate)
        {
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:slotDate
                                                                  toDate:currentDate
                                                                 options:NSCalendarWrapComponents];
            NSString *dateString;
            
            if(components.day == 0)
            {
                dateString = @"Today";
            }
            else if (components.day == -1)
            {
                dateString = @"Tomorrow";
            }
            else
            {
                NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
                dateString = [dateFormatter2 stringFromDate:slotDate];
            }
            
            dateString = [NSString stringWithFormat:@"%@ %@",dateString, order.deliverySlot.slotDescription];
            self.etalLabel.text =  [NSString stringWithFormat:@"Delivered by: %@",dateString];
        }
    }
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %@",order.totalAmount];
    self.shippingChargesLabel.text = [NSString stringWithFormat:@"₹ %@",order.shippingCharges];
    [self setupDiscountPrice:order];
    self.deliveryAddressNameLabel.text = order.deliveryAddress.name;
    
    
    if(order.deliveryAddress.landmark)
    {
        self.deliveryAddressLabel.attributedText = [self attributedStringForString:  [NSString stringWithFormat:@"%@, %@, %@, %@ - %@",order.deliveryAddress.addressLine1,order.deliveryAddress.addressLine2,order.deliveryAddress.landmark, order.deliveryAddress.cityName,order.deliveryAddress.pinCode]];
    }
    else
    {
        self.deliveryAddressLabel.attributedText = [self attributedStringForString:  [NSString stringWithFormat:@"%@, %@, %@ - %@",order.deliveryAddress.addressLine1,order.deliveryAddress.addressLine2,order.deliveryAddress.cityName,order.deliveryAddress.pinCode]];
    }
    
    self.deliveryPhoneNumberLabel.text =  [NSString stringWithFormat:@"+91 %@",order.deliveryAddress.phoneNumber];
    self.drugLicenseNumberLabel.text = order.drugLicenceNumber;
    self.vatNumberLabel.text = order.vatNumber;
    self.orderedItemsTableViewHeightConstraint.constant = self.orderedItemsTableView.contentSize.height;
    
    if([order.state isEqualToString:@"complete"])
    {
        self.progressImageView.image = [UIImage imageNamed:@"processing"];
    }
    else if([order.state isEqualToString:@"delivered"])
    {
        self.progressImageView.image = [UIImage imageNamed:@"deliveryprogress"];
    }
    else if([order.state isEqualToString:@"shipped"] || [order.state isEqualToString:@"out_for_delivery"] || [order.state isEqualToString:@"undelivered"])
    {
        self.progressImageView.image = [UIImage imageNamed:@"shipped"];
    }
    else if([order.state isEqualToString:@"return_started"] || [order.state isEqualToString:@"return_completed"])
    {
        self.deliveryProgressContainerHeightConstraint.constant = 0;
    }
    if( [order.state isEqualToString:@"digitization_in_progress"] || [order.state isEqualToString:@"digitisation_mismatch"])
    {
        self.progressImageView.image = [UIImage imageNamed:@"approval"];
        self.deliveryProgressContainerHeightConstraint.constant = 100;
        self.imageViewHeightConstraint.constant = 44;
    }
    if([order.state isEqualToString:@"cancelled"])
    {
        self.cancelOrReturnOrderButtonHeightConstraint.constant = 0;
        self.cancelOrReorderButtonTopConstraint.constant = 0;
    }

    if([order.state isEqualToString:@"digitisation_mismatch"])
    {
        [self.reorderButton setTitle:IMUpdateOrderButtontitle forState:UIControlStateNormal];
    }
    else
    {
        //Button Enable/Disable
//        [self.reorderButton setTitle:@"Reorder" forState:UIControlStateNormal];

        if(!order.isReorderable)
        {
            self.reorderButton.enabled = NO;
        }
        else
        {
            [self.reorderButton setTitle:@"Reorder" forState:UIControlStateNormal];
            self.reorderButton.enabled = YES;
        }
    }
    if(order.isReturnable)
    {
        [self.cancelOrReturnOrderButton setTitle:@"Return this order" forState:UIControlStateNormal];
    }
    else if(order.isCancellable)
    {
        [self.cancelOrReturnOrderButton setTitle:@"Cancel this order" forState:UIControlStateNormal];
    }
    else
    {
        self.cancelOrReturnOrderButtonHeightConstraint.constant = 0;
        self.cancelOrReorderButtonTopConstraint.constant = 0;
    }
    
    [self.view layoutIfNeeded];
}


#pragma mark - TableView Data Source and Delgate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    IMOrder* order =  (IMOrder*)self.selectedModel;
    return order.orderedItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOrder* order =  (IMOrder*)self.selectedModel;

    IMOrderSummaryTableViewCell* cell = [self.orderedItemsTableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryCell" forIndexPath:indexPath];
    cell.model = order.orderedItems[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOrder* order =  (IMOrder*)self.selectedModel;
    IMLineItem *lineItem = order.orderedItems[indexPath.row];
    
    if(lineItem.isActive)
    {
        IMProduct *product = [[IMProduct alloc] init];
        product.identifier = lineItem.identifier;
        
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [IMFlurry logEvent:IMPDPFromOrderDetail withParameters:@{}];
        if(lineItem.isPharma)
        {
            IMPharmaDetailViewController* pharmaVC = [storyboard instantiateViewControllerWithIdentifier:IMPharmaDetailViewControllerID];
            pharmaVC.product = product;
            [self.navigationController pushViewController:pharmaVC animated:YES];
        }
        else
        {
            IMNonPharmaDetailViewController* pharmaVC = [storyboard instantiateViewControllerWithIdentifier:IMNonPharmaDetailViewControllerID];
            pharmaVC.selectedModel = product;
            [self.navigationController pushViewController:pharmaVC animated:YES];
        }
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:IMProductNotInCity];
    }
   
    
//    if(product.isPharma)
//    {
//        [self performSegueWithIdentifier:@"pharmaProductSegue" sender:product];
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"nonPharmaProductSegue" sender:product];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOrder* order =  (IMOrder*)self.selectedModel;
   
     self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.prototypeCell.bounds));
    
     self.prototypeCell.model = order.orderedItems[indexPath.row];
    
    [self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void)updateOrderPressed
{
    IMOrder* order =  (IMOrder*)self.selectedModel;
    order.isCompleteDetailPresent = YES;
    IMCart *cart = [IMCartUtility getCartFromOrder:order  forType:IMUpdateOrder];
    [self loadCartFor:cart order:order];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *viewController = nil;
    for (UIViewController *controller in viewControllers) {
        if ([controller isKindOfClass:[IMOrderListViewController class]]) {
            viewController = controller;
            break;
        }
    }
    if (viewController) {
        [IMCartManager sharedManager].orderInitiatedViewController = viewController;
    }
}

- (IBAction)reOrderPressed:(id)sender
{
    [IMFlurry logEvent:IMReorderfromDetailEvent withParameters:@{}];

    IMOrder* order =  (IMOrder*)self.selectedModel;
    if(order.doctorName && ![order.doctorName isEqualToString:@""])
    {
        [IMCartManager sharedManager].doctorName = order.doctorName;

    }
    if(order.patientName && ![order.patientName isEqualToString:@""])
    {
        [IMCartManager sharedManager].patientName = order.patientName;

    }
    // order revise
    if (order.isMismatched) {
        [self updateOrderPressed];
    }
    else{
        [self showActivityIndicatorView];
        
        [[IMCartManager sharedManager] reorderFromOrder:order withCompletion:^(NSError *error) {
            [self hideActivityIndicatorView];
            if(error)
            {
                if(error.userInfo[IMMessage])
                {
                    [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                }
                else
                {
                    [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
                }
            }
            else
            {
                [self loadCart:self];
            }
        }];
    }
}

-(void)showOrderReminder
{
    IMOrderReminderViewController* reminderViewController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"IMOrderReminderViewController"];
    reminderViewController.orderId = ((IMOrder*)self.selectedModel).identifier;
    reminderViewController.delegate = self;
    reminderViewController.view.frame = self.navigationController.view.bounds;
    [self.navigationController addChildViewController:reminderViewController];
    [self.navigationController.view addSubview:reminderViewController.view];
    [self didMoveToParentViewController:self.navigationController];
}

- (IBAction)reminderSwitchTapped:(UISwitch*)sender
{
    if(sender.isOn)
    {
        [self showOrderReminder];
    }
    else
    {
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] resetReminderWithOrderId:self.orderId withCompletion:^(NSError *error) {
            [self hideActivityIndicatorView];
            if(!error)
            {
                self.reorderReminderDataContainerHeightConstraint.constant =  0 ;
                self.reorderRemainderContainerHeightConstraint.constant = IMReminderSwitchContainerViewHeight;
                [self showAlertWithTitle:IMRemainderOff andMessage:IMRemainderHasbeenOff];
            }
            else
            {
                [sender setOn:YES animated:NO];
                [self handleError:error withRetryStatus:NO];
            }
        }];
        
        
    }
    
}

-(void)reminderController:(IMOrderReminderViewController*)reminderController didFinshWithFrequencyString:(NSString*)frequencyString nextDate:(NSString*)nextDate
{
    if(frequencyString)
    {

        self.frequencyStringLabel.text = frequencyString;
        self.nextDateLabel.text = nextDate;
        self.reorderReminderDataContainerHeightConstraint.constant = IMReminderDataContainerViewHeight;
        self.reorderRemainderContainerHeightConstraint.constant = IMReminderContainerViewHeight;
    }
    else
    {
        self.reorderSwitch.on = false;
          self.reorderRemainderContainerHeightConstraint.constant = IMReminderSwitchContainerViewHeight;
        self.reorderReminderDataContainerHeightConstraint.constant = 0;
    }
    [self.view layoutIfNeeded];
}

- (IBAction)editReminderTapped:(UIButton *)sender
{
    [self showOrderReminder];
}

- (IMOrderSummaryTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.orderedItemsTableView dequeueReusableCellWithIdentifier:@"IMOrderSummaryCell"];
    }
    return _prototypeCell;
}

- (NSInteger)numberOfDaysBetween:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeInterval duration = 0;
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&startDate interval:&duration forDate:endDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&endDate interval:&duration forDate:startDate];
    NSDateComponents *dateDifference = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:NSCalendarWrapComponents];
    return dateDifference.day;

}

-(NSString *)formatDateWithDate:(NSString *)date
{
    if(date)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        
        NSDate *formattedDate = [dateFormatter dateFromString:date];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
        NSString *newDateString = [dateFormatter2 stringFromDate:formattedDate];
        return newDateString;
    }
    return @"";

}



- (IBAction)cancelOrReorderButtonTapped:(UIButton *)sender
{
    
    IMOrder* order = (IMOrder*)self.selectedModel;

    if(order.isCancellable)
    {
        self.cancelOrReturnOrderButton.enabled = NO;

        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
        IMCancelReasonsViewController* cancelVC = [storyboard instantiateViewControllerWithIdentifier:@"IMCancelReasonController"];
        cancelVC.delegate = self;
        cancelVC.isOrderRefundable = [order isOrderRefundable];
        cancelVC.view.frame = self.navigationController.view.bounds;
        [self.navigationController addChildViewController:cancelVC];
        [self.navigationController.view addSubview:cancelVC.view];
        [self didMoveToParentViewController:self.navigationController];
        [IMFlurry logEvent:IMCancelOrder withParameters:@{}];

    }
    if(order.isReturnable)
    {
        [self showAlertWithTitle:IMreturnOrderText andMessage:IMForreturnPlsContact];
        [IMFlurry logEvent:IMReturnOrder withParameters:@{}];

    }
     
//    UIStoryboard *returnProductStoryboard = [UIStoryboard storyboardWithName:IMReturnProductsSBName bundle:nil];
//    IMReturnProductsListingViewController *returnProductsListingVC = [returnProductStoryboard instantiateViewControllerWithIdentifier:IMReturnProductsListingVCID];
//    [self.navigationController pushViewController:returnProductsListingVC animated:YES];
    

}

-(void)didFinishWithCanelReason:(IMCancelReason *)cancelReason
{
    
    [self.cancelReasonsController showActivityIndicatorView];
    [[IMAccountsManager sharedManager] cancelOrderWithId:self.orderId orderCanecelInfo:cancelReason completion:^(NSString *message, NSError *error) {
        
        self.cancelOrReturnOrderButton.enabled = YES;
        [self.cancelReasonsController hideActivityIndicatorView];
        if(!error && message)
        {
            [self.navigationController popToViewController:self animated:NO];
            [self showAlertWithTitle:IMCancellSuccess andMessage:message];
            //                self.cancelOrReturnOrderButtonHeightConstraint.constant = 0;
            //                self.cancelOrReorderButtonTopConstraint.constant = 0;
            [self downloadFeed];
            
            
        }
        else
        {
            [self handleError:error withRetryStatus:NO];
        }
        
    }];

}

-(void)didDismissCancelReason
{
    
    [self performSelector:@selector(enableCancelOrReturnOrderButton) withObject:nil afterDelay:1.0f];
}

-(void) enableCancelOrReturnOrderButton
{
    self.cancelOrReturnOrderButton.enabled = YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMCancelReasonsViewController"])
    {
          self.cancelReasonsController = (IMCancelReasonsViewController*)segue.destinationViewController;
       self.cancelReasonsController.delegate = self;
      
    }
}
/**
 @brief Hides discount title and price labels below the shipping charges field
 @param order: IMOrder*
 */
- (void) setupDiscountPrice: (IMOrder*) order
{
    if (order.promotionDiscountTotal && ![order.promotionDiscountTotal isEqualToString:@""] && ![order.promotionDiscountTotal isEqualToString:@"0.00"]) {
        self.discountPriceLabel.text = [NSString stringWithFormat:@"- ₹ %@",order.promotionDiscountTotal];
        self.discountPriceTitle.text = IMDiscountTitle;
    }
    else{
        [self hideDiscountControls];
    }
}
/**
 @brief Hides discount title and price labels below the shipping charges field
 */
- (void) hideDiscountControls
{
    self.discountPriceLabel.text = @"";
    self.discountPriceTitle.text = @"";
    self.discountPriceLabelHeightConstraint.constant = 0;
    self.discountPriceTopConstraint.constant = 0;
    self.discountPriceHeightConstraint.constant = 0;
}

@end
