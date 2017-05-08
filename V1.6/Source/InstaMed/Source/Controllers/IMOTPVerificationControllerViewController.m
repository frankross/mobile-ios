//
//  IMOTPVerificationControllerViewController.m
//  InstaMed
//
//  Created by Arjuna on 30/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOTPVerificationControllerViewController.h"
#import "IMAccountsManager.h"
#import "NSString+Validations.h"
#import "IMChangeMobileViewController.h"
#import "IMPasswordViewController.h"

@interface IMOTPVerificationControllerViewController ()<IMChangeNumberViewControllerDelgate>
- (IBAction)ChangeNumberPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UIButton *changeNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeNumberButtonContainerViewWidthConstraint;
@end

@implementation IMOTPVerificationControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMTimeSpendInOTP withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMOtpScreenVisited withParameters:@{}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMTimeSpendInOTP withParameters:@{}];
    
}

-(void)loadUI
{
    SET_CELL_CORER(self.submitButton,8.0);
    
    [IMFunctionUtilities setBackgroundImage:self.submitButton withImageColor:APP_THEME_COLOR];
    NSString *text = IMSendOTPtoRegisterdMobile;
    //TODO:Testing
    if (self.screenType == IMForInDirectRegistraion || self.screenType == IMForForgotPassword || self.screenType == IMForDirectRegistraion || self.screenType == IMForChangeNumber || self.screenType == IMForLogin || self.screenType == IMForVerifyOldPhoneNumber)
    {
        text = [NSString stringWithFormat:@"We have just sent a OTP to %@. Enter it below so we know it's really you.",self.phoneNumber];
    }
    else
    {
        self.mainLabel.hidden = YES;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.instructionLabel.attributedText = attributedString;
    //TODO:Testing
    if (self.screenType == IMForInDirectRegistraion || self.screenType == IMForForgotPassword || self.screenType == IMForChangeNumber || self.screenType == IMForVerifyOldPhoneNumber )
    {
        self.changeNumberButton.hidden = YES;
        self.orLabel.hidden = YES;
        self.changeNumberButtonContainerViewWidthConstraint.constant = 153;
    }
    else if((self.screenType == IMForLogin && self.emailId != nil) || self.screenType == IMForDirectRegistraion)
    {
        self.changeNumberButton.hidden = NO;
        self.orLabel.hidden = NO;
    }
    if(self.emailId == nil)
    {
        self.changeNumberButton.hidden = YES;
        self.orLabel.hidden = YES;
        self.changeNumberButtonContainerViewWidthConstraint.constant = 153;
    }
    if(self.screenType == IMForVerifyOldPhoneNumber )
    {
        //send OTP first to old number
        [self resendOTP:nil];
    }
}

- (IBAction)resendOTP:(id)sender
{

    if(self.phoneNumber)
    {
        [[IMAccountsManager sharedManager] generateOTPForPhoneNumber:self.phoneNumber withCompletion:^(BOOL success, NSString *message)
         {
             if(!success)
             {
                 if(message)
                 {
                     [self showAlertWithTitle:@"" andMessage:message];

                 }
                 else
                 {
                     [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
                 }
             }
             else
             {
                 [self showAlertWithTitle:IMOTPVerification andMessage:message];
             }
        }];
    }
    else
    {
        [[IMAccountsManager sharedManager] resendOTPForEmailId:self.emailId withCompletion:^(NSDictionary* messageDictionary, NSError *error)
         {
             if(!error)
             {
                 if(messageDictionary[IMMessage])
                 {
                     [self showAlertWithTitle:IMOTPVerification andMessage:messageDictionary[IMMessage]];
                 }
             }
             else
             {
                 if(error.userInfo[@"failure_reason"])
                 {
                     [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:@"failure_reason"]];
                 }
                 else if([error.userInfo valueForKey:IMMessage])
                 {
                     [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                 }
                 else
                     [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
             }
             
         }];

    }

}

- (IBAction)verifyOTP:(id)sender
{
    [IMFlurry logEvent:IMOTPSubmittapped withParameters:@{}];
    [self.view endEditing:YES];
    if (self.otpTextField.text.length)
    {
        if(self.phoneNumber)
        {
            [self verifyPhoneNumber];

        }
        else
        {
            [self verifyEmail];
        }
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:IMPlsEnterValidOTP];
    }
}


- (void)verifyPhoneNumber
{
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] verifyOTP:self.otpTextField.text forPhoneNumber:self.phoneNumber withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        if (!error)
        {
            if(self.screenType == IMForForgotPassword || self.screenType == IMForInDirectRegistraion)
            {
                [self performSegueWithIdentifier:@"IMPassword" sender:self];
            }
            else if (self.screenType == IMForDirectRegistraion || self.screenType == IMForLogin)
            {
                [IMFlurry logEvent:IMRegistrationCompleted withParameters:@{}];

                if(nil == [[IMAccountsManager sharedManager] userToken] && self.registrationType == IMDirectRegistration)
                {
                    IMUser* user = [[IMUser alloc] init];
//                    user.emailAddress = self.emailId;
                    user.mobileNumber = self.phoneNumber;
                    user.password = self.password;
                    [self showActivityIndicatorView];

                    [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error)
                     {
                         [self hideActivityIndicatorView];

                         [IMFlurry setUserID:user.mobileNumber];

                         if(self.completionBlock)
                         {
                             self.completionBlock(error);
                         }
                     }];
                }
                else if (nil == [[IMAccountsManager sharedManager] userToken] && self.registrationType == IMRegistrationUsingSocialChannel)
                {
                    [self showActivityIndicatorView];

                    [[IMAccountsManager sharedManager] logInSocialUserWithUser:self.user withCompletion:^(NSError *error) {
                        [self hideActivityIndicatorView];
                        if(error == nil)
                        {
                            
                            if(self.completionBlock)
                            {
                                self.completionBlock(error);
                            }
                        }
                    }];
                }
            }
            else if(self.screenType == IMForChangeNumber )
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if (self.screenType == IMForVerifyOldPhoneNumber)
            {
                IMUser *user = [[IMUser alloc] init];
                user.name = self.nameToUpdate;
                user.mobileNumber = self.phoneNumberToUpdate;
                [self showActivityIndicatorView];
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [[IMAccountsManager sharedManager] updateUser:user withCompletion:^(NSError *error)
                {
                    [self hideActivityIndicatorView];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    if(error)
                    {
                        //[self handleError:error withRetryStatus:YES];
                        if(error.userInfo[IMMessage])
                        {
                            [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
                        }
                        else
                        {
                            [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
                        }
                        
                    }
                    else
                    {   if(self.isPhoneNumberUpdated) // goto otp screen again to verify users updated  number
                        {
                            IMOTPVerificationControllerViewController *OTPViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OTPScreen"];
                            OTPViewController.phoneNumber = self.phoneNumberToUpdate;
                            OTPViewController.screenType = IMForChangeNumber;
                            
                            UINavigationController *navController = self.navigationController;
                            
                            
                            // Pop this controller and replace with another
                            [navController popViewControllerAnimated:NO];//not to see pop
                            
                            [navController pushViewController:OTPViewController animated:YES];//to see push or u can change it to not to see.
                        }
                        else
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }
                }];
            }
        }
        else
        {
            if(error.userInfo[@"failure_reason"])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:@"failure_reason"]];
            }
            else if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost || error.code == -1016)
            {
                [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
            }
        }
    }];
}

- (void)verifyEmail
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] verifyOTP:self.otpTextField.text forEmailId:self.emailId withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];

        if(!error)
        {
            if(nil == [[IMAccountsManager sharedManager] userToken])
            {
                IMUser* user = [[IMUser alloc] init];
                user.emailAddress = self.emailId;
                user.password = self.password;
                
                [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error)
                 {
                     [IMFlurry setUserID:user.emailAddress];

                     if(self.completionBlock)
                     {
                       self.completionBlock(error);
                     }
                 }];
                
            }
            else if (nil == [[IMAccountsManager sharedManager] userToken] && self.registrationType == IMRegistrationUsingSocialChannel)
            {
                
                [[IMAccountsManager sharedManager] logInSocialUserWithUser:self.user withCompletion:^(NSError *error) {
                    if(error == nil)
                    {
                        
                        if(self.completionBlock)
                        {
                            self.completionBlock(error);
                        }
                    }
                }];
            }
        }
        else
        {
            [self hideActivityIndicatorView];
            if(error.userInfo[@"failure_reason"])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:@"failure_reason"]];
            }
            else if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost || error.code == -1016)
            {
                [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
            }
        }
        
    }];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"IMPassword"])
    {
        IMPasswordViewController *viewController = segue.destinationViewController;
        viewController.screenType = self.screenType;
        viewController.phoneNumber = self.phoneNumber;
        viewController.otp = self.otpTextField.text;
        viewController.loginCompletionBlock = self.completionBlock;
    }
}

- (IBAction)ChangeNumberPressed:(id)sender
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
    IMChangeMobileViewController* changeNumberVC = [storyboard instantiateViewControllerWithIdentifier:@"IMChangeMobileViewController"];
    changeNumberVC.email = self.emailId;
    changeNumberVC.password = self.password;
    changeNumberVC.delegate = self;
    changeNumberVC.user = self.user;
    changeNumberVC.registrationType = self.registrationType;
    changeNumberVC.view.frame = self.navigationController.view.bounds;
    [self.navigationController addChildViewController:changeNumberVC];
    [self.navigationController.view addSubview:changeNumberVC.view];
    [self didMoveToParentViewController:self.navigationController];
}

- (void)didFinishChangeNumberWithphoneNumber:(NSString *)mobile
{
    self.phoneNumber = mobile;
    NSString *text = [NSString stringWithFormat:@"We have just sent a OTP to %@. Enter it below so we know it's really you.",mobile];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.instructionLabel.attributedText = attributedString;
    [[IMAccountsManager sharedManager] generateOTPForPhoneNumber:mobile withCompletion:^(BOOL success, NSString *message)
     {
         if(!success)
         {
             [self showAlertWithTitle:@"" andMessage:message];
         }
         else
         {
             [self showAlertWithTitle:IMOTPVerification andMessage:message];
         }
     }];
}

@end
