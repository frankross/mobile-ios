//
//  IMQuantitySelectionViewController.m
//  InstaMed
//
//  Created by Arjuna on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMQuantitySelectionViewController.h"
#import "UIView+IMViewSupport.h"

#define TRANSPARENT_ALPHA       0.0f
#define OVERLAY_ALPHA           0.5f

@interface IMQuantitySelectionViewController ()

@property (nonatomic) NSInteger quantity;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UIButton *decrementButton;
@property (weak, nonatomic) IBOutlet UILabel *quantityInfoLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIView *blockingView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *maxOrderMessageLabel;

@end

@implementation IMQuantitySelectionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMQuantitySelectionVisited withParameters:@{}];

}

-(void)loadUI
{
    SET_CELL_CORER(self.containerView, 5);
    self.quantity = self.product.quantity;
    [self updateQuantityInfoLabels];
    //To make the blocking view transperanat.
    [self.blockingView fadeFromAplha:TRANSPARENT_ALPHA toAlpha:0.5
                            duration:RTFastAnimDuration
                               delay:RTFastAnimDuration
                              option:UIViewAnimationOptionCurveEaseIn
                          completion:^(BOOL finished)
     {
         //Add gesture to blocking view for touch dissmissal
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
         [self.blockingView addGestureRecognizer:self.tapGesture];
     }];
}

/**
 @brief fade animation to blocking view
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
 @brief To update quantity related labels according to the count
 @returns void
 */
-(void)updateQuantityInfoLabels
{
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)self.quantity];
    if(self.product.innerPackingQuantity)
        self.quantityInfoLabel.text = [NSString stringWithFormat:@"Each %@ contains %@",self.product.unitOfSales,self.product.innerPackingQuantity];
    else
        self.quantityInfoLabel.text = self.product.unitOfSales;
    if(self.quantity == self.product.maxOrderQuanitity.integerValue)
    {
        self.maxOrderMessageLabel.hidden = NO;
       self.maxOrderMessageLabel.text = IMMAximumQtyReached;
    }
    else if(self.quantity > self.product.maxOrderQuanitity.integerValue)
    {
        self.maxOrderMessageLabel.hidden = NO;
        self.maxOrderMessageLabel.text = IMMAximumQtyExeeded;
    }
    else
    {
        self.maxOrderMessageLabel.hidden = YES;
         self.maxOrderMessageLabel.text= @"";
    }
}

/**
 @brief To dissmiss with animation
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
//                  [self.view removeFromSuperview];
//                  [self removeFromParentViewController];
                  [self dismissViewControllerAnimated:YES completion:nil];
                  
              }];
         }
     }];

}

/**
 @brief To handle submit button action
 @returns void
 */
- (IBAction)submit:(id)sender
{
    [IMFlurry logEvent:IMQuantityDoneTapped withParameters:@{}];
   if([self.delgate respondsToSelector:@selector( quantitySelectionController:didFinishWithWithQuanity:)])
   {
       [self.delgate quantitySelectionController:self didFinishWithWithQuanity:self.quantity];
   }
    [self dismiss];
}

/**
 @brief To handle increment button action
 @returns void
 */
- (IBAction)increment:(id)sender
{
    if(self.quantity < [self.product.maxOrderQuanitity integerValue])
    {
        self.quantity++;
        [self updateQuantityInfoLabels];
    }
}

/**
 @brief To handle decrement button action
 @returns void
 */
- (IBAction)decrement:(id)sender
{
    if(self.quantity > 1)
    {
        self.quantity--;
        [self updateQuantityInfoLabels];
    }
}

@end
