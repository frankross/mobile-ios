//
//  IMSplashScreen.m
//  InstaMed
//
//  Created by Arjuna on 11/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSplashScreen.h"
#import "IMLocationManager.h"
#import "IMSetLocationViewController.h"
#import "IMAppDelegate.h"

static NSString* const IMSetLocationSegue = @"setLocationSegue";

static NSInteger IMOnlyOneCitySupportedAlertTag = 1;
static NSInteger IMLocationSupportedFailedAlertTag = 2;

@interface IMSplashScreen()<UIAlertViewDelegate>

@end

@implementation IMSplashScreen

-(void)loadUI
{
    self.navigationController.navigationBarHidden = YES;
    IMCity* currentLocation = [[IMLocationManager sharedManager] currentLocation];
    
    if(currentLocation)
    {
        ((IMAppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];

        self.navigationController.navigationBarHidden = NO;
    }
    else
    {
        [self downloadFeed];
    }
}

-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMLocationManager sharedManager] fetchDeliverySupportedLocationsAndCurrentLocationWithCompletion:^(NSArray *deliveryLocations, IMCity *currentCity, NSError *error) {
        [self hideActivityIndicatorView];
        
        if(deliveryLocations)
        {
            if(deliveryLocations.count == 1)
            {
                [IMLocationManager sharedManager].currentLocation = currentCity;
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Frank Ross currently delivers in %@",currentCity.name ] message:@"More cities coming soon." delegate:self cancelButtonTitle:IMOK otherButtonTitles:nil];
                alertView.tag = IMOnlyOneCitySupportedAlertTag;
                [alertView show];
            }
            else
            {
                self.modelArray = [deliveryLocations mutableCopy];
                self.selectedModel = currentCity;
                [self updateUI];
            }
        }
        else
        {
            [self showSuppotedLocationsFetchFailedAlert];
        }
    }];

}

-(void)updateUI
{
    [self performSegueWithIdentifier:IMSetLocationSegue sender:self];
}

-(void)showSuppotedLocationsFetchFailedAlert
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error while fetching data" message:@"Error while fetching supported cities." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
    alertView.tag = IMLocationSupportedFailedAlertTag;
    [alertView show];
}

#pragma mark - UIAlertView Delegate Methods -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == IMOnlyOneCitySupportedAlertTag)
    {
        self.navigationController.navigationBarHidden = NO;
         self.view.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
    }
    else if(alertView.tag == IMLocationSupportedFailedAlertTag)
    {
        [self showSuppotedLocationsFetchFailedAlert];
    }
}

#pragma mark - Navigation -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBarHidden = NO;

    if([segue.identifier isEqualToString:IMSetLocationSegue])
    {
        ((IMSetLocationViewController*)segue.destinationViewController).modelArray = self.modelArray;
        ((IMSetLocationViewController*)segue.destinationViewController).selectedModel = self.selectedModel;
    }
}

@end
