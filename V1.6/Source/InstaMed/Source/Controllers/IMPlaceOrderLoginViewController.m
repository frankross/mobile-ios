//
//  IMCartContainerViewController.m
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPlaceOrderLoginViewController.h"
#import "IMAccountsManager.h"
#import "IMLoginViewController.h"
#import "IMDeliveryAddressViewController.h"
#import "IMOrderSummaryScreen.h"

@interface IMPlaceOrderLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deliveryAddressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *summaryImageView;
@property (weak,nonatomic) UIViewController* selectedViewController;
@end

@implementation IMPlaceOrderLoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    IMLoginViewController* loginViewController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:IMLoginVCID];
    
    __weak IMPlaceOrderLoginViewController* weakSelf = self;
    
    loginViewController.loginCompletionBlock = ^(NSError* error){
        
        if(!error)
        {
            weakSelf.completionBlock();
        }
    };
    [self addViewControllerToConainerView:loginViewController];
}

/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
}


/**
 @brief To handle top order progress image
 @returns void
 */
-(void)updateCheckoutStatusImages
{
    if([self.selectedViewController isKindOfClass:[IMLoginViewController class]])
    {
        self.loginImageView.image = [UIImage imageNamed:@"filledCircle"];
        self.deliveryAddressImageView.image = [UIImage imageNamed:@"emptyCircle"];
        self.summaryImageView.image = [UIImage imageNamed:@"emptyCircle"];
    }
    else if([self.selectedViewController isKindOfClass:[IMDeliveryAddressViewController class]])
    {
        self.loginImageView.image = [UIImage imageNamed:@"checkedCircle"];
        self.deliveryAddressImageView.image = [UIImage imageNamed:@"filledCircle"];
        self.summaryImageView.image = [UIImage imageNamed:@"emptyCircle"];
    }
    else if([self.selectedViewController isKindOfClass:[IMDeliveryAddressViewController class]])
    {
        self.deliveryAddressImageView.image = [UIImage imageNamed:@"checkedCircle"];
        self.summaryImageView.image = [UIImage imageNamed:@"filledCircle"];
        self.summaryImageView.image = [UIImage imageNamed:@"filledCircle"];
    }
}

/**
 @brief To add childviewcontroller
 @returns void
 */
-(void)addViewControllerToConainerView:(UIViewController*)viewController
{
    [self addChildViewController:viewController];
    viewController.view.frame = self.containerView.bounds;
    
    [self.containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    if(self.selectedViewController)
    {
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
    }
    self.selectedViewController =viewController;
    [self updateCheckoutStatusImages];
}


#pragma mark - Navigation -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"deliveryAddressSegue"])
    {
        IMDeliveryAddressViewController* deliveryAddressViewController = (IMDeliveryAddressViewController*)segue.destinationViewController;
        deliveryAddressViewController.completionBlock = ^(IMDeliverySlot* deliverySlot)
        {
            [self performSegueWithIdentifier:@"orderSummarySegue" sender:self];
        };
        [self addViewControllerToConainerView:segue.destinationViewController];
    }
    else if([segue.identifier isEqualToString:@"orderSummarySegue"])
    {
         [self addViewControllerToConainerView:segue.destinationViewController];
    }
}

@end
