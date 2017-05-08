//
//  IMRegistrationViewController.m
//  InstaMed
//
//  Created by Arjuna on 28/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMRegistrationViewController.h"
#import "IMFacebookManager.h"
#import "NSString+Validations.h"
#import "IMAccountsManager.h"
#import "IMOTPVerificationControllerViewController.h"

@interface IMRegistrationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)  UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *agreeToTermsButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;

@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordFieldSeparatorViewHeightConstraint;

@end

@implementation IMRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.registrationType == IMRegistrationUsingSocialChannel)
    {
        self.passwordTextFieldTopConstraint.constant = 0;
        self.passwordTextFieldHeightConstraint.constant = 0;
        self.passwordTextFieldBottomConstraint.constant = 0;
        self.passwordFieldSeparatorViewHeightConstraint.constant = 0;
        
        self.nameTextField.text = self.user.name;
        self.nameTextField.enabled = NO;
        if(self.user.emailAddress)
        {
            self.emailAddressTextField.text = self.user.emailAddress;
            self.emailAddressTextField.enabled = NO;
        }
        
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMTimeSpendInRegistration withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMRegisterScreenVisited withParameters:@{}];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)loadUI
{
    [self setUpNavigationBar];

//    self.agreeToTermsButton.layer.borderColor = [UIColor blackColor].CGColor;
//    self.agreeToTermsButton.layer.borderWidth = 2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.mobileNumberTextField.frame.size.height)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"+91";
    self.mobileNumberTextField.leftView = label;
    self.mobileNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = IMCancel;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMTimeSpendInRegistration withParameters:@{}];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

// mobile number field should accept only numbers and 10 digits
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (self.activeField == self.mobileNumberTextField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_CHARACTER_LIMIT));
    }
    else if(self.activeField == self.emailAddressTextField)
    {
        return newLength <= EMAIL_CHARACTER_LIMIT;
    }
    else if(self.activeField == self.nameTextField)
    {
        return newLength <= USER_NAME_CHARACTER_LIMIT;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  - Actions -

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeToTermsAndCondtionsPressed:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

/**
 @brief To handle next button action
 @returns void
 */
- (IBAction)nextPressed:(UIButton*)sender
{
    [IMFlurry logEvent:IMRegistrationNextTapped withParameters:@{}];

    if(self.nameTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMNameEmptyAlertTitle message:IMNameEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMNameEmptyAlertTitle andMessage:IMNameEmptyAlertMessage];
        [self.nameTextField becomeFirstResponder];
    }
    else if (self.emailAddressTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMEmailAddressEmptyAlertTitle message:IMEmailAddressEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMEmailAddressEmptyAlertTitle andMessage:IMEmailAddressEmptyAlertMessage];
        [self.emailAddressTextField becomeFirstResponder];
    }
    else if([self.emailAddressTextField.text isEmailAddress] == NO)
    {
        //[[[UIAlertView alloc] initWithTitle:IMEmailAddressInvalidAlertTitle message:IMEmailAddressInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMEmailAddressInvalidAlertTitle andMessage:IMEmailAddressInvalidAlertMessage];
        [self.emailAddressTextField becomeFirstResponder];

    }
    else if(self.passwordTextField.text.length == 0 && self.registrationType == IMDirectRegistration)
    {
        //[[[UIAlertView alloc] initWithTitle:IMPasswordEmptyAlertTitle message:IMPasswordEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMPasswordEmptyAlertTitle andMessage:IMPasswordEmptyAlertMessage];
        [self.passwordTextField becomeFirstResponder];

    }
    else if([self.passwordTextField.text isPassword] == NO && self.registrationType == IMDirectRegistration)
    {
        //[[[UIAlertView alloc] initWithTitle:IMPasswordInvalidAlertTitle message:IMPasswordInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMPasswordInvalidAlertTitle andMessage:IMPasswordInvalidAlertMessage];
        [self.passwordTextField becomeFirstResponder];
    }
    else if(self.mobileNumberTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberEmptyAlertTitle message:IMMobileNumberEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberEmptyAlertTitle andMessage:IMMobileNumberEmptyAlertMessage];
        [self.mobileNumberTextField becomeFirstResponder];

    }
    else if( [self.mobileNumberTextField.text isPhoneNumber] == NO)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberInvalidAlertTitle message:IMMobileNumberInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberInvalidAlertTitle andMessage:IMMobileNumberInvalidAlertMessage];
        [self.mobileNumberTextField becomeFirstResponder];

    }
    else if(!self.agreeToTermsButton.selected)
    {
        //[[[UIAlertView alloc] initWithTitle:IMTermsNotAgreedAlertTitle message:IMMTermsNotAgreedAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMTermsNotAgreedAlertTitle andMessage:IMMTermsNotAgreedAlertMessage];
        [self.view endEditing:YES ];
    }
    else
    {
        if(self.registrationType == IMDirectRegistration)
        {
            [self performUserRegisteration];
        }
        else if(self.registrationType == IMRegistrationUsingSocialChannel)
        {
            [self performUserRegisterationForSocialLoggedInUser];
        }
        
        
    }
}

-(void) performUserRegisteration
{
    IMUser* user = [[IMUser alloc] init];
    user.name = self.nameTextField.text;
    user.emailAddress = self.emailAddressTextField.text;
    user.password = self.passwordTextField.text;
    user.mobileNumber = self.mobileNumberTextField.text;
    
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] registerUser:user withCompletion:^(NSDictionary *responseDictionary,NSError *error)
     {
         [self hideActivityIndicatorView];
         
         if(error == nil)
         {
             [IMFlurry logEvent:IMDirectRegistrationEvent withParameters:@{}];
             [[IMFacebookManager sharedManager] logFacebookRegisterEventWithRegistrationMethod:IMFrankrossRegistrationMethod];
             if(NO == [responseDictionary[@"otp_verified"] boolValue])
             {
                 [self performSegueWithIdentifier:@"IMOTPSegue" sender:self];
             }
             
         }
         else
         {
             
             if(error.userInfo[IMMessage] && [error.userInfo[@"otp_verified"] boolValue])
             {
                 
                 UIAlertController *alertController = [UIAlertController
                                                       alertControllerWithTitle:@""
                                                       message:error.userInfo[IMMessage]
                                                       preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *cancelAction = [UIAlertAction
                                                actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action)
                                                {
                                                    
                                                }];
                 UIAlertAction *signInAction = [UIAlertAction
                                                actionWithTitle:@"Sign in"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action)
                                                {
                                                    [self perFormSignIn];
                                                }];
                 
                 
                 [alertController addAction:cancelAction];
                 [alertController addAction:signInAction];
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             }
             
             else if(error.userInfo[IMMessage])
             {
                 
                 [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                 
             }
             else
             {
                 [self showAlertWithTitle:@"" andMessage:IMNoNetworkErrorMessage];
             }
         }
         
     }];
}

-(void) performUserRegisterationForSocialLoggedInUser
{
    IMUser* user = [[IMUser alloc] init];
    user.name = self.nameTextField.text;
    user.emailAddress = self.emailAddressTextField.text;
    user.mobileNumber = self.mobileNumberTextField.text;
    user.loginType = self.user.loginType;
    user.SocialLoginUserID = self.user.SocialLoginUserID;
    user.SocialAuthToken = self.user.SocialAuthToken;
    
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] registerSocialChannelLoggedUser:user withCompletion:^(NSDictionary *responseDict, NSError *error) {
        
        
        [self hideActivityIndicatorView];
        
        if(error == nil)
        {
            NSString *registrationMethod;
            if(user.loginType == IMLoginTypeFacebook)
            {
                registrationMethod = IMFacebookRegistrationMethod;
                [IMFlurry logEvent:IMFacebookRegisterSuccess withParameters:@{}];
            }
            else if(user.loginType == IMLoginTypeGoogle)
            {
                 registrationMethod = IMGoogleRegistrationMethod;
                [IMFlurry logEvent:IMGoogleRegisterSuccess withParameters:@{}];
            }
            [[IMFacebookManager sharedManager] logFacebookRegisterEventWithRegistrationMethod:registrationMethod];

            
            if(NO == [responseDict[@"otp_verified"] boolValue])
            {
                [self performSegueWithIdentifier:@"IMOTPSegue" sender:self];
            }
            
        }
        else
        {
            if(error.userInfo[IMMessage])
            {
                
                [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                
            }
            else
            {
                [self showAlertWithTitle:@"" andMessage:IMNoNetworkErrorMessage];
            }
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMOTPSegue"])
    {
        IMOTPVerificationControllerViewController* otpVC = segue.destinationViewController;
        
        otpVC.emailId = self.emailAddressTextField.text;
        otpVC.phoneNumber = self.mobileNumberTextField.text;
        otpVC.password = self.passwordTextField.text;
        otpVC.screenType = IMForDirectRegistraion;
        otpVC.completionBlock = self.completionBlock;
        otpVC.registrationType = self.registrationType;
        otpVC.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"SegueToOTPForSocialLogin"])
    {
        IMOTPVerificationControllerViewController* otpVC = segue.destinationViewController;
        IMUser *user = (IMUser *)sender;
        otpVC.phoneNumber = user.mobileNumber;
        otpVC.screenType = IMForLogin;
        otpVC.registrationType = IMRegistrationUsingSocialChannel;
        otpVC.user = user;
        otpVC.completionBlock = self.completionBlock;
    }
}

/**
 @brief To handle cancel button action
 @returns void
 */
- (IBAction)cancelButtonTapped:(id)sender {
//     [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) perFormSignIn
{
    if(self.registrationType == IMDirectRegistration)
    {
    
        IMUser* user = [[IMUser alloc] init];
        user.mobileNumber = self.mobileNumberTextField.text;
        user.password = self.passwordTextField.text;
        [self showActivityIndicatorView];
        self.view.userInteractionEnabled = NO;
        [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error) {
            
            [self hideActivityIndicatorView];
            self.view.userInteractionEnabled = YES;
            
            if(error == nil)
            {
     
                [IMFlurry setUserID:user.mobileNumber];
                
                
                if(self.completionBlock)
                {
                    self.completionBlock(error);
                }
            }
            else
            {
                if(error.code == 403)
                {
                    [self performSegueWithIdentifier:@"IMOTPSegue" sender:self];
                }
                else if(error.userInfo[IMMessage])
                {
                    [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                }
                else
                    [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
            }
            
        }];
    }
    else if(self.registrationType == IMRegistrationUsingSocialChannel)
    {
        __block IMUser* user = [[IMUser alloc] init];
        user.SocialLoginUserID = self.user.SocialLoginUserID;
        user.SocialAuthToken = self.user.SocialAuthToken;
        user.emailAddress = self.user.emailAddress;
        user.name = self.user.name;
        user.loginType = self.user.loginType;
        [self showActivityIndicatorView];
        self.view.userInteractionEnabled = NO;
        [[IMAccountsManager sharedManager] logInSocialUserWithUser:user withCompletion:^(NSError *error) {
            [self hideActivityIndicatorView];
            self.view.userInteractionEnabled = YES;
            if(error == nil)
            {
                
                
                if(self.completionBlock)
                {
                    self.completionBlock(error);
                }
            }
            else
            {
                if(error.code == 403 && [(NSString *)error.userInfo[@"error_code"] isEqualToString:@"EFR:Err:Login:UNVERIFIED_PHONE"])
                {
                    //[self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                    user.mobileNumber = error.userInfo[@"phone_number"];
                    [self performSegueWithIdentifier:@"SegueToOTPForSocialLogin" sender:user];
                }
                else if(error.userInfo[IMMessage])
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

}

@end
