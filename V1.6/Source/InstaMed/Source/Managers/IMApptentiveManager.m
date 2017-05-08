//
//  IMApptentiveManager.m
//  InstaMed
//
//  Created by Yusuf Ansar on 31/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMConstants.h"
#import "IMApptentiveManager.h"
#import "IMSettingsUtility.h"


static NSString * const IMApptentiveAppLaunchedEvent = @"App_Launched";
static NSString *const IMApptentiveHomeScreenVisitedEvent = @"Home_Screen_Visited";
static NSString * const IMApptentivePrescriptionScreenVisitedEvent = @"Prescriptions_Screen_Visited";
static NSString * const IMApptentiveFrankrossWalletScreenVisitedEvent = @"FR_Wallet_Screen_Visited";
static NSString * const IMApptentiveOrderCompletionEvent = @"Order_Completion";

@interface IMApptentiveManager ()

@property (nonatomic, strong) Apptentive *sharedConnection;

@end

@implementation IMApptentiveManager

+ (instancetype)sharedManager
{
    static IMApptentiveManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.sharedConnection = [Apptentive sharedConnection];
        if([IMSettingsUtility isProduction])
        {
            _sharedInstance.sharedConnection.APIKey = IMApptentiveAPILiveKey;
        }
        else
        {
            _sharedInstance.sharedConnection.APIKey = IMApptentiveAPITestKey;
        }
    });
    
    return _sharedInstance;
}

/**
 @brief To register Apptentive remote notification
 @returns void
 */
- (void) registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.sharedConnection setPushNotificationIntegration:ApptentivePushProviderApptentive withDeviceToken:deviceToken];
}


/**
 @brief To indicate whether recieved notification is from APPtentive
 @returns BOOL
 */
- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo fromViewController:(UIViewController *)viewController
{
   return [self.sharedConnection didReceiveRemoteNotification:userInfo fromViewController:viewController];
}

/**
 @brief To log Applaunched Event
 @returns void
 */
- (void)logAppLaunchedEventFromViewController:(UIViewController *)viewController
{
    [self.sharedConnection engage:IMApptentiveAppLaunchedEvent fromViewController:viewController];
}

/**
 @brief To log Home screen visited Event
 @returns void
 */
- (void)logHomeScreenVisitedEventFromViewController:(UIViewController *)viewController
{
    [self.sharedConnection engage:IMApptentiveHomeScreenVisitedEvent fromViewController:viewController];
}

/**
 @brief To log Prescription screen visited Event
 @returns void
 */
- (void)logPrescriptionScreenVisitedEventFromViewController:(UIViewController *)viewController
{
    [self.sharedConnection engage:IMApptentivePrescriptionScreenVisitedEvent fromViewController:viewController];
}

/**
 @brief To log Frankross wallet screen Event
 @returns void
 */
- (void)logFrankrossWalletScreenVisitedEventFromViewController:(UIViewController *)viewController
{
    [self.sharedConnection engage:IMApptentiveFrankrossWalletScreenVisitedEvent fromViewController:viewController];
}

/**
 @brief To log order completion Event
 @returns void
 */
- (void)logOrderCompletionEventWithPaymentMethod:(NSString *) paymentMethod fromViewController:(UIViewController *)viewController
{
    [self.sharedConnection engage:IMApptentiveOrderCompletionEvent withCustomData:@{@"payment_method" : paymentMethod} fromViewController:viewController];
    
}

@end
