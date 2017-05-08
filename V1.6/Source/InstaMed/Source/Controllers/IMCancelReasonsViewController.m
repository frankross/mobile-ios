//
//  IMCancelReasonsViewController.m
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#define TRANSPARENT_ALPHA       0.0f
#define OVERLAY_ALPHA           0.5f

#import "IMCancelReasonsViewController.h"
#import "IMAccountsManager.h"
#import "IMCancelReasonCell.h"
#import "VSDropdown.h"
#import "UIView+IMViewSupport.h"

#define DROP_DOWN_HEIGHT 155

@interface IMCancelReasonsViewController()<VSDropdownDelegate,UITextViewDelegate>

@property(nonatomic,strong) IMCancelReasonCell* prototypeCell;

@property (nonatomic, strong) VSDropdown *dropdown;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (nonatomic, assign) BOOL isDropDownShown;
@property (weak, nonatomic) IBOutlet UIView *cotainerView;
@property (weak, nonatomic) IBOutlet UIView *blockingView;
@property(strong,nonatomic) UITapGestureRecognizer* tapGesture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterY;
@property (nonatomic, assign) CGFloat difference;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *refundMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVIewHeightConstaint;

@end

@implementation IMCancelReasonsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // to hide order refund message label when order is not refundable
    if(!self.isOrderRefundable)
    {
        self.refundMessageLabel.hidden = YES;
        self.contentVIewHeightConstaint.constant -= 20;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:IMDismissChildViewControllerNotification object:nil];
}

-(void)loadUI
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (IS_IOS8_OR_ABOVE)
    {
        self.tableView.estimatedRowHeight =UITableViewAutomaticDimension;
    }
    
    self.dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [self.dropdown setAdoptParentTheme:YES];
    [self.dropdown setShouldSortItems:NO];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, self.textView.frame.size.height)];
    self.textView.leftView = label;
    self.textView.leftViewMode = UITextFieldViewModeAlways;
    
    SET_FOR_YOU_CELL_BORDER(self.remarksTextView, [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0], 5.0)
    SET_FOR_YOU_CELL_BORDER(self.cotainerView, [UIColor clearColor], 5.0)
    SET_CELL_CORER(self.submitButton, 8);

    self.remarksTextView.text = IMComments;
    self.remarksTextView.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    
    [self.blockingView fadeFromAplha:TRANSPARENT_ALPHA toAlpha:0.5
                            duration:RTFastAnimDuration
                               delay:RTFastAnimDuration
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
         [self.blockingView addGestureRecognizer:self.tapGesture];
     }];
    [IMFunctionUtilities setBackgroundImage:self.submitButton withImageColor:APP_THEME_COLOR];
    

    [self downloadFeed];
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
 @brief To handle kayboard show/hide
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
        self.containerViewCenterY.constant -= self.difference;
        
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
        self.containerViewCenterY.constant += self.difference;
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

/**
 @brief To handle overlay dissmissal
 @returns void
 */
-(void)dismiss
{
    [self.view endEditing:YES];

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
                  [[NSNotificationCenter defaultCenter] removeObserver:self];
                  [self.view removeFromSuperview];
                  [self removeFromParentViewController];
                  if([self.delegate respondsToSelector:@selector(didDismissCancelReason)])
                  {
                      [self.delegate didDismissCancelReason];
                      
                  }
                  
              }];
         }
     }];
    
}


/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
//    [self showActivityIndicatorView];
    self.view.userInteractionEnabled = NO;
    [[IMAccountsManager sharedManager] fetchOrderCancellationReasonsWithCompletion:^(NSMutableArray *cancellationReasons, NSError *error) {
//        [self hideActivityIndicatorView];
        self.view.userInteractionEnabled = YES;

        if(!error )
        {
            self.modelArray = cancellationReasons;
            [self updateUI];

            if(self.modelArray.count)
            {
                self.selectedModel = self.modelArray[0];
//                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        else
        {
           [self handleError:error withRetryStatus:YES];
        }
    }];
}

-(void)updateUI
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [self.view endEditing:YES];
    if(self.isOrderRefundable)
    {
        self.refundMessageLabel.hidden = NO;
    }
    [self dismiss];
}

/**
 @brief To handle drop down action
 @returns void
 */
- (IBAction)dropDownPressed:(UITapGestureRecognizer *)sender
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [self.view endEditing:YES];
    for(IMCancelReason *reason in self.modelArray)
    {
        [contents addObject:reason.reason];
    }
    if(!self.isDropDownShown)
    {
        [self showDropDownForView:sender.view adContents:contents multipleSelection:NO];
        self.remarksTextView.hidden = YES;
        self.isDropDownShown = YES;

    }
    else
    {
        [self.dropdown remove];
        self.remarksTextView.hidden = NO;
        self.isDropDownShown = NO;

    }
}

//callback
-(void)showDropDownForView:(UIView *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    self.submitButton.hidden = YES;
    if(self.isOrderRefundable)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            //        self.downButton.transform = CGAffineTransformMakeRotation(0);
            self.refundMessageLabel.hidden = YES;
        }];
    }


    [self.dropdown setDrodownAnimation:rand()%2];
    
    [self.dropdown setAllowMultipleSelection:multipleSelection];
    
    [self.dropdown setupDropdownForView:sender];
    //dropdown max height
    self.dropdown.maxDropdownHeight = DROP_DOWN_HEIGHT;
    
    [self.dropdown setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    self.dropdown.textColor = APP_THEME_COLOR;
    if (self.dropdown.allowMultipleSelection)
    {
//        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[[sender titleForState:UIControlStateNormal] componentsSeparatedByString:@";"]];
    }
    else
    {
        [self.dropdown reloadDropdownWithContents:contents andSelectedItems:@[self.textView.text]];
    }
}

/**
 @brief To handle done action
 @returns void
 */
- (IBAction)doneButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    if([self.textView.text isEqualToString:@""])
    {
        [self showAlertWithTitle:@"" andMessage:IMCancelReasonMessage];
    }
    else
    {
        if (![self.remarksTextView.text isEqualToString:@""]) {
            ((IMCancelReason*)self.selectedModel).remarks = self.remarksTextView.text;
        }
        if([self.delegate respondsToSelector:@selector(didFinishWithCanelReason:)])
        {
            [self.delegate didFinishWithCanelReason:(IMCancelReason*)self.selectedModel];
            [self dismiss];
        }
    }
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
}
- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 1.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 1.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}

//call back
-(void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    self.selectedModel =  self.selectedModel = self.modelArray[index];
    self.textView.text =  ((IMCancelReason *)self.selectedModel).reason;
}


-(void)dropdownDidAppear:(VSDropdown *)dropDown
{
    self.remarksTextView.hidden = YES;
    self.isDropDownShown = YES;

//    [UIView animateWithDuration:0.5 animations:^{
//        self.downButton.transform = CGAffineTransformMakeRotation(M_PI);
//    }];
}

-(void)dropdownWillDisappear:(VSDropdown *)dropDown
{
    self.remarksTextView.hidden = NO;
    self.submitButton.hidden = NO;

    self.isDropDownShown = NO;
    
    if(self.isOrderRefundable)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            //        self.downButton.transform = CGAffineTransformMakeRotation(0);
            self.refundMessageLabel.hidden = NO;
        }];
    }

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:IMComments]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = IMComments;
        textView.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]; //optional
    }
    [textView resignFirstResponder];
}

@end
