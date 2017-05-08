//
//  IMLoginViewController.m
//  InstaMed
//
//  Created by Arjuna on 15/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <GoogleSignIn/GoogleSignIn.h>

#import "IMLoginViewController.h"
#import "IMServerManager.h"
//#import <TwitterKit/TwitterKit.h>
#import "IMAccountsManager.h"
#import "NSString+Validations.h"
#import "IMRegistrationViewController.h"

#import "IMSocialNetworkManager.h"
#import "IMOTPVerificationControllerViewController.h"
#import "IMMobileNumberViewController.h"


@interface IMLoginViewController ()<UIAlertViewDelegate,IMSocialNetworkManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IMScreenType screentype;
@property (weak, nonatomic)  UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, assign) BOOL isThroughMail;


@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;
@end

@implementation IMLoginViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
//        // play with Twitter session
//        [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
//            NSLog(@"%@",user.screenName);
//        }];
//    }];
//    logInButton.center = self.view.center;
    



}

-(void)loadUI
{
    [self setUpNavigationBar];
    SET_CELL_CORER(self.loginButton, 2.0);
    [IMFunctionUtilities setBackgroundImage:self.loginButton withImageColor:APP_THEME_COLOR];
    SET_FOR_YOU_CELL_BORDER(self.registerButton,APP_THEME_COLOR,2.0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMTimeSpendInSignIn withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMSignInScreenVisited withParameters:@{}];

    if([[IMAccountsManager sharedManager] userToken])
    {
        [self.navigationController popViewControllerAnimated:NO];
    }

    
    if(self.hidesBackButton)
    {
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
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
//    [IMFlurry endTimedEvent:IMTimeSpendInSignIn withParameters:@{}];

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(textField == self.emailAddressTextField)
    {
        return newLength <= EMAIL_CHARACTER_LIMIT;
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

#pragma mark  - Actions -

/**
 @brief To handle registration button action
 @returns void
 */
- (IBAction)signInButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    [self.emailAddressTextField resignFirstResponder];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMWelcome message:IMHaveYouPlacedBefore delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
//    [alert show];
//    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:IMWelcome
//                                          message:IMHaveYouPlacedBefore
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *yesAction = [UIAlertAction
//                                   actionWithTitle:@"Yes"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       self.screentype = IMForInDirectRegistraion;
//                                       [self performSegueWithIdentifier:@"mobileNumber" sender:self];
//                                   }];
//    UIAlertAction *noAction = [UIAlertAction
//                                   actionWithTitle:@"No"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       self.screentype = IMForDirectRegistraion;
//                                       [self performSegueWithIdentifier:@"register" sender:self];
//                                   }];
//    
//    
//    [alertController addAction:yesAction];
//    [alertController addAction:noAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    self.screentype = IMForDirectRegistraion;
    [IMFlurry logEvent:IMRegistertapped withParameters:@{}];
    [self performSegueWithIdentifier:@"register" sender:self];
    
}

/**
 @brief To display alert for choosing resgistration type(New registration or alredy orderd through phone)
 @returns void
 */
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.emailAddressTextField resignFirstResponder];
//    [self.passwordTextField resignFirstResponder];
//    if (buttonIndex == 0)
//    {
//        self.screentype = IMForInDirectRegistraion;
//        [self performSegueWithIdentifier:@"mobileNumber" sender:self];
//    }
//    if (buttonIndex == 1)
//    {
//        self.screentype = IMForDirectRegistraion;
//        [self performSegueWithIdentifier:@"register" sender:self];
//    }
//}


/**
 @brief To handle forgott passsword button action
 @returns void
 */
- (IBAction)forgotPassword:(id)sender
{
    self.screentype = IMForForgotPassword;
    [IMFlurry logEvent:IMForgotPasswordTapped withParameters:@{}];
    [self performSegueWithIdentifier:@"mobileNumber" sender:self];
}

/**
 @brief To handle login button action
 @returns void
 */
- (IBAction)signIn:(id)sender
{
    [IMFlurry logEvent:IMSignInTapped withParameters:@{}];
    [self.view endEditing:YES];
    NSString *userID = self.emailAddressTextField.text;

    if(userID.length != 0)
    {
        NSRange replaceRange  = NSMakeRange(0, 3);
        //ka crashes if user taps on Sign In button without entering minimum 3 characters
        if (userID.length > 3 && [[userID substringWithRange:replaceRange] isEqualToString:@"+91"])
        {
            userID = [userID stringByReplacingOccurrencesOfString:@"+91" withString:@""];
        }

    }
    
    if(userID.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMEmptyEmail message:IMPlsEnterEmail delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMEmptyEmail andMessage:IMPlsEnterEmail];
        [self.emailAddressTextField becomeFirstResponder];
    }
    else if(NO == [userID isEmailAddress] && ( NO == [userID isPhoneNumber]))
    {
        //[[[UIAlertView alloc] initWithTitle:IMInvalidUser message:IMPlsEnterValidCredentiels delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMInvalidUser andMessage:IMPlsEnterValidCredentiels];
        [self.emailAddressTextField becomeFirstResponder];
    }
    else if(self.passwordTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMPasswordEmptyAlertTitle message:IMPasswordEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMPasswordEmptyAlertTitle andMessage:IMPasswordEmptyAlertMessage];
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.activeField resignFirstResponder];
        IMUser* user = [[IMUser alloc] init];
        
        if([userID isPhoneNumber])
        {
            user.isThroughMail = NO;
            self.isThroughMail = NO;
            user.mobileNumber = userID;
        }
        else
        {
            user.isThroughMail = YES;
            self.isThroughMail = YES;
            user.emailAddress = userID;
        }
        user.password = self.passwordTextField.text;
        
        [self showActivityIndicatorView];
        self.view.userInteractionEnabled = NO;
        [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error) {
            
            [self hideActivityIndicatorView];
            self.view.userInteractionEnabled = YES;

            if(error == nil)
            {
                if(self.isThroughMail)
                {
                    [IMFlurry setUserID:user.emailAddress];
                }
                else
                {
                    [IMFlurry setUserID:user.mobileNumber];
                }
                
                if(self.loginCompletionBlock)
                {
                    self.loginCompletionBlock(error);
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
}

- (IBAction)signInWithFacebook:(UIButton *)sender
{
    [IMFlurry logEvent:IMSocialLoginFacebookTapped withParameters:@{}];
  if([[IMServerManager sharedManager] isNetworkAvailable])
  {
      [IMSocialNetworkManager sharedManager].delegate = self;
      [[IMSocialNetworkManager sharedManager] loginToSocialChannel:IMSocialLoginUsingFacebook fromViewController:self];
  }
  else
  {
      [self showNoNetworkAlert];
  }
    
}

- (IBAction)signInWithGoogle:(UIButton *)sender
{
    [IMFlurry logEvent:IMSocialLoginGoogleTapped withParameters:@{}];
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [self showActivityIndicatorView];
        [IMSocialNetworkManager sharedManager].delegate = self;
        [[IMSocialNetworkManager sharedManager] loginToSocialChannel:IMSocialLoginUsingGoogle fromViewController:self];
    }
    else
    {
        [self showNoNetworkAlert];
    }
}

-(void)loginDidSuccedWithUserDetails:(NSDictionary *)userDictionary forType:(IMSocialChannelLoginType)type
{
    [self hideActivityIndicatorView];
    
    __block IMUser *user = [[IMUser alloc] init];
    user.SocialLoginUserID = userDictionary[@"id"];
    user.SocialAuthToken = userDictionary[@"accessToken"];
    user.emailAddress = userDictionary[@"email"];
    user.name = userDictionary[@"name"];
    if(type == IMSocialLoginUsingFacebook)
    {
        
        user.loginType = IMLoginTypeFacebook;
    }
    else if(type == IMSocialLoginUsingGoogle)
    {
        user.loginType = IMLoginTypeGoogle;

    }
    [self showActivityIndicatorView];
    self.view.userInteractionEnabled = NO;
    [[IMAccountsManager sharedManager] logInSocialUserWithUser:user withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        self.view.userInteractionEnabled = YES;
        if(error == nil)
        {
            
            if(self.loginCompletionBlock)
            {
                self.loginCompletionBlock(error);
            }
            if(user.loginType == IMLoginTypeFacebook)
            {
                [IMFlurry logEvent:IMFacebookSignInSuccess withParameters:@{}];
            }
            else
            {
                [IMFlurry logEvent:IMGoogleSignInSuccess withParameters:@{}];
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
            else if(error.code == 401 && [(NSString *)error.userInfo[@"error_code"] isEqualToString:@"EFR:Err:SocialLogin:USER_NOT_REGISTERED"])
            {
                [self performSegueWithIdentifier:@"SegueToRegisterWithSocialChannel" sender:user];
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



#pragma mark - Naviagtion -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"register"])
    {
        ((IMRegistrationViewController*)segue.destinationViewController).completionBlock = self.loginCompletionBlock;
        
    }
    else if ([segue.identifier isEqualToString:@"SegueToRegisterWithSocialChannel"])
    {
        ((IMRegistrationViewController*)segue.destinationViewController).completionBlock = self.loginCompletionBlock;
        ((IMRegistrationViewController*)segue.destinationViewController).user = (IMUser *)sender;
        ((IMRegistrationViewController*)segue.destinationViewController).registrationType = IMRegistrationUsingSocialChannel;
    }
    else if([segue.identifier isEqualToString:@"IMOTPSegue"])
    {
        IMOTPVerificationControllerViewController* otpVC = segue.destinationViewController;
        if(self.isThroughMail)
        {
            otpVC.emailId = self.emailAddressTextField.text;
//            otpVC.isPhoneNumberProvided = NO;

        }
        else
        {
//            otpVC.isPhoneNumberProvided = YES;
            otpVC.phoneNumber = self.emailAddressTextField.text;
            
        }
        otpVC.screenType = IMForLogin;
        otpVC.password = self.passwordTextField.text;
        otpVC.completionBlock = self.loginCompletionBlock;
    }
    else if ([segue.identifier isEqualToString:@"SegueToOTPForSocialLogin"])
    {
        IMOTPVerificationControllerViewController* otpVC = segue.destinationViewController;
        IMUser *user = (IMUser *)sender;
        otpVC.phoneNumber = user.mobileNumber;
        otpVC.screenType = IMForLogin;
        otpVC.registrationType = IMRegistrationUsingSocialChannel;
        otpVC.user = user;
        otpVC.completionBlock = self.loginCompletionBlock;
    }
    else if([segue.identifier isEqualToString:@"mobileNumber"])
    {
        IMMobileNumberViewController* mobileViewController  = segue.destinationViewController;
//        IMMobileNumberViewController* mobileViewController = navController.viewControllers.firstObject;
        mobileViewController.loginCompletionBlock = self.loginCompletionBlock;
        mobileViewController.screenType = self.screentype;
    }
}





#pragma mark -google signin-

- (void)signInToGoogle
{
//    [IMSocialManager sharedManager].delegate = self;
//    [[IMSocialManager sharedManager]logIn:IMSocialTypeGooglePlus options:nil];
    //TODO:Need to remove after integrating GP login
    
}
- (void)loginDidSuccedWithData:(NSDictionary *)dictionary
{
    
    //NSString *accessToken = dictionary[IMSocialAccessToken];
    //id type = dictionary[IMSocialLoginType];
    if(dictionary[IMSocialLoginType] && [dictionary[IMSocialLoginType] isEqualToNumber:@(1)])
    {
        //[[[UIAlertView alloc]initWithTitle:@"FB login success" message:@"" delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil, nil]show];
        [self showAlertWithTitle:@"FB login success" andMessage:@""];
    }
    else
    {
        //[[[UIAlertView alloc]initWithTitle:@"Google login success" message:@"" delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil, nil]show];
        [self showAlertWithTitle:@"Google login success" andMessage:@""];
    }
//    NSString *accessTokenSecret = @"";
//    NSString *referrer = @"";
}

- (void)loginDidFailWithData:(NSDictionary *)dictionary
{
    NSLog(@"error msg %@",dictionary[@"errorMessage"]);
}



@end
