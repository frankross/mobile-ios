//
//  IMAccountEditViewController.m
//  InstaMed
//
//  Created by Suhail K on 19/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAccountEditViewController.h"
#import "NSString+Validations.h"
#import "IMUser.h"
#import "IMAccountsManager.h"
#import "IMConstants.h"
#import "IMOTPVerificationControllerViewController.h"

@interface IMAccountEditViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
- (IBAction)passwordPressed:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic)  UITextField *activeField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordPanelHeightContraint;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phonNumberTxtField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *passwordNewTxtField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isMobileumberChanged;
@property (nonatomic, assign) BOOL isNameChanged;

- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonepasswordTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonePasswordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonePasswordBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *phonePasswordBottomView;
@property (weak, nonatomic) IBOutlet UITextField *phonePasswordTextField;
@property (nonatomic,strong)NSString *password;
@end

@implementation IMAccountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordPanelHeightContraint.constant = 0;
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 @brief To handle initail ui
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.phonNumberTxtField.frame.size.height)];
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"+91";
    self.phonNumberTxtField.leftView = label;
    self.phonNumberTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = IMCancel;
    [self HideAndShowPhonePasswordfeieldWithStatus:NO];
    [self updateUI];
}

- (void)HideAndShowPhonePasswordfeieldWithStatus:(BOOL)status
{
    if(!status)
    {
        self.phonePasswordBottomConstraint.constant = 0;
        self.phonePasswordHeightConstraint.constant = 0;
        self.phonepasswordTopConstraint.constant= 0;
        self.phonePasswordBottomView.hidden = YES;
    }
    else
    {
        self.phonePasswordBottomConstraint.constant = 5;
        self.phonePasswordHeightConstraint.constant = 30;
        self.phonepasswordTopConstraint.constant= 34;
        self.phonePasswordBottomView.hidden = NO;
    }
    [self.view layoutIfNeeded];
}

/**
 @brief To update ui after feed
 @returns void
 */
- (void)updateUI
{
    IMUser *user = (IMUser *) self.selectedModel;
    self.nameTxtField.text = user.name;
    if(user.emailAddress)
    {
        self.emailTxtField.text = user.emailAddress;
        self.emailHeightConstraint.constant = 70;
    }
    else
    {
        self.emailTxtField.text = @"";
        self.emailHeightConstraint.constant = 0;

    }

    NSString *mobNum =  [((NSString *)user.mobileNumber) stringByReplacingOccurrencesOfString:@"+91" withString:@""];
    self.phonNumberTxtField.text = mobNum;
//    self.passwordTextField.text = user.password;
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
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
//    if (self.activeField == self.phonNumberTxtField) {
//        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_CHARACTER_LIMIT));
//    }
//    else{
//        return YES;
//    }
//}

//field text limit
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (self.activeField == self.phonNumberTxtField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_CHARACTER_LIMIT));
    }
    else if(self.activeField == self.nameTxtField)
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

- (IBAction)passwordPressed:(UITapGestureRecognizer *)sender
{
    if (self.passwordPanelHeightContraint.constant == 0)
    {
        self.passwordPanelHeightContraint.constant = 152;
    }
    else
    {
        self.passwordPanelHeightContraint.constant = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//- (IBAction)donePressed:(UIBarButtonItem *)sender
//{
//    if([self.phonNumberTxtField.text isPhoneNumber] == NO)
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:IMInvalidPhoneNumber delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//        [self.phonNumberTxtField becomeFirstResponder];
//    }
//    else
//    {
//        if([((IMUser *)self.selectedModel).mobileNumber isEqualToString:self.phonNumberTxtField.text])
//        {
//            self.isMobileumberChanged = NO;
//        }
//        else
//        {
//            self.isMobileumberChanged = YES;
//        }
//
//        if([((IMUser *)self.selectedModel).name isEqualToString:self.nameTxtField.text])
//        {
//            self.isNameChanged = NO;
//        }
//        else
//        {
//            self.isNameChanged = YES;
//        }
//        //If any user details changed ask for password
//        if(self.isMobileumberChanged || self.isNameChanged)
//        {
//            if([self.phonePasswordTextField.text isEqualToString:@""])
//            {
////                [[[UIAlertView alloc] initWithTitle:IMPasswordRequiredtitle message:IMPasswordRequiredMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//////                [self HideAndShowPhonePasswordfeieldWithStatus:YES];
////                [self.phonePasswordTextField becomeFirstResponder];
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password required"
////                                                                message:@"Please enter your password"
////                                                               delegate:self
////                                                      cancelButtonTitle:IMCancel
////                                                      otherButtonTitles:@"Submit", nil];
////                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
////                UITextField *password = [alert textFieldAtIndex:0];
////                password.secureTextEntry = YES;
//
////                [alert show];
//            }
//            else
//            {
//                IMUser* user = [[IMUser alloc] init];
//                user.isThroughMail = NO;
//                user.mobileNumber = ((IMUser *)self.selectedModel).mobileNumber;
//                user.password = self.phonePasswordTextField.text;
//                
//                [self showActivityIndicatorView];
//                self.view.userInteractionEnabled = NO;
//                
//                //Check with login API for user authentication
//                [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error) {
//                    [self hideActivityIndicatorView];
//                    self.view.userInteractionEnabled = YES;
//                    //if login success update user info.
//                    if(error == nil)
//                    {
//                        IMUser* user = (IMUser*)self.selectedModel;
//                        user.name = self.nameTxtField.text;
//                        user.mobileNumber = self.phonNumberTxtField.text;
//
//                        [self showActivityIndicatorView];
//
//                        [[IMAccountsManager sharedManager] updateUser:(IMUser*)self.selectedModel withCompletion:^(NSError *error)
//                        {
//                            [self hideActivityIndicatorView];
//                            if(error)
//                            {
//                                [self handleError:error withRetryStatus:YES];
//                            }
//                            else
//                            {
//                                //if phone number changes push to otp screen.
//                                if(self.isMobileumberChanged)
//                                {
//                                    [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
//                                }
//                                else
//                                {
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                }
//                            }
//                        }];
//                    }
//                    else
//                    {
//                       if(error.userInfo[IMMessage])
//                        {
//                            [self showAlertWithTitle:IMError andMessage:[error.userInfo valueForKey:IMMessage]];
//                        }
//                        else
//                        {
//                            [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
//                        }
//                    }
//                }];
//            }
//        }
//        else //No change in user details, simply pop back
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

//- (IBAction)donePressed:(UIBarButtonItem *)sender
//{
// 
//    if([self.phonNumberTxtField.text isPhoneNumber] == NO)
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:IMInvalidPhoneNumber delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//        [self.phonNumberTxtField becomeFirstResponder];
//    }
//    else
//    {
//        if([((IMUser *)self.selectedModel).mobileNumber isEqualToString:self.phonNumberTxtField.text])
//        {
//            self.isMobileumberChanged = NO;
//        }
//        else
//        {
//            self.isMobileumberChanged = YES;
//        }
//        IMUser* user = (IMUser*)self.selectedModel;
//        user.name = self.nameTxtField.text;
//        user.mobileNumber = self.phonNumberTxtField.text;
//        
//        [self showActivityIndicatorView];
//        
//        [[IMAccountsManager sharedManager] updateUser:(IMUser*)self.selectedModel withCompletion:^(NSError *error) {
//            [self hideActivityIndicatorView];
//            if(error)
//            {
//                [self handleError:error withRetryStatus:YES];
//            }
//            else
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }];
//    }
//    
//    
//}

//- (IBAction)donePressed:(UIBarButtonItem *)sender
//{
//
//    if([self.phonNumberTxtField.text isPhoneNumber] == NO)
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:IMInvalidPhoneNumber delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//        [self.phonNumberTxtField becomeFirstResponder];
//    }
//    else
//    {
//        if([((IMUser *)self.selectedModel).mobileNumber isEqualToString:self.phonNumberTxtField.text])
//        {
//            self.isMobileumberChanged = NO;
//        }
//        else
//        {
//            self.isMobileumberChanged = YES;
//        }
//        
//        if([((IMUser *)self.selectedModel).name isEqualToString:self.nameTxtField.text])
//        {
//            self.isNameChanged = NO;
//        }
//        else
//        {
//            self.isNameChanged = YES;
//        }
//        
//        if(self.isMobileumberChanged)
//        {
//            if([self.phonePasswordTextField.text isEqualToString:@""])
//            {
//                 [[[UIAlertView alloc] initWithTitle:@"Password required" message:@"Please enter your current password." delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//                [self HideAndShowPhonePasswordfeieldWithStatus:YES];
//                [self.phonePasswordTextField becomeFirstResponder];
//            }
//            else
//            {
//                if(self.isNameChanged)
//                {
//                    IMUser* user = (IMUser*)self.selectedModel;
//                    user.name = self.nameTxtField.text;
//                    user.mobileNumber = ((IMUser *)self.selectedModel).mobileNumber;//self.phonNumberTxtField.text;
//                    [self showActivityIndicatorView];
//                    [[IMAccountsManager sharedManager] updateUser:(IMUser*)self.selectedModel withCompletion:^(NSError *error) {
//                        [self hideActivityIndicatorView];
//                        if(error)
//                        {
//                            [self handleError:error withRetryStatus:YES];
//                        }
//                        else
//                        {
//                            //Update mobile number here
//                            //Register new number
//                            //Create OTP
//                            //Push to OTP screen.
//                            NSString *password = self.phonePasswordTextField.text;
//                            NSString *email = self.emailTxtField.text;
//                            [[IMAccountsManager sharedManager] updatePhoneNumber:self.phonNumberTxtField.text withEmail:email andPassword:password withCompletion:^(NSError *error) {
//                                if(!error)
//                                {
//                                    [[IMAccountsManager sharedManager] generateOTPForPhoneNumber:self.phonNumberTxtField.text withCompletion:^(BOOL success, NSString *message) {
//                                        self.view.userInteractionEnabled = YES;
//                                        if (success)
//                                        {
//                                            [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
//                                        }
//                                        else
//                                        {
//                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMError message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil];
//                                            [alert show];
//                                        }
//                                    }];
//                                    
//                                }
//                                else
//                                {
//                                    [self handleError:error withRetryStatus:YES];
//                                }
//                            }];
//                        }
//                    }];
//                }
//                else
//                {
//                    //Update mobile number here
//                    //Register new number
//                    //Create OTP
//                    //Push to OTP screen.
//                    
//                    NSString *password = self.phonePasswordTextField.text;
//                    NSString *email = self.emailTxtField.text;
//                    [[IMAccountsManager sharedManager] updatePhoneNumber:self.phonNumberTxtField.text withEmail:email andPassword:password withCompletion:^(NSError *error) {
//                        if(!error)
//                        {
//                            [[IMAccountsManager sharedManager] generateOTPForPhoneNumber:self.phonNumberTxtField.text withCompletion:^(BOOL success, NSString *message) {
//                                self.view.userInteractionEnabled = YES;
//                                if (success)
//                                {
//                                    [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
//                                }
//                                else
//                                {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMError message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil];
//                                    [alert show];
//                                }
//                            }];
//
//                        }
//                        else
//                        {
//                            [self handleError:error withRetryStatus:YES];
//                        }
//                    }];
//                }
//            }
//        }
//        else if(self.isNameChanged)
//        {
//            IMUser* user = (IMUser*)self.selectedModel;
//            user.name = self.nameTxtField.text;
//            user.mobileNumber = ((IMUser *)self.selectedModel).mobileNumber;//self.phonNumberTxtField.text;
//            [self showActivityIndicatorView];
//            [[IMAccountsManager sharedManager] updateUser:(IMUser*)self.selectedModel withCompletion:^(NSError *error) {
//                [self hideActivityIndicatorView];
//                if(error)
//                {
//                    [self handleError:error withRetryStatus:YES];
//                }
//                else
//                {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }];
//        }
//        else if(!self.isNameChanged && !self.isMobileumberChanged)
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

/**
 @brief To handle done button action
 @returns void
 */
- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    if([self.phonNumberTxtField.text isPhoneNumber] == NO)
    {
//        [[[UIAlertView alloc] initWithTitle:@"Phone Number" message:IMInvalidPhoneNumber delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
//        
//
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Phone Number"
                                              message:IMInvalidPhoneNumber
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:IMOK
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.phonNumberTxtField becomeFirstResponder];
    }
    else
    {
        if([((IMUser *)self.selectedModel).mobileNumber isEqualToString:self.phonNumberTxtField.text])
        {
            self.isMobileumberChanged = NO;
        }
        else
        {
            self.isMobileumberChanged = YES;
        }
        
        if([((IMUser *)self.selectedModel).name isEqualToString:self.nameTxtField.text])
        {
            self.isNameChanged = NO;
        }
        else
        {
            self.isNameChanged = YES;
        }
        //If any user details changed ask for password
        if(self.isMobileumberChanged || self.isNameChanged)
        {
            [self.view endEditing:YES];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMPasswordRequiredtitle
//                                                            message:IMPasswordRequiredMessage
//                                                           delegate:self
//                                                  cancelButtonTitle:IMCancel
//                                                  otherButtonTitles:@"Submit",@"Verify via OTP",  nil];
//            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//            UITextField *password = [alert textFieldAtIndex:0];
//            password.secureTextEntry = YES;
//            alert.tag = 100;
//            [alert show];
            [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
            
        }
        else //No change in user details, simply pop back
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 100)
//    {
//        if(buttonIndex == 1)
//        {
//            UITextField *passwordtxtField = [alertView textFieldAtIndex:0];
//            self.password = passwordtxtField.text;
//            
//            IMUser* user = [[IMUser alloc] init];
//            user.isThroughMail = NO;
//            user.mobileNumber = ((IMUser *)self.selectedModel).mobileNumber;
//            user.password = self.password;
//            
//            [self showActivityIndicatorView];
//            self.view.userInteractionEnabled = NO;
//            
//            //Check with login API for user authentication
//            [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error) {
//                [self hideActivityIndicatorView];
//                self.view.userInteractionEnabled = YES;
//                //if login success update user info.
//                if(error == nil)
//                {
////                    IMUser* user = (IMUser*)self.selectedModel;
//                    IMUser *user = [[IMUser alloc] init];
//                    user.name = self.nameTxtField.text;
//                    user.mobileNumber = self.phonNumberTxtField.text;
//                    
//                    [self showActivityIndicatorView];
//                    
 //                   [[IMAccountsManager sharedManager] updateUser:user withCompletion:^(NSError *error)
//                     {
//                         [self hideActivityIndicatorView];
//                         if(error)
//                         {
//                             [self handleError:error withRetryStatus:YES];
//                         }
//                         else
//                         {
//                             //if phone number changes push to otp screen.
//                             if(self.isMobileumberChanged)
//                             {
//                                 [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
//                             }
//                             else
//                             {
//                                 [self.navigationController popViewControllerAnimated:YES];
//                             }
//                         }
//                     }];
//                }
//                else
//                {
//                    if(error.userInfo[IMMessage])
//                    {
////                        [self showAlertWithTitle:IMError andMessage:[error.userInfo valueForKey:IMMessage]];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMPasswordRequiredtitle
//                                                                        message:IMPasswordReRequiredMessage
//                                                                       delegate:self
//                                                              cancelButtonTitle:IMCancel
//                                                              otherButtonTitles:@"Submit", nil];
//                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                        UITextField *password = [alert textFieldAtIndex:0];
//                        password.secureTextEntry = YES;
//                        alert.tag = 100;
//                        [alert show];
//
//                    }
//                    else
//                    {
//                        [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
//                    }
//                }
//            }];
//            
//            
//        }
//        
//    }
//}

/**
 @brief To handle cancel button action
 @returns void
 */
- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMOtpSegue"])
    {
        IMOTPVerificationControllerViewController* otpVC = segue.destinationViewController;
        otpVC.phoneNumber = ((IMUser *)self.selectedModel).mobileNumber;
        otpVC.phoneNumberToUpdate = self.phonNumberTxtField.text;
        otpVC.nameToUpdate = self.nameTxtField.text;
        otpVC.screenType = IMForVerifyOldPhoneNumber;
        otpVC.isPhoneNumberUpdated = self.isMobileumberChanged;

    }
}

@end
