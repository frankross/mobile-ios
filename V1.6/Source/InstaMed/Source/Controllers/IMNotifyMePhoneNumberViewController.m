//
//  IMNotifyMePhoneNumberViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 09/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNotifyMePhoneNumberViewController.h"

#import "IMConstants.h"
#import "NSString+Validations.h"

@interface IMNotifyMePhoneNumberViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewcenterYConstaint;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, assign) CGFloat difference;;


@end

@implementation IMNotifyMePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView.layer.cornerRadius = 12.0f;
    self.doneButton.layer.cornerRadius = 2.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 10;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBActions

- (IBAction)doneButtonPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if([phoneNumber isPhoneNumber])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delgate notifyTheUserWithPhoneNumber:phoneNumber];
        }];
    }
    else
    {
        [self showAlertWithTitle:IMMobileNumberInvalidAlertTitle andMessage:IMMobileNumberInvalidAlertMessage];
        [self.phoneNumberTextField becomeFirstResponder];
    }
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    CGPoint point =  CGPointMake(CGRectGetMinX(self.containerView.frame),CGRectGetMaxY(self.containerView.frame));
    
    if (!CGRectContainsPoint(aRect,point))
    {
        self.difference = point.y - aRect.size.height;
        self.containerViewcenterYConstaint.constant -= self.difference;
        
        //http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation
        
        NSNumber *durationValue = info[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        
        NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = curveValue.intValue;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
        
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    if (self.difference != 0)
    {
        NSDictionary* info = [notification userInfo];
        self.containerViewcenterYConstaint.constant += self.difference;
        self.difference = 0;
        
        NSNumber *durationValue = info[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        
        NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = curveValue.intValue;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
        
    }
}

- (IBAction)tappedOutside:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
