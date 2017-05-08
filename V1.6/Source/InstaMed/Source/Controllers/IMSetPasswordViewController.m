//
//  IMSetPasswordViewController.m
//  InstaMed
//
//  Created by Arjuna on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSetPasswordViewController.h"
#import "IMAccountsManager.h"

@interface IMSetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newlyEnteredPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *reenterPasswordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)  UITextField *activeField;

@end

@implementation IMSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
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
-(void)loadUI
{
    [self setUpNavigationBar];
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.title = IMCancel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender
{
    if(self.currentPasswordTextField.text.length < 6)
    {
        [self showAlertWithTitle:IMInvalidCurrentPassword andMessage:IMPlsEnterValidCurrentPassword];
        [self.currentPasswordTextField becomeFirstResponder];
    }
    else if(self.newlyEnteredPasswordTextField.text.length < 6)
    {
        [self showAlertWithTitle:IMInvalidNewPassword andMessage:IMPlsEnterValidNewPassword];
        [self.newlyEnteredPasswordTextField becomeFirstResponder];
    }
    else if(! [self.newlyEnteredPasswordTextField.text isEqualToString:self.reenterPasswordTextField.text] )
    {
        [self showAlertWithTitle:IMPasswordMismatch andMessage:IMMismatchInPasswordConfirmation];
        [self.reenterPasswordTextField becomeFirstResponder];
    }
    else
    {
        
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] updatePasswordWithOldPassword:self.currentPasswordTextField.text
                                                             newPassword:self.newlyEnteredPasswordTextField.text
                                                          withCompletion:^(NSError *error)
         {
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
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
        
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
