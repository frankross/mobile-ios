//
//  IMDeliveryAddressViewController.m
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#define PATIENT_DETAIL_VIEW_HEIGHT 103
#import "IMDeliveryAddressViewController.h"
#import "IMDeliverySlotViewController.h"
#import "IMAddressListViewController.h"
#import "IMAccountsManager.h"
#import "IMOrderSummaryScreen.h"
#import "IMAddressAddEditViewController.h"
#import "IMCartUtility.h"

@interface IMDeliveryAddressViewController ()<IMDeliverySlotViewControllerDelegate,IMAddressListViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *delivertSlotTltleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSlotLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToDeliveryStoltVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSlotToDateVConsstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateToBottomVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliverToNameVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileToBottomVConstraint;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton *addressChangeButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)  UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *doctorNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *patientNameTxtField;
- (IBAction)patientDetailExpansionPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *patientDetailsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientDetailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientTitleViewHightCopnstraint;
@property (weak, nonatomic) IBOutlet UIButton *expansionButton;

@end

@implementation IMDeliveryAddressViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


/**
 @brief To setup initial UI elements
 @returns void
 */
-(void)loadUI
{
    
    [super setUpNavigationBar];
    
    self.delivertSlotTltleLabel.text = @"";
    self.topToDeliveryStoltVConstraint.constant = 5;
    self.timeSlotToDateVConsstraint.constant = 10;
    self.dateToBottomVConstraint.constant = 5;
    self.timeSlotLabel.textColor = APP_THEME_COLOR;
    [IMFunctionUtilities setBackgroundImage:self.proceedButton withImageColor:APP_THEME_COLOR];
 
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, self.doctorNameTxtField.frame.size.height)];
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:17];
    label.text = @"Dr.";
    self.doctorNameTxtField.leftView = label;
    self.doctorNameTxtField.leftViewMode = UITextFieldViewModeAlways;
    self.expansionButton.hidden = NO;
    //Make patient info nonEditable while update order flow
    if(!self.cart.isNewOrder)
    {
        self.patientNameTxtField.userInteractionEnabled = NO;
        self.doctorNameTxtField.userInteractionEnabled = NO;
    }
    else
    {
        self.patientNameTxtField.userInteractionEnabled = YES;
        self.doctorNameTxtField.userInteractionEnabled = YES;
    }
    if([self.cart.patientDetailRequired isEqualToString:@"mandatory"])
    {
        self.patientNameTxtField.placeholder = @"Patient name*";
        self.doctorNameTxtField.placeholder = @"Doctor name*";
        self.expansionButton.hidden = YES;
        self.patientTitleViewHightCopnstraint.constant = 52;
        self.patientDetailHeightConstraint.constant = PATIENT_DETAIL_VIEW_HEIGHT;
        self.expansionButton.transform = CGAffineTransformMakeRotation(M_PI);
        if(self.cart.patientName)
        {
            self.patientNameTxtField.text = self.cart.patientName;
        }
        else if([IMCartManager sharedManager].patientName)
        {
            self.patientNameTxtField.text = [IMCartManager sharedManager].patientName;
        }
        else
        {
            if([IMAccountsManager sharedManager].userName)
            {
                self.patientNameTxtField.text = [IMAccountsManager sharedManager].userName;
            }
        }
        if(self.cart.doctorName)
        {
            self.doctorNameTxtField.text = self.cart.doctorName;
        }
        else if([IMCartManager sharedManager].doctorName)
        {
            self.doctorNameTxtField.text = [IMCartManager sharedManager].doctorName;
        }
    }
    else if([self.cart.patientDetailRequired isEqualToString:@"optional"])
    {
        self.patientTitleViewHightCopnstraint.constant = 52;

        self.patientDetailHeightConstraint.constant = 0;
        self.expansionButton.transform = CGAffineTransformMakeRotation(0);
    }
    else
    {
        self.patientDetailHeightConstraint.constant = 0;
        self.expansionButton.transform = CGAffineTransformMakeRotation(0);
        self.patientTitleViewHightCopnstraint.constant = 0;
    }
    [self.view layoutIfNeeded];
    [self updateUI];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMDeliveryAddressScreenVisited withParameters:@{}];
   

    self.topView.hidden = YES;
    self.scrollView.hidden = YES;
    self.proceedButton.hidden = YES;
    //call download feed to here to refresh addresses every time
    [self downloadFeed];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

/**
 @brief To update ui after feed
 @returns void
 */
-(void)updateUI
{
    self.topView.hidden = NO;
    self.scrollView.hidden = NO;
    self.proceedButton.hidden = NO;
    if(self.cart.deliveryAddress)
    {
        self.nameLabel.text = [self.cart.deliveryAddress.name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.cart.deliveryAddress.name  substringToIndex:1] uppercaseString]];
        self.deliverToNameVConstraint.constant = 12;
        self.mobileToBottomVConstraint.constant = 12;
        NSString *labelText;
        if(self.cart.deliveryAddress.landmark)
        {
        
           labelText =  [NSString stringWithFormat:@"%@, %@, %@, %@ - %@",self.cart.deliveryAddress.addressLine1,self.cart.deliveryAddress.addressLine2, self.cart.deliveryAddress.landmark, self.cart.deliveryAddress.city.name,self.cart.deliveryAddress.pinCode] ;
            
        }
        else
        {
            labelText =  [NSString stringWithFormat:@"%@, %@, %@ - %@",self.cart.deliveryAddress.addressLine1,self.cart.deliveryAddress.addressLine2, self.cart.deliveryAddress.city.name,self.cart.deliveryAddress.pinCode];
            
        }
        labelText = [labelText stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[labelText  substringToIndex:1] uppercaseString]];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.addressLabel.attributedText = attributedString;
        
        self.phoneNumberLabel.text = [NSString stringWithFormat:@"+91 %@",self.cart.deliveryAddress.phoneNumber];
        
        [self.addressChangeButton setTitle:@"Change" forState:UIControlStateNormal];
    }
    else
    {
        [self.addressChangeButton setTitle:@"Add" forState:UIControlStateNormal];
        self.nameLabel.text = @"";
        self.deliverToNameVConstraint.constant = 0;
        self.mobileToBottomVConstraint.constant = 10;
        self.addressLabel.text = IMChoosedeliveryAddress;
        self.phoneNumberLabel.text = @"";
    }
    if(self.cart.deliveryAddress && self.cart.deliverySlot)
    {
        self.delivertSlotTltleLabel.text = IMdeliverySlot;
        self.topToDeliveryStoltVConstraint.constant = 20;
        self.timeSlotToDateVConsstraint.constant = 5;
        self.dateToBottomVConstraint.constant = 15;
        self.timeSlotLabel.font = [UIFont fontWithName:IMHelveticaMedium size:22];
        self.timeSlotLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
        
        self.timeSlotLabel.text = self.cart.deliverySlot.slotDescription;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEEE, dd MMM yyyy";
         self.dateLabel.text =  [dateFormatter stringFromDate:self.cart.deliverySlot.slotDate];
    }
    else
    {
        self.timeSlotLabel.textColor = APP_THEME_COLOR;
        self.timeSlotLabel.font = [UIFont fontWithName:IMHelveticaMedium size:18];
        self.timeSlotLabel.text = IMChooseDeliverySlot;
        self.dateLabel.text = @"";
        self.delivertSlotTltleLabel.text = @"";
        self.topToDeliveryStoltVConstraint.constant = 5;
        self.timeSlotToDateVConsstraint.constant = 10;
        self.dateToBottomVConstraint.constant = 5;

    }
    [self.view layoutIfNeeded];
    
}

/**
 @brief To validate cart delivery slot agint delivery slot list
 @returns void
 */

-(BOOL)validateCartDeleiverSlotFromDeliverySlots:(NSArray*)deliverySlots
{
    BOOL found = NO;
    
    for(IMDeliverySlot* deliverySlot in deliverySlots)
    {
        if([deliverySlot.identifier isEqual:self.cart.deliverySlot.identifier])
        {
            found = YES;
            break;
        }
    }
    
    return found;
}

/**
 @brief To downlod feeds
 @returns void
 */
-(void)downloadFeed
{
   
    if(self.cart.deliveryAddress)
    {
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] fetchAddressesWithCompletion:^(NSMutableArray *addresses, NSError *error) {
            [self hideActivityIndicatorView];
            if(!error)
            {
                BOOL isdeliveryAddressFound = NO;
                for(IMAddress* address in addresses)
                {
                    //TODO: Check for last set address , if no last set delivered address, then check for default.
                    
                    if(self.cart.deliveryAddress.identifier == address.identifier)
                    {
                        self.cart.deliveryAddress = address;
                        isdeliveryAddressFound = YES;
                        break;
                    }
                }
                if(!isdeliveryAddressFound)
                {
                    BOOL isDefaultAddressFound = NO;

                    for(IMAddress* address in addresses)
                    {
                        //TODO: Check for lastDelivered flag , if no last delivered address, then check for default.
                        
                        if(address.isDefault)
                        {
                            self.cart.deliveryAddress = address;
                            isDefaultAddressFound = YES;
                            break;
                        }
                    }
                    if(!isDefaultAddressFound)
                    {
                        if (addresses.count) {
                            self.cart.deliveryAddress = addresses[0];
                        }
                        else{
                            self.cart.deliveryAddress = nil;
                        }
                    }
                }
                 if (isdeliveryAddressFound || self.cart.deliveryAddress != nil)
                 {
                     [self getFullFillmentCenterID];
                 }
                else
                {
                     self.cart.deliverySlot = nil;
                    [self updateUI];
                    
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
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] fetchAddressesWithCompletion:^(NSMutableArray *addresses, NSError *error) {
            [self hideActivityIndicatorView];
            if(!error)
            {
                for(IMAddress* address in addresses)
                {
                    //TODO: Check for lastDelivered flag , if no last delivered address, then check for default.
                    
                    if(address.isLastDelivered)
                    {
                        self.cart.deliveryAddress = address;
                        break;
                    }
                }
                
                if(!self.cart.deliveryAddress)
                {
                    for(IMAddress* address in addresses)
                    {
                        //TODO: Check for lastDelivered flag , if no last delivered address, then check for default.
                        
                        if(address.isDefault)
                        {
                            self.cart.deliveryAddress = address;
                            break;
                        }
                    }
                }
                
                if(!self.cart.deliveryAddress)
                {
                    if(addresses.count)
                    {
                        self.cart.deliveryAddress = addresses[0];
                    }
                }
                
                // if delivery address foudn then only check for delivery slot.
                if (self.cart.deliveryAddress != nil)
                {
                    [self getFullFillmentCenterID];

                }
                else
                {
                    self.cart.deliverySlot = nil;
                    [self updateUI];
                }
            }
            
            
        }];
    }
}

/**
 @brief To get fullfillment centre ID after userselects delivery address.
 @returns void
 */
-(void) getFullFillmentCenterID
{
    [self showActivityIndicatorView];
    [[IMCartManager sharedManager] fetchFullfillmentCenterIDForCart:self.cart withCompletion:^(NSNumber *fulfillemntCenterID, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.cart.fulFillmentCenterID = fulfillemntCenterID;
            if(self.cart.deliverySlot)
            {
                [self fetchDeliverySlots];
            }
            else
            {
                [self updateUI];
            }
            
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
        
    }];
}


/**
 @brief To get delivery slots.
 @returns void
 */
-(void) fetchDeliverySlots
{
    [self showActivityIndicatorView];
    [[IMCartManager sharedManager] fetchDeliverySlotsForAreaId:self.cart.deliveryAddress.areaID withFullfillmentCenterID:self.cart.fulFillmentCenterID withPrescription:self.cart.isPrescriptionPresent withCompletion:^(NSMutableArray *deliverySlots, NSError *error)
    {
        [self hideActivityIndicatorView];
        if(! [self validateCartDeleiverSlotFromDeliverySlots:deliverySlots])
        {
            self.cart.deliverySlot = nil;
        }
        [self updateUI];
    }];

}

/**
 @brief delivery slot selection call back
 @returns void
 */
-(void)didSelectDeliverySlot:(IMDeliverySlot *)deliverySlot
{
    self.cart.deliverySlot = deliverySlot;
    [self updateUI];

    if([self.cart.patientDetailRequired isEqualToString:@"mandatory"] && (self.cart.isNewOrder))
    {
        if([self.patientNameTxtField.text isEqualToString:@""])
        {
            [self.patientNameTxtField becomeFirstResponder];
        }
        else if([self.doctorNameTxtField.text isEqualToString:@""])
        {
            [self.doctorNameTxtField becomeFirstResponder];
        }
    }
}

/**
 @brief delivery address selection call back
 @returns void
 */
-(void)didSelectAddress:(IMAddress *)address
{
    self.cart.deliveryAddress = address;
    self.cart.deliverySlot = nil;
    [self getFullFillmentCenterID];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 @brief To handle change address button action
 @returns void
 */
- (IBAction)changeDeliveryAddress:(id)sender
{
    if(self.cart.deliveryAddress)
    {
        IMAddressListViewController* addressListViewController =   [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"IMAddressListViewController"];
        
        addressListViewController.addressType = IMDeliveryAddressList;
        addressListViewController.delegate = self;
        [self.navigationController pushViewController:addressListViewController animated:YES];
    }
    else
    {
        IMAddressAddEditViewController* addressEditViewController =   [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"IMAddressAddEditViewController"];
        [self.navigationController pushViewController:addressEditViewController animated:YES];

    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"IMDeliverySlotSegue"])
    {
        ((IMDeliverySlotViewController*)segue.destinationViewController).deliveryAreaId = self.cart.deliveryAddress.areaID;
        ((IMDeliverySlotViewController*)segue.destinationViewController).fullfillmentCenterID = self.cart.fulFillmentCenterID;
       ((IMDeliverySlotViewController*)segue.destinationViewController).selectedModel = self.cart.deliverySlot;
        ((IMDeliverySlotViewController*)segue.destinationViewController).delegate = self;
        ((IMDeliverySlotViewController*)segue.destinationViewController).cart = self.cart;

    }
    else if([segue.identifier isEqualToString:@"IMOrderSummarySegue"])
    {
        ((IMOrderSummaryScreen*)segue.destinationViewController).cart = self.cart;
        ((IMOrderSummaryScreen*)segue.destinationViewController).order = self.order;

    }
}

/**
 @brief To handle proceed button action
 @returns void
 */
- (IBAction)proceedButtonPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    if(!self.cart.deliveryAddress)
    {
        [self showAlertWithTitle:@"" andMessage:IMPlsSelectADeliveryAddress];
    }
    else if(!self.cart.deliverySlot)
    {
        [self showAlertWithTitle:@"" andMessage:IMPlsSelectADeliverySlot];
        
    }
    else if([self.patientNameTxtField.text isEqualToString:@""] && [self.cart.patientDetailRequired isEqualToString:@"mandatory"] )
    {
        [self.patientNameTxtField becomeFirstResponder];
        [self showAlertWithTitle:@"" andMessage:@"Patient name is mandatory"];
    }
    else if([self.doctorNameTxtField.text isEqualToString:@""] && [self.cart.patientDetailRequired isEqualToString:@"mandatory"])
    {
        [self.doctorNameTxtField becomeFirstResponder];
        [self showAlertWithTitle:@"" andMessage:@"Doctor name is mandatory"];
    }
    else
    {
       if(self.cart.isNewOrder)
       {
           self.cart.patientName = self.patientNameTxtField.text;
           self.cart.doctorName = self.doctorNameTxtField.text;
    
       }

        [self performSegueWithIdentifier:@"IMOrderSummarySegue" sender:self];
    }
}

/**
 @brief To handle deliveryslot button action
 @returns void
 */
- (IBAction)deliverySlotPressed:(id)sender
{
    [self.view endEditing:YES];

    if(self.cart.deliveryAddress)
    {
        [self performSegueWithIdentifier:@"IMDeliverySlotSegue" sender:self];
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:IMPlsSelectADeliveryAddress];
    }
}


//keyboard show/hide handling
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    
    CGPoint tableViewBottomPoint = CGPointMake(0, CGRectGetMaxY([self.scrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [self.scrollView convertPoint:tableViewBottomPoint
                                                                  toView:keyWindow];
    
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    
    if (keyboardOverlappedSpaceHeight > 0)
    {
        //Added +10 for moving scroll view up to the separator
        UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(0, 0, keyboardOverlappedSpaceHeight + 10, 0);
        [self.scrollView setContentInset:tableViewInsets];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    
    [self.scrollView setContentInset:tableViewInsets];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if(self.activeField == self.patientNameTxtField || self.activeField == self.doctorNameTxtField)
    {
        return newLength <= PATIENT_DETAIL_CHARECTER_LIMIT;
    }
    else
    {
        return YES;
    }
}

/**
 @brief To handle patient detail expansion/collapse action
 @returns void
 */

- (IBAction)patientDetailExpansionPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.patientDetailHeightConstraint.constant == 0)
        {
            self.patientDetailsView.alpha = 1.0f;
            self.patientDetailHeightConstraint.constant = PATIENT_DETAIL_VIEW_HEIGHT;
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            self.patientDetailsView.alpha = 0.0f;
            self.patientDetailHeightConstraint.constant = 0;
            sender.transform = CGAffineTransformMakeRotation(0);
        }
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.view endEditing:YES];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
