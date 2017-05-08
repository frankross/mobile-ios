//
//  IMChangeMobileViewController.m
//  InstaMed
//
//  Created by Suhail K on 04/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#define TRANSPARENT_ALPHA       0.0f
#define OVERLAY_ALPHA           0.5f

#import "IMChangeMobileViewController.h"
#import "UIView+IMViewSupport.h"
#import "NSString+Validations.h"
#import "IMAccountsManager.h"

@interface IMChangeMobileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
- (IBAction)nextPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cotainerView;

@property (weak, nonatomic) IBOutlet UIView *blockingView;

@property(strong,nonatomic) UITapGestureRecognizer* tapGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterY;
@property (nonatomic, assign) CGFloat difference;

@end

@implementation IMChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadUI
{
    SET_CELL_CORER(self.cotainerView, 5);
    SET_CELL_CORER(self.nextButton,8.0);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, self.numberTextField.frame.size.height)];
    label.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"+91";
    self.numberTextField.leftView = label;
    self.numberTextField.leftViewMode = UITextFieldViewModeAlways;
    [IMFunctionUtilities setBackgroundImage:self.nextButton withImageColor:APP_THEME_COLOR];
    
    [self.blockingView fadeFromAplha:TRANSPARENT_ALPHA toAlpha:0.5
                            duration:RTFastAnimDuration
                               delay:RTFastAnimDuration
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
         [self.blockingView addGestureRecognizer:self.tapGesture];
     }];
    
}


/**
 @brief handle overlay transperancy
 @returns void
 */
- (void)fadeOutOverlayWithCompletion:(void (^)(BOOL completed))completion
{
    [self.blockingView fadeFromAplha:self.blockingView.alpha
                             toAlpha:TRANSPARENT_ALPHA
                            duration:RTQuickAnimDuration
                               delay:RTNoAnimDelay
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         completion(finished);
     }];
}

/**
@brief handle overlay dissmissal
@returns void
*/

-(void)dismiss
{
    [self fadeOutOverlayWithCompletion:^(BOOL completed)
     {
         if(completed)
         {
             [self.blockingView removeGestureRecognizer:self.tapGesture];
             [UIView animateWithDuration:0.9f
                              animations:
              ^{
              } completion:^(BOOL finished)
              {
                  [self.view removeFromSuperview];
                  [self removeFromParentViewController];
                  
              }];
             
         }
     }];
    
}

/**
 @brief handle next button action
 @returns void
 */
- (IBAction)nextPressed:(id)sender
{
    if(self.numberTextField.text.length == 0)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberEmptyAlertTitle message:IMMobileNumberEmptyAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberEmptyAlertTitle andMessage:IMMobileNumberEmptyAlertMessage];
        [self.numberTextField becomeFirstResponder];
        
    }
    else if( [self.numberTextField.text isPhoneNumber] == NO)
    {
        //[[[UIAlertView alloc] initWithTitle:IMMobileNumberInvalidAlertTitle message:IMMobileNumberInvalidAlertMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles: nil] show];
        [self showAlertWithTitle:IMMobileNumberInvalidAlertTitle andMessage:IMMobileNumberInvalidAlertMessage];
        [self.numberTextField becomeFirstResponder];
        
    }
    else
    {
        if(self.registrationType == IMRegistrationUsingSocialChannel)
        {
            [self updatePhoneNumberForSocialUser];
        }
        else
        {
            [self updatePhoneNumberForDirectUser];
        }
    }
}

- (void)updatePhoneNumberForDirectUser
{
    [[IMAccountsManager sharedManager] updatePhoneNumber:self.numberTextField.text withEmail:self.email andPassword:self.password withCompletion:^(NSError *error) {
        if(!error)
        {
            //                [self showAlertWithTitle:@"Successfully updated" andMessage:@"Your mobile number updated successfully"];
            
            if([self.delegate respondsToSelector:@selector(didFinishChangeNumberWithphoneNumber:)])
            {
                [self.delegate didFinishChangeNumberWithphoneNumber:self.numberTextField.text];
            }
            [self dismiss];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
    }];
}

- (void) updatePhoneNumberForSocialUser
{
    [[IMAccountsManager sharedManager] updatePhoneNumberForSocialUserWithUserInfo:[self.user dictionaryForUpdatePhoneForSocialUserWithPhoneNumber:self.numberTextField.text] withCompletion:^(NSError *error) {
        
        if(!error)
        {
            
            if([self.delegate respondsToSelector:@selector(didFinishChangeNumberWithphoneNumber:)])
            {
                [self.delegate didFinishChangeNumberWithphoneNumber:self.numberTextField.text];
            }
            [self dismiss];
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }
     
    }];
}
/**
 @brief handle keybard show/hide
 @returns void
 */
- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    CGPoint point =  CGPointMake(CGRectGetMinX(self.cotainerView.frame),CGRectGetMaxY(self.cotainerView.frame));
                                 
    if (!CGRectContainsPoint(aRect,point))
    {
        self.difference = point.y - aRect.size.height;
        self.containerViewCenterY.constant += self.difference;
        
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
        self.containerViewCenterY.constant -= self.difference;
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
@end
