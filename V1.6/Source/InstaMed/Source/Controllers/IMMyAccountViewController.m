//
//  IMAccountsViewController.m
//  InstaMed
//
//  Created by Arjuna on 18/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <GoogleSignIn/GoogleSignIn.h>
#import "IMSocialNetworkManager.h"
#import "IMMyAccountViewController.h"
#import "IMAddressListViewController.h"
#import "IMAccountsManager.h"
#import "IMLoginViewController.h"
#import "IMLocationManager.h"
#import "IMAccountEditViewController.h"
#import "IMConstants.h"
#import "IMCartManager.h"




@interface IMMyAccountViewController ()<IMAddressListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (strong,nonatomic) IMUser* user;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailToLocationHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rewardPointLabel;

@end

@implementation IMMyAccountViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMSccountScreenVisited withParameters:@{}];

    self.scrollView.hidden = YES;
    [self downloadFeed];

//    NSArray *subviews = [self.view subviews];
//
//    for (UIView *view in subviews)
//    {
//        view.hidden = YES;
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

}

/**
 @brief initial UI setup
 @returns void
 */
-(void)loadUI
{
    [super setUpNavigationBar];
    self.nameLabel.text = @"";
    self.phoneNumberLabel.text = @"";
    self.emailAddressLabel.text = @"";
    self.cityLabel.text = @"";
//    self.editButton.hidden = YES;
    //    self.userInfoView.backgroundColor = APP_THEME_COLOR;
}


/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    if(nil == [[IMAccountsManager sharedManager] userToken])
    {

        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else
    {
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] fetchUserWithCompletion:^(IMUser *user, NSError *error) {
            [self hideActivityIndicatorView];
            if(!error)
            {
                if(user)
                {
                    self.user = user;
                    [IMAccountsManager sharedManager].currentLoggedInUser = user;
                    [[IMAccountsManager sharedManager] setUserName:user.name];
                    [self updateUI];
                }
            }
            else
            {
                [self handleError:error withRetryStatus:YES];
            }
        }];
    }
}

/**
 @brief To update ui after feed
 @returns void
 */
-(void)updateUI
{
    self.scrollView.hidden = NO;

    if(_user.name)
    {
        self.nameLabel.text = _user.name;
    }
    else
    {
        self.nameLabel.text = IMDummyUserName;
    }

    self.phoneNumberLabel.text =  [NSString stringWithFormat:@"+91 %@",_user.mobileNumber];
    self.emailAddressLabel.text = _user.emailAddress;
    if(_user.emailAddress)
    {
        self.emailToLocationHeightConstraint.constant = 10;
        self.emailHeightConstraint.constant = 22;
    }
    else
    {
        self.emailToLocationHeightConstraint.constant = 0;
        self.emailHeightConstraint.constant = 0;
    }
    self.cityLabel.text = [IMLocationManager sharedManager].currentLocation.name;
//    self.editButton.hidden = NO;
    self.rewardPointLabel.text = [NSString stringWithFormat:@"₹ %.02f", self.user.rewardPoints.floatValue];
    [self.view layoutIfNeeded];

//    [UIView animateWithDuration:0.1 animations:^{
//    [self.view layoutIfNeeded];
//}];
    
    
}

/**
 @brief Tosetup the table height (delegate call back)
 @returns void
 */
-(void)didLoadWithAddressTableViewHeight:(CGFloat)height
{
    [self hideActivityIndicatorView];
    NSLog(@"table height %f",height);
    self.containerViewHeightConstraint.constant = height;
//    [self.containerView setNeedsLayout];
    [self.containerView layoutIfNeeded];
    [self.view layoutIfNeeded];
}

/**
 @brief To handle logout action
 remove user token from userdefault
 @returns void
 */
- (IBAction)logOut:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [[IMSocialNetworkManager sharedManager] logoutFacebook];

    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] logOutWithCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        if(error == nil)
        {
            [IMCartManager sharedManager].patientName = nil;
            [IMCartManager sharedManager].doctorName = nil;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
        else{
            NSString *message = (error.userInfo[IMMessage] && ![error.userInfo[IMMessage] isEqualToString:@""])?error.userInfo[IMMessage]:IMGeneralRequestFailureMessage;
            [self showAlertWithTitle:@"" andMessage:message];
        }
    }];
}

#pragma mark - Navigation -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addressListSegue"])
    {
        ((IMAddressListViewController*)segue.destinationViewController).delegate = self;
        ((IMAddressListViewController*)segue.destinationViewController).addressType = IMMyAccountAddressList;
    }
    else if([segue.identifier isEqualToString:@"loginSegue"])
    {
        __weak UIViewController* weakSelf = self;
        
        ((IMLoginViewController*)segue.destinationViewController).loginCompletionBlock = ^void(NSError* error)
        {
            [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        };
        ((IMLoginViewController*)segue.destinationViewController).hidesBackButton = YES;
    }
    else if([segue.identifier isEqualToString:@"IMProfileEditSegue"])
    {
        IMAccountEditViewController *editVC = segue.destinationViewController;
        editVC.selectedModel = self.user;
    }
    else if([segue.identifier isEqualToString:@"OrderHistorySegue"])
    {
        [IMFlurry logEvent:IMMyOrdersTapped withParameters:@{}];
    }
    else if([segue.identifier isEqualToString:@"PrescriptionListSegue"])
    {
        [IMFlurry logEvent:IMMyPrescriptionTapped withParameters:@{}];
    }
}

@end
