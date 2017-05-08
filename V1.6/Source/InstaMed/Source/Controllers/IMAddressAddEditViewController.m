//
//  IMAddressAddEditViewController.m
//  InstaMed
//
//  Created by Suhail K on 19/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAddressAddEditViewController.h"
#import "NSString+Validations.h"
#import "IMAccountsManager.h"
#import "IMLocationManager.h"

@interface IMAddressAddEditViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)  UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *address1TxtField;
@property (weak, nonatomic) IBOutlet UITextField *address2TxtField;
@property (weak, nonatomic) IBOutlet UITextField *landmarkTxtField;

@property (weak, nonatomic) IBOutlet UITextField *pincodeTxtField;

@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTxtField;

@property (weak, nonatomic) IBOutlet UITextField *tagTxtField;
@property (nonatomic, strong) NSMutableArray *cityList;

- (IBAction)tagPressed:(id)sender;
- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@end

@implementation IMAddressAddEditViewController

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
    if(self.selectedModel)
    {
        //edit
    }
    else
    {
        [IMFlurry logEvent:IMAddAddressVisited withParameters:@{}];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadUI
{
    [self setUpNavigationBar];

    self.cityTxtField.text = [IMLocationManager sharedManager].currentLocation.name;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    if(self.selectedModel) //Editing
    {
      [self updateUI];
       self.title = IMEditAddress;
    }
    else
    {
        self.phoneNumberTxtField.text = [IMAccountsManager sharedManager].currentLoggedInUser.mobileNumber;
        self.nameTxtField.text = [IMAccountsManager sharedManager].currentLoggedInUser.name;
        self.title = IMAddAddress;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.phoneNumberTxtField.frame.size.height)];
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"+91";
    self.phoneNumberTxtField.leftView = label;
    self.phoneNumberTxtField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = IMCancel;
    [self downloadFeed];
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMLocationManager sharedManager] fetchDeliverySupportedLocationsWithCompletion:^(NSArray *deliveryLocations,IMCity* currentCity, NSError *error) {
        if(!error)
        {
            [self hideActivityIndicatorView];
            self.cityList = [deliveryLocations mutableCopy];
        }
        else
        {
            if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost)
            {
                [self showErrorPanelWithMessage:IMNoNetworkErrorMessage showRetryButton:YES];
            }
        }
    }];
}

/**
 @brief To update UI after downloding feed
 @returns void
 */
- (void)updateUI
{
    IMAddress* address = (IMAddress*)self.selectedModel;
    self.nameTxtField.text = address.name;
    self.address1TxtField.text = address.addressLine1;
    self.address2TxtField.text = address.addressLine2;
    self.landmarkTxtField.text = address.landmark;
    self.pincodeTxtField.text = [NSString stringWithFormat:@"%@",address.pinCode];
    if(address.city.name)
    {
        self.cityTxtField.text = address.city.name;
    }
    NSString *mobNum =  [((NSString *)address.phoneNumber) stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    self.phoneNumberTxtField.text = mobNum;

    self.tagTxtField.text = [address.tag capitalizedString];
}

#pragma mark  - Textfield Delegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    
    if (self.activeField == self.phoneNumberTxtField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_CHARACTER_LIMIT));
    }
    else if(self.activeField == self.address1TxtField)
    {
        return newLength <= ADDRESS_ONE_CHARACTER_LIMIT;
    }
    else if(self.activeField == self.address2TxtField)
    {
        return newLength <= ADDRESS_TWO_CHARACTER_LIMIT;
    }
    else
    {
        return YES;
    }
}


#pragma mark  - Keyboard Handling Methods -

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

/**
 @brief To handle edit button action
 @returns void
 */
- (IBAction)tagPressed:(id)sender
{
    if(IS_IOS8_OR_ABOVE)
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Home" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.tagTxtField.text = @"Home";
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Office" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.tagTxtField.text = @"Office";
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"None" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.tagTxtField.text = @"";
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:IMCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        alert.view.tintColor = APP_THEME_COLOR;
        [self presentViewController:alert animated:YES completion:nil];
        alert.view.tintColor = APP_THEME_COLOR;
    }
    else
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:IMCancel destructiveButtonTitle:nil otherButtonTitles:@"Home",@"Office",@"None", nil];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
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

#pragma mark - Action sheet delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            self.tagTxtField.text = @"Home";
            break;
        case 1:
            self.tagTxtField.text = @"Office";
            break;
        case 2:
            self.tagTxtField.text = @"";
            break;
        default:
            break;
    }
}

/**
 @brief To handle done button action
 @returns void
 */
- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    if(self.nameTxtField.text.length == 0)
    {
        [self showAlertWithTitle:IMNameEmptyAlertTitle andMessage:IMNameEmptyAlertMessage];
        [self.nameTxtField becomeFirstResponder];
    }
    else if (self.address1TxtField.text.length == 0)
    {

        [self showAlertWithTitle:@"Address" andMessage:IMPlsFillAddress1];
        [self.address1TxtField becomeFirstResponder];
    }
    else if (self.address2TxtField.text.length == 0)
    {

        [self showAlertWithTitle:@"Address" andMessage:IMPlsFillAddress2];
        [self.address2TxtField becomeFirstResponder];
    }
    else if(self.pincodeTxtField.text.length == 0)
    {

        [self showAlertWithTitle:@"Pincode" andMessage:IMPlsFillPincode];
        [self.pincodeTxtField becomeFirstResponder];
    }
    else if([self.pincodeTxtField.text isValidPinCode] == NO)
    {

        [self showAlertWithTitle:@"Pincode" andMessage:IMInvalidPincode];
        [self.pincodeTxtField becomeFirstResponder];
        
    }
    else if ([self areaForPincode:[NSNumber numberWithInt:[self.pincodeTxtField.text floatValue]]] == nil)
    {

        [self showAlertWithTitle:@"Pincode" andMessage:IMUnSupportedArea];
        [self.pincodeTxtField becomeFirstResponder];
    }
    else if(self.cityTxtField.text.length == 0)
    {

        [self showAlertWithTitle:@"City" andMessage:IMPlsFillCityField];

        [self.pincodeTxtField becomeFirstResponder];
    }
    else if([self.phoneNumberTxtField.text isPhoneNumber] == NO)
    {
        [self showAlertWithTitle:@"Phone Number" andMessage:IMInvalidPhoneNumber];

        [self.phoneNumberTxtField becomeFirstResponder];
    }
    else
    {
        IMAddress *addressModel = [[IMAddress alloc] init];
        addressModel.name = self.nameTxtField.text;
        addressModel.addressLine1 = self.address1TxtField.text;
        addressModel.addressLine2 = self.address2TxtField.text;
        addressModel.landmark = self.landmarkTxtField.text;
        addressModel.pinCode = [NSNumber numberWithInt:[self.pincodeTxtField.text floatValue]];
        IMCity *city = [[IMCity alloc] init];
        city.identifier = [IMLocationManager sharedManager].currentLocation.identifier;
        addressModel.city = city;
        addressModel.areaID = [self areaForPincode:[NSNumber numberWithInt:[self.pincodeTxtField.text floatValue]]];
        addressModel.phoneNumber = self.phoneNumberTxtField.text;
        addressModel.tag = [self.tagTxtField.text lowercaseString];
        if(self.selectedModel)
        {
            [IMFlurry logEvent:IMEditAddressEvent withParameters:@{}];

            addressModel.identifier = self.selectedModel.identifier;
            [self showActivityIndicatorView];
            
            [[IMAccountsManager sharedManager] updateAddress:addressModel withCompletion:^(NSError *error) {
                [self hideActivityIndicatorView];
                if(!error)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if(error.userInfo[IMMessage])
                    {
                        [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                    }
                    else
                    {
                        if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost)
                        {
                            [self showErrorPanelWithMessage:IMNoNetworkErrorMessage showRetryButton:YES];
                        }
                    }
                }
            }];
        }
        else
        {
            [IMFlurry logEvent:IMAddAddressEvent withParameters:@{}];

            [self showActivityIndicatorView];
            
            [[IMAccountsManager sharedManager] addAddress:addressModel withCompletion:^(NSError *error) {
                 [self hideActivityIndicatorView];
                if(!error)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if(error.userInfo[IMMessage])
                    {
                        [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                    }
                    else
                    {
                        if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost)
                        {
                            [self showErrorPanelWithMessage:IMNoNetworkErrorMessage showRetryButton:YES];
                        }
                    }
                }
            }];
        }
    }
  }

/**
 @brief To get area Id from pincode
 @returns void
 */
- (NSNumber *)areaForPincode:(NSNumber *)pincode
{
    NSNumber *areaID = nil;
    for (IMCity *city in self.cityList)
    {
        if([city.identifier isEqual:[IMLocationManager sharedManager].currentLocation.identifier])
        {
            NSArray *areas = city.areas;
            for (IMArea *area in areas)
            {
                if([area.pinCode isEqual:pincode])
                {
                    areaID = area.identifier;
                    break;
                }
            }
            if(areaID)
                break;
        }
    }
    return areaID;

}

/**
 @brief To handle cancel button action 
 @returns void
 */
- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
