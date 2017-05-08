//
//  IMOrderSuccessViewController.m
//  InstaMed
//
//  Created by Arjuna on 01/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//



#import "IMOrderSuccessViewController.h"
#import "IMOrderReminderViewController.h"
#import "IMCartManager.h"
#import "IMApptentiveManager.h"
#import "IMServerManager.h"
#import "IMAppSettingsManager.h"
#import "IMBranchServiceManager.h"

#import "IMSharingUtility.h"
#import "IMConstants.h"

@interface IMOrderSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reorderRemainderButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *orderSuccessLabel;

@end

@implementation IMOrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_CELL_CORER(self.reorderRemainderButton, 8.0);
    [IMFunctionUtilities setBackgroundImage:self.reorderRemainderButton withImageColor:APP_THEME_COLOR];
    [IMFunctionUtilities setBackgroundImage:self.doneButton withImageColor:APP_THEME_COLOR];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadUI
{
    //[super loadUI];
    [self setUpNavigationBar];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    if (self.orderRevise) {
        self.orderSuccessLabel.text = IMOrderUpdateSuccessMessage;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   if(!self.orderRevise && self.selectedPaymentMethod)
   {
       [[IMApptentiveManager sharedManager] logOrderCompletionEventWithPaymentMethod:self.selectedPaymentMethod fromViewController:self];
   }
    
}

- (IBAction)backToHomePressed:(UIButton*)sender
{

    NSInteger selectedTab = self.tabBarController.selectedIndex;
    //Select home tab
    [self.tabBarController setSelectedIndex:0];
    //Pop only home and selected tab to root.
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:selectedTab] popToRootViewControllerAnimated:NO];
}

- (IBAction)reorderReminderPressed:(id)sender
{
    IMOrderReminderViewController* reminderViewController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"IMOrderReminderViewController"];
    reminderViewController.orderId = self.orderId;
    reminderViewController.view.frame = self.navigationController.view.bounds;
    [self.navigationController addChildViewController:reminderViewController];
    [self.navigationController.view addSubview:reminderViewController.view];
    [self didMoveToParentViewController:self.navigationController];
}

- (IBAction)facebookButtonPressed:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMOrderSharingFBTapped withParameters:@{}];
        NSString *message =[[IMAppSettingsManager sharedManager] appShareMessage];
        message = [message stringByReplacingOccurrencesOfString:IMAppLinkPlaceHolder withString:@""];
        [IMBranchServiceManager getAppSharingURLForChannel:@"Facebook" withCompletion:^(NSString *url, NSError *error) {
            
           
            [IMSharingUtility shareUsingFacebookWithURL:url andMessage:message];
        }];
    }
    else
    {
        [self showNoNetworkAlert];
    }
}

- (IBAction)twitterButtonPressed:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMOrderSharingTwitterTapped withParameters:@{}];
        NSString *message =[[IMAppSettingsManager sharedManager] appShareMessage];
        message = [message stringByReplacingOccurrencesOfString:IMAppLinkPlaceHolder withString:@""];
        [IMBranchServiceManager getAppSharingURLForChannel:@"Twitter" withCompletion:^(NSString *url, NSError *error) {
           
            [IMSharingUtility shareUsingTwitterWithURL:url andMessage:message];
        }];
    
    }
    else
    {
        [self showNoNetworkAlert];
    }
}

- (IBAction)GooglePlusButtonPressed:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMOrderSharingGPlusTapped withParameters:@{}];
        [IMBranchServiceManager getAppSharingURLForChannel:@"Gplus" withCompletion:^(NSString *url, NSError *error) {
            
            [IMSharingUtility shareUSingGooglePlusWithURL:url];
        }];
    }
    else
    {
        [self showNoNetworkAlert];
    }
}

- (IBAction)whatsappButtonPressed:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMOrderSharingWhatsappTapped withParameters:@{}];
        NSString *message =[[IMAppSettingsManager sharedManager] appShareMessage];
        message = [message stringByReplacingOccurrencesOfString:IMAppLinkPlaceHolder withString:@""];
        [IMBranchServiceManager getAppSharingURLForChannel:@"Whatsapp" withCompletion:^(NSString *url, NSError *error) {

            [IMSharingUtility shareUsingWhatsAppWithURL:url andMessage:message];
        }];
    }
    else
    {
        [self showNoNetworkAlert];
    }
}

- (IBAction)moreButtonPresssed:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMOrderSharingMoreButtonTapped withParameters:@{}];
        NSString *appSharingSubject = [[IMAppSettingsManager sharedManager] appShareSubject];
        NSString *appSharingMessage = [[IMAppSettingsManager sharedManager] appShareMessage];
        
        appSharingMessage = [appSharingMessage stringByReplacingOccurrencesOfString:IMAppLinkPlaceHolder withString:@""];
        
        [IMBranchServiceManager shareAppWithSubject:appSharingSubject message:appSharingMessage completion:nil];
    }
    else
    {
        [self showNoNetworkAlert];
    }
    
}




@end
