//
//  IMApptentiveManager.h
//  InstaMed
//
//  Created by Yusuf Ansar on 31/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

/**
 @brief Class to manage Apptentive SDK related tasks like logging events & handling remote notification functionality.
 */

@interface IMApptentiveManager : NSObject

+ (instancetype)sharedManager;

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo fromViewController:(UIViewController *)viewController;

- (void)logAppLaunchedEventFromViewController:(UIViewController *) viewController;

- (void)logHomeScreenVisitedEventFromViewController:(UIViewController *)viewController;

- (void)logPrescriptionScreenVisitedEventFromViewController:(UIViewController *) viewController;

- (void)logFrankrossWalletScreenVisitedEventFromViewController:(UIViewController *) viewController;

- (void)logOrderCompletionEventWithPaymentMethod:(NSString *) paymentMethod fromViewController:(UIViewController *)viewController;

@end
