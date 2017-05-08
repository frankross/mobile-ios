//
//  IMReferAFriendViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 05/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "IMReferAFriendViewController.h"
#import "IMFAQViewController.h"
#import "AFHTTPRequestOperation.h"
#import "IMServerManager.h"
#import "IMAccountsManager.h"
#import "IMBranchServiceManager.h"
#import "IMUserReferralDetails.h"


#define ALERT_FADE_DELAY 2

@interface IMReferAFriendViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *referAFriendImage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *HowItWorksButton;
@property (weak, nonatomic) IBOutlet UIButton *referAFriendButton;

@property (nonatomic, strong) IMUserReferralDetails *userRerralDetails;

@end

@implementation IMReferAFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.referAFriendImage.hidden = YES;
    self.messageLabel.hidden = YES;
    self.HowItWorksButton.hidden = YES;
    self.referAFriendButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
    [self downloadFeed];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMReferFriendScreenVisited withParameters:@{}];
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    if([IMAccountsManager sharedManager].userID)
    {
        [self showActivityIndicatorView];
        [[IMServerManager sharedManager] fetchUserReferralDetailsWithCompletion:^(NSDictionary *referralDictionary, NSError *error) {
            [self hideActivityIndicatorView];
            if(error)
            {
                [self handleError:error withRetryStatus:YES];
            }
            else
            {
                self.userRerralDetails = [[IMUserReferralDetails alloc] initWithDictionary:referralDictionary];
                [self updateUI];
            }
        }];
    }
    else
    {
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] fetchUserWithCompletion:^(IMUser *user, NSError *error) {
            if(!error)
            {
                [[IMBranchServiceManager getBranchInstance] setIdentity:[user.identifier stringValue]];
                [[IMServerManager sharedManager] fetchUserReferralDetailsWithCompletion:^(NSDictionary *referralDictionary, NSError *error) {
                    [self hideActivityIndicatorView];
                    if(error)
                    {
                        [self handleError:error withRetryStatus:YES];
                    }
                    else
                    {
                        self.userRerralDetails = [[IMUserReferralDetails alloc] initWithDictionary:referralDictionary];
                        [self updateUI];
                    }
                }];
            }
            else
            {
                [self hideActivityIndicatorView];
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
    self.referAFriendImage.hidden = NO;
    self.messageLabel.hidden = NO;
    self.HowItWorksButton.hidden = NO;
    self.referAFriendButton.hidden = NO;
    self.messageLabel.text = self.userRerralDetails.message;
}


#pragma mark - IBActions

- (IBAction)pressedHowItWorksButton:(UIButton *)sender
{
    [IMFlurry logEvent:IMReferFriendHowItWorksTapped withParameters:@{}];
    UIStoryboard *moreStoryboard = [UIStoryboard storyboardWithName:@"Support&More" bundle:nil];
    if(moreStoryboard && self.userRerralDetails.FAQTopicID != nil)
    {
        IMFAQViewController *FAQViewController = [moreStoryboard instantiateViewControllerWithIdentifier:@"FAQDetailScene"];
        FAQViewController.identifier = self.userRerralDetails.FAQTopicID;
        FAQViewController.title = @"Refer a friend";
        [self.navigationController pushViewController:FAQViewController animated:YES];
    }
}




- (IBAction)InviteFriendButtonPressed:(UIButton *)sender
{
    
    [IMFlurry logEvent:IMInviteFriendsTapped withParameters:@{}];
    if([IMAccountsManager sharedManager].userID)
    {
        if(self.userRerralDetails.isActive)
        {
            if ([[IMServerManager sharedManager] isNetworkAvailable])
            {
                [IMBranchServiceManager shareReferralLinkWithSubject:self.userRerralDetails.socialSharingDetails.emailSubject
                                               andPromotionalMessage:self.userRerralDetails.socialSharingDetails.promotionalMessage
                                                          completion:nil];
                
            }
            else
            {
                [self showNoNetworkAlert];
            }

        }
        else
        {
            UIAlertView *fadingAlert = [[UIAlertView alloc] initWithTitle:@"" message:self.userRerralDetails.statusMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [fadingAlert show];
            [self performSelector:@selector(dissmissAlert:) withObject:fadingAlert afterDelay:ALERT_FADE_DELAY];
        }

    }

}


- (void)showNoNetworkAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:IMNoNetworkErrorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:IMOK
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  Fuction to dissmiss alert
 */
-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

@end
