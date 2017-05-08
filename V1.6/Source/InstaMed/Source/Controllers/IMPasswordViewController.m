//
//  IMPasswordViewController.m
//  InstaMed
//
//  Created by Sahana Kini on 17/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPasswordViewController.h"
#import "NSString+Validations.h"
#import "IMAccountsManager.h"

@interface IMPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *showHidePassword;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHideButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHideBttonToTopViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *temsAndConditionsPanelView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation IMPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadUI
{
    [super setUpNavigationBar];
    self.passwordLabel.hidden = YES;
    self.showHideBttonToTopViewConstraint.constant = 0;
    self.showHideButtonHeightConstraint.constant = 0;
    self.showHidePassword.hidden = YES;
    SET_FOR_YOU_CELL_BORDER(self.showHidePassword,APP_THEME_COLOR, 8.0);
    [self.showHidePassword setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
    if(self.screenType == IMForForgotPassword)
    {
        self.temsAndConditionsPanelView.hidden = YES;
        self.descriptionLabel.text = IMPlsEnterNewPassword;
        self.titleLabel.hidden = YES;
    }
    else if (self.screenType == IMForInDirectRegistraion)
    {
        self.temsAndConditionsPanelView.hidden = NO;
        self.descriptionLabel.text = IMLetComplete;
        self.titleLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)agreeButtonTapped:(UIButton *)sender
{
     sender.selected = !sender.selected;
    
}

- (IBAction)nextButtonTapped:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    if(self.passwordTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMPasswordEmptyAlertTitle message:IMPasswordEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMPasswordEmptyAlertTitle andMessage:IMPasswordEmptyAlertMessage];
        
        [self.passwordTextField becomeFirstResponder];
        
    }
    else if([self.passwordTextField.text isPassword] == NO)
    {
        //[[[UIAlertView alloc] initWithTitle:IMPasswordInvalidAlertTitle message:IMPasswordInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMPasswordInvalidAlertTitle andMessage:IMPasswordInvalidAlertMessage];
        [self.passwordTextField becomeFirstResponder];
    }
    else if (self.screenType != IMForForgotPassword && !self.agreeButton.selected)
    {
        
        //[[[UIAlertView alloc] initWithTitle:IMTermsNotAgreedAlertTitle message:IMMTermsNotAgreedAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMTermsNotAgreedAlertTitle andMessage:IMMTermsNotAgreedAlertMessage];
        [self.view endEditing:YES ];
    }
    else
    {
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] updatePasswordUsingOTP:self.otp newPassword:self.passwordTextField.text phoneNumber:self.phoneNumber withCompletion:^(NSError *error) {
            
            if(!error)
            {if(self.screenType == IMForInDirectRegistraion)
            {
                [IMFlurry logEvent:IMInDirectRegistrationEvent withParameters:@{}];
            }
                
            if(nil == [[IMAccountsManager sharedManager] userToken])
                {
                    IMUser* user = [[IMUser alloc] init];
                    user.mobileNumber = self.phoneNumber;
                    user.password = self.passwordTextField.text;
                    
                    [[IMAccountsManager sharedManager] logInWithUser:user withCompletion:^(NSError *error)
                     {
                         [IMFlurry setUserID:user.mobileNumber];
                         
                         if(self.loginCompletionBlock)
                         {
                             self.loginCompletionBlock(error);
                         }
                         
                     }];
                }
            }
            else
            {
                [self showError:error];
            }
            
        }];
        
    }

}

- (void)showError:(NSError *)error
{
    [self hideActivityIndicatorView];
    if(error.userInfo[@"failure_reason"])
    {
        [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:@"failure_reason"]];
    }
    else
        [self showAlertWithTitle:IMNetworkError andMessage:IMNoNetworkErrorMessage];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)textFieldDidChange:(UITextField *)sender
{
    if(self.passwordTextField.isSecureTextEntry)
    {
        self.passwordTextField.secureTextEntry = YES;

    }
    else
    {
        self.passwordTextField.secureTextEntry = NO;

    }
    if(sender.text.length == 0)
    {
        self.passwordTextField.secureTextEntry = YES;
        self.showHideBttonToTopViewConstraint.constant = 0;
        self.showHideButtonHeightConstraint.constant = 0;
        self.showHidePassword.hidden = YES;
        [self.showHidePassword setTitle:@"Show password" forState:UIControlStateNormal];
    }
    else
    {
        self.showHidePassword.hidden = NO;
        self.showHideBttonToTopViewConstraint.constant = 20;
        self.showHideButtonHeightConstraint.constant = 44;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [self.view endEditing:YES];
}

- (IBAction)showHidePassword:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.showHidePassword.hidden = NO;
    if(sender.selected)
    {
        self.passwordTextField.secureTextEntry = NO;
        [sender setTitle:@"Hide password" forState:UIControlStateNormal];
    }
    else
    {
        self.passwordTextField.secureTextEntry = YES;

        [sender setTitle:@"Show password" forState:UIControlStateNormal];

    }
}


@end
