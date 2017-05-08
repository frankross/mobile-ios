//
//  IMMobileNumberViewController.m
//  InstaMed
//
//  Created by Sahana Kini on 17/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMMobileNumberViewController.h"
#import "NSString+Validations.h"
#import "IMOTPVerificationControllerViewController.h"
#import "IMAccountsManager.h"
#import "IMConstants.h"

@interface IMMobileNumberViewController ()< UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;

@end

@implementation IMMobileNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
    self.activityIndicator.tintColor = APP_THEME_COLOR;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMTimeSpendInMobileNumber withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMMobileNumberScreenVisited withParameters:@{}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMTimeSpendInMobileNumber withParameters:@{}];
    
}

- (void)loadUI
{
    [super setUpNavigationBar];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.mobileNumTextField.frame.size.height)];
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"+91";
    self.mobileNumTextField.leftView = label;
    self.mobileNumTextField.leftViewMode = UITextFieldViewModeAlways;
    if(self.screenType == IMForInDirectRegistraion)
    {
        self.descriptionlabel.text = IMEnterOrderMobileNumber;
        self.titleLabel.hidden = NO;
    }
    else if(self.screenType == IMForForgotPassword)
    {
        self.descriptionlabel.text = IMEnterregistrationMobileNumber;
        self.titleLabel.hidden = YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)nextButtonTapped:(id)sender
{
    if(self.mobileNumTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberEmptyAlertTitle message:IMMobileNumberEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberEmptyAlertTitle andMessage:IMMobileNumberEmptyAlertMessage];
        [self.mobileNumTextField becomeFirstResponder];
        
    }
    else if( [self.mobileNumTextField.text isPhoneNumber] == NO)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberInvalidAlertTitle message:IMMobileNumberInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberInvalidAlertTitle andMessage:IMMobileNumberInvalidAlertMessage];
        [self.mobileNumTextField becomeFirstResponder];
        
    }
    else
    {
        [self.mobileNumTextField resignFirstResponder];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
        [[IMAccountsManager sharedManager] generateOTPForPhoneNumber:self.mobileNumTextField.text withCompletion:^(BOOL success, NSString *message) {
            [self. activityIndicator stopAnimating];
            self.view.userInteractionEnabled = YES;
            if (success)
            {
                [self performSegueWithIdentifier:@"IMOtpSegue" sender:self];
            }
            else
            {
                if(message)
                {
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil];
                    //[alert show];
                    [self showAlertWithTitle:@"" andMessage:message];
                }
                else
                {
                    [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
                }
            }
        }];

    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"IMOtpSegue"])
    {
        IMOTPVerificationControllerViewController *controller = segue.destinationViewController;
//        controller.isPhoneNumberProvided = YES;
        controller.screenType = self.screenType;
        controller.phoneNumber = self.mobileNumTextField.text;
        controller.completionBlock = self.loginCompletionBlock;
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  - Textfield Delegate Methods -

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
//{
//    self.activeField = sender;
//}
//
//- (IBAction)textFieldDidEndEditing:(UITextField *)sender
//{
//    self.activeField = nil;
//}

// mobile number field should accept only numbers and 10 digits
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobileNumTextField)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= PHONE_NUMBER_CHARACTER_LIMIT));
    }
    else
    {
        return YES;
    }
}

@end
