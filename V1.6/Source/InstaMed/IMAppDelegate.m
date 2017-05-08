//
//  AppDelegate.m
//  InstaMed
//
//  Created by Suhail K on 13/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "IMConstants.h"
#import "IMSettingsUtility.h"
#import "IMNotification.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityLogger.h"
#import "IMServerManager.h"
#import "IMAccountsManager.h"
#import "IMApptentiveManager.h"
#import "IMHomeViewController.h"
#import "IMPharmacyViewController.h"
#import "IMMoreViewController.h"
#import "IMDeviceManager.h"
#import "IMSettingsUtility.h"
#import "IMFacebookManager.h"
#import "IMLocationManager.h"
#import "IMBranchServiceManager.h"


#define APP_LINK @"itms://itunes.apple.com/in/app/frank-ross-health/id1030305622?mt=8"
//TODO: Reset this for production build
#define TESTING  0
#define NOTIFICATION_ALERT_VIEW_TAG 200

@interface IMAppDelegate ()<UIAlertViewDelegate>


@property (nonatomic) BOOL upgradeLaterSelected;
@property (nonatomic, strong) NSDictionary *notificationPayloadDictionary;
@end

@implementation IMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [self setUpAppWideAppereanceProxyDefaultValue];
    

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    [self configureFlurryAndNewRelic];
    
    [self setRootViewController];
    
    
    //Push notification
    [self registerForPushNotificationUsingApplication:application];



   //if didRecieveRemoteNotification is not getting called , use this code.Getting called when restart app due to PN
    NSDictionary *userInfo =  launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
        [IMFlurry logEvent:IMPushNotificationTapped withParameters:@{}];
        UIViewController *viewController = self.window.rootViewController;
        
        BOOL apptentiveNotification = [[IMApptentiveManager sharedManager] didReceiveRemoteNotification:userInfo
                                                                                    fromViewController:viewController];
        //if it is not from apptentive, handle ourself
        if(!apptentiveNotification)
        {
            self.notificationPayloadDictionary = userInfo;
            [self deepLinkWithUserInfo:self.notificationPayloadDictionary];
        }
    
    }
    application.applicationIconBadgeNumber = 0;
    
    //Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [self initializeBranchSessionWithLaunchOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[IMServerManager sharedManager] checkAPIValiditywithCompletion:^(NSDictionary *infoDictionary, NSError *error)
     {
         if(!error)
         {
             if (TESTING) {
                 [self mockApiStatuscheck];
             }
             else{
                 if([infoDictionary[@"status"] isEqual:@"Live"])
                 {

                     //Action to be done , if we are using latest API
                 }
                 else if ([infoDictionary[@"status"] isEqual:@"EFR:Err:API:DEPRECATED"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMUpgradeNowOrLaterTitle message:IMUpgradeNowOrLaterMessage delegate:self cancelButtonTitle:IMUpgradeNow otherButtonTitles:IMUpgradeLater, nil] ;
                     alert.tag = 100;
                     [alert show];
                 }
                 else if ([infoDictionary[@"status"] isEqual:@"EFR:Err:API:DISCONTINUED"])
                 {
                     UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:IMUpgradeNowTitle message:IMUpgradeNowMessage delegate:self cancelButtonTitle:IMUpgradeNow otherButtonTitles: nil] ;
                     alert.tag = 100;
                     [alert show];
                 }
             }
         }

     }];
    
    // initiate facebook analytics tracking
    [[IMFacebookManager sharedManager] logFacebookActivateAppEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [deviceToken.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device registered for push notification %@",tokenString);
    
    [[IMDeviceManager sharedManager] setDeviceToken:tokenString];
    
    [[IMDeviceManager sharedManager] registerDeviceWithCompletion:^(NSError *error) {
        
    }];
    
    [[IMApptentiveManager sharedManager] registerForRemoteNotificationsWithDeviceToken:deviceToken];
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration for push notification. Error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIViewController *viewController = self.window.rootViewController;
    
    BOOL apptentiveNotification = [[IMApptentiveManager sharedManager] didReceiveRemoteNotification:userInfo
                                                                                 fromViewController:viewController];
    //if it is not from apptentive, handle ourself
    if(!apptentiveNotification)
    {

        self.notificationPayloadDictionary = userInfo;
        
        NSString *message = userInfo[@"aps"][@"alert"];
        
        if (application.applicationState == UIApplicationStateActive)  // when app is active, just show the alert
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        else if(application.applicationState == UIApplicationStateInactive)
        {
            
            [IMFlurry logEvent:IMPushNotificationTapped withParameters:@{}];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMDismissChildViewControllerNotification object:nil];
            [self performSelector:@selector(deepLinkWithUserInfo:) withObject:self.notificationPayloadDictionary afterDelay:0.5];
            
        }
    }


}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:sourceApplication
                               annotation:annotation];
    [[IMBranchServiceManager getBranchInstance] handleDeepLink:url];
    
    if([[url scheme] isEqualToString:@"frankrosshealth"])
    {
        NSDictionary *dict = [self parseQueryString:url];
        
        NSString *screenID = (NSString *)dict[@"screenID"];
        NSString *identifier = (NSString *)dict[@"ID"];
        NSString *pagelink = (NSString *)dict[@"page_link"];
        [self bringAllToTheirInitialScreen];

        // created notification object for deep link
        IMNotification *notification = [[IMNotification alloc] init];
        notification.notificationType = screenID;
        notification.ID = identifier;

        if([screenID isEqualToString:NOTIFICATION_TYPE_EIGHTEEN] && pagelink)
        {

            notification.htmlURL = pagelink;
            [self.tabBarController setSelectedIndex:MoreTabIndex];
            IMMoreViewController *moreVC = (IMMoreViewController *)((UINavigationController *)self.tabBarController.viewControllers[MoreTabIndex]).topViewController;
            [moreVC pushToDetailWithNotification:notification];
        }
        else if(screenID)
        {
            [self.tabBarController setSelectedIndex:HomeTabIndex];
            IMHomeViewController *homeVC = (IMHomeViewController *)((UINavigationController *)self.tabBarController.viewControllers[HomeTabIndex]).topViewController;
            [homeVC pushToDetailWithNotification:notification];
        }

    }

    return  YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    [[IMBranchServiceManager getBranchInstance] continueUserActivity:userActivity];
    return YES;
}


#pragma mark - Private

- (void)setRootViewController
{
    _tabBarController = [[IMTabBarController alloc] init];
    
    [[UITabBar appearance] setTintColor:APP_THEME_COLOR];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    NSMutableArray* viewControllers = [NSMutableArray array];
    
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMMainSBName bundle:nil];
    UIViewController* viewController = [storyboard instantiateInitialViewController];
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"HomeIcon.png"] tag:3];
    [viewControllers addObject:viewController];
    
    storyboard =[UIStoryboard storyboardWithName:IMMainSBName bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"IMPharmaInitialViewController"];
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Categories" image:[UIImage imageNamed:@"pharmacy.png"] tag:3];
    [viewControllers addObject:viewController];
    
    storyboard =[UIStoryboard storyboardWithName:IMAccountSBName bundle:nil];
    viewController = [storyboard instantiateInitialViewController];
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"My Account" image:[UIImage imageNamed:@"AccountIcon.png"] tag:3];
    [viewControllers addObject:viewController];
    
    storyboard =[UIStoryboard storyboardWithName:IMSupportSBName bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"IMSupportInitialViewController"];
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Support" image:[UIImage imageNamed:@"SupportIcon.png"] tag:3];
    [viewControllers addObject:viewController];
    
    storyboard =[UIStoryboard storyboardWithName:IMSupportSBName bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"IMMoreInitialViewController"];
    viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"More" image:[UIImage imageNamed:@"MoreIcon.png"] tag:3];
    [viewControllers addObject:viewController];
    
    [self.tabBarController setViewControllers:viewControllers];
    
    self.window.rootViewController = self.tabBarController;
}


- (void)registerForPushNotificationUsingApplication:(UIApplication *)application
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)initializeBranchSessionWithLaunchOptions:(NSDictionary *)launchOptions
{
    if(![IMSettingsUtility isProduction])
    {
        [[IMBranchServiceManager getBranchInstance] setDebug];
    }
    
    [[IMBranchServiceManager getBranchInstance] initSessionWithLaunchOptions:launchOptions isReferrable:NO andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error)
     {
         BOOL isShownReferralDialog = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShownReferralFailureDialog"];
         if (!error)
         {
             
             if([IMBranchServiceManager shouldShowWelcome:params]) // if it is sucessful referral
             {
                 [IMFlurry logEvent:IMReferFriendSuccess withParameters:@{}];
                 [IMBranchServiceManager showUserWelcomeDialog];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IMSuccessfulReferralPreferenceKey];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShownReferralFailureDialog"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else if([IMBranchServiceManager shouldShowReferralFailureDialog:params] && !isShownReferralDialog)
             {
                 [IMBranchServiceManager showReferralFailureDialog];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShownReferralFailureDialog"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
             }
             else if([IMBranchServiceManager shouldDeeplinkToProductDetail:params])
             {
                 NSString *productID = params[@"variant_id"];
                 NSString *screenType = params[@"product_type"];
                 //
                 NSString *screenID;
                 if([screenType isEqualToString:@"Non pharma"])
                 {
                     screenID = NON_PHARMA_DETAIL;
                 }
                 else if([screenType isEqualToString:@"Pharma"])
                 {
                     screenID = PHARMA_DETAIL;
                 }
                 
                 [self.tabBarController setSelectedIndex:HomeTabIndex];
                 
                 //
                 // created notification object for deep link
                 IMNotification *notification = [[IMNotification alloc] init];
                 notification.notificationType = screenID;
                 notification.ID = productID;
                 if(screenID )
                 {
                     IMCity* currentLocation = [[IMLocationManager sharedManager] currentLocation];
                     
                     if(!currentLocation)
                     {
                         
                         IMHomeViewController *homeVC = (IMHomeViewController *)((UINavigationController *)self.tabBarController.viewControllers[HomeTabIndex]).viewControllers[0];
                         homeVC.isDefferedDeepLinkingLaunch = YES;
                         homeVC.notification = notification;
                     }
                     else
                     {
                         
                         IMHomeViewController *homeVC = (IMHomeViewController *)((UINavigationController *)self.tabBarController.viewControllers[HomeTabIndex]).viewControllers[0];
                         [homeVC pushToDetailWithNotification:notification];
                     }
                     
                 }
                 
                 
             }
         }
         
     }];
    [[IMBranchServiceManager getBranchInstance] accountForFacebookSDKPreventingAppLaunch];
    NSString *userToken = [[IMAccountsManager sharedManager] userToken];
    if(userToken) // if user already logged-in, then set useridentity to branch
    {
        [self setBranchIdentityForLoggedInUser];
    }
}

           
- (void)setBranchIdentityForLoggedInUser
{
    
    NSString *userID = [IMAccountsManager sharedManager].userID;
    if(userID)
    {
        
        [[IMBranchServiceManager getBranchInstance] setIdentity:userID];
    }
    else
    {

        [[IMBranchServiceManager getBranchInstance] logout];
        [[IMAccountsManager sharedManager] fetchUserWithCompletion:^(IMUser *user, NSError *error) {
            if(!error)
            {
                [[IMBranchServiceManager getBranchInstance] setIdentity:[user.identifier stringValue]];
            }
        }];
    
    }
    
}

- (NSDictionary *)parseQueryString:(NSURL *)url
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *components = [url pathComponents];
    if(components.count >= 2)
    {
        if(components[1])
        {
            if([components[1] isEqualToString:@"ppdp"])
            {
                [dict setObject:PHARMA_DETAIL forKey:@"screenID"];
                if (components.count >=3)
                {
                    [dict setObject:components[2] forKey:@"ID"];
                }
            }
            else if ([components[1] isEqualToString:@"npdp"])
            {
                [dict setObject:NON_PHARMA_DETAIL forKey:@"screenID"];
                if (components.count >=3)
                {
                    [dict setObject:components[2] forKey:@"ID"];
                }
            }
            else if([components[1] isEqualToString:@"order"])
            {
                [dict setObject:ORDER_REVISION forKey:@"screenID"];
                if (components.count >=3)
                {
                    [dict setObject:components[2] forKey:@"ID"];
                }
            }
            else if([components[1] isEqualToString:@"prescription"])
            {
                [dict setObject:PRESCRIPTION_DETAIL forKey:@"screenID"];
                if (components.count >=3)
                {
                    [dict setObject:components[2] forKey:@"ID"];
                }
            }
            else if([components[1] isEqualToString:@"cart"])
            {
                [dict setObject:CART_PREPARED_FOR_YOU forKey:@"screenID"];
            }
            else if([components[1] isEqualToString:@"home"])
            {
                [dict setObject:GENERAL_FOR_COMMON forKey:@"screenID"];
            }
            else if([components[1] isEqualToString:@"health_article"])
            {
                [dict setObject:NOTIFICATION_TYPE_EIGHTEEN forKey:@"screenID"];
                NSURLComponents *comp = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
                NSArray *queryItems = comp.queryItems;
                if(queryItems.count > 0)
                {
                    NSURLQueryItem *item = (NSURLQueryItem *)queryItems[0];
                    if([item.name isEqualToString:@"web_page_url"] )
                    {
                        NSString *value = item.value;
                         [dict setObject:value forKey:@"page_link"];
                    }
                   
                }
            }
        }
    }
    return dict;
}


- (void)deepLinkWithUserInfo:(NSDictionary *)dictionary
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    IMNotification *notification = [[IMNotification alloc] initWithDictionary:dictionary];
    NSString *notificationType = notification.notificationType;
    
    [self bringAllToTheirInitialScreen];
        
    switch ([notificationType integerValue])
    {
        case IMHomeNotification:                [self.tabBarController setSelectedIndex:HomeTabIndex];
                                                break;
        case IMCategoryPageNotification:
        case IMCategoryPromotionNotification:
                                            {
                                                [self.tabBarController setSelectedIndex:CategoriesTabIndex];
                                                IMPharmacyViewController *categoryVC = (IMPharmacyViewController *)((UINavigationController *)self.tabBarController.viewControllers[CategoriesTabIndex]).topViewController;
                                                [categoryVC pushToDetailWithNotification:notification];
                                            }
                                            break;
        case IMDigitizationFailedNotification:
        case IMCartPreparedForYouNotification:
        case IMOrderRevisionNotification:
        case IMOrderStatusUpdationNotification:
        case IMGeneralForUserNotification:
        case IMGeneralForCommonNotification:
        case IMPrescriptionDetailNotification:
        case IMPromotionDetailNotification:
        case IMHomePromotionNotification:
        case IMPromotionWebPageNotification:
        case IMProductDetailNotification:
                                            {
                                                [self.tabBarController setSelectedIndex:HomeTabIndex];
                                                IMHomeViewController *homeVC = (IMHomeViewController *)((UINavigationController *)self.tabBarController.viewControllers[HomeTabIndex]).topViewController;
                                                [homeVC pushToDetailWithNotification:notification];
                                            }
                                            break;
        case IMReferAFriendNotification:
        case IMHealthArticlesNotification:
                                            {
                                                [self.tabBarController setSelectedIndex:MoreTabIndex];
                                                IMMoreViewController *moreVC = (IMMoreViewController *)((UINavigationController *)self.tabBarController.viewControllers[MoreTabIndex]).topViewController;
                                                [moreVC pushToDetailWithNotification:notification];
                                            }
            
                                            break;
        default:
            break;
    }
}


- (void) bringAllToTheirInitialScreen
{
    UIViewController *topMostController = [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:CategoriesTabIndex] topViewController];
    [topMostController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:CategoriesTabIndex] popToRootViewControllerAnimated:NO];
    
    
    topMostController = [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:HomeTabIndex] topViewController];
    [topMostController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:HomeTabIndex] popToRootViewControllerAnimated:NO];
    
    topMostController = [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:MYAccountTabIndex] topViewController];
    [topMostController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:MYAccountTabIndex] popToRootViewControllerAnimated:NO];
    
    topMostController = [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:SupportTabIndex] topViewController];
    [topMostController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:SupportTabIndex] popToRootViewControllerAnimated:NO];
    
    topMostController = [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:MoreTabIndex] topViewController];
    [topMostController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [(UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:MoreTabIndex] popToRootViewControllerAnimated:NO];
}

//TODO: Used for testing API status
- (void) mockApiStatuscheck
{
    switch ([IMSettingsUtility apiStatus]) {
            // DEPRECATED
        case 2:
        {
            // no need to display the alert if user has opted for "Upgrade Later" once
            if (self.upgradeLaterSelected) {
                break;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:IMUpgradeNowOrLaterTitle message:IMUpgradeNowOrLaterMessage delegate:self cancelButtonTitle:IMUpgradeNow otherButtonTitles:IMUpgradeLater, nil] ;
            alert.tag = 100;
            [alert show];
            break;
        }
            // DISCONTINUED
        case 3:
        {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:IMUpgradeNowTitle message:IMUpgradeNowMessage delegate:self cancelButtonTitle:IMUpgradeNow otherButtonTitles: nil] ;
            alert.tag = 100;
            [alert show];
            break;
        }
            // Live
        default:
            break;
    }
}

- (void) setUpAppWideAppereanceProxyDefaultValue
{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setBarTintColor:APP_THEME_COLOR];
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [self.window setTintColor:APP_THEME_COLOR];
}

- (void)configureFlurryAndNewRelic
{
    //enable flurry only in production
    if([IMSettingsUtility isProduction])
    {
        [IMFlurry startSession:IMFlurryAPIKey];
        [IMFlurry setEventLoggingEnabled:YES];
        [IMFlurry setDebugLogEnabled:YES];
        [IMFlurry logEvent:IMAppLaunchedEvent withParameters:@{}];
        [IMFlurry setSessionReportsOnPauseEnabled:YES];
        [IMFlurry setSessionReportsOnCloseEnabled:YES];
        [NewRelicAgent startWithApplicationToken:IMRelicAPILiveKey];
    }
    else
    {
        [NewRelicAgent startWithApplicationToken:IMRelicAPITestKey];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(100 == alertView.tag)
    {
        if(0 == buttonIndex)
        {
            NSString *iTunesLink = APP_LINK;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
        else if(1 == buttonIndex){
            self.upgradeLaterSelected = true;
        }
    }
}

@end
