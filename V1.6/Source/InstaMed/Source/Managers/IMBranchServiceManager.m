//
//  IMBranchServiceManager.m
//  InstaMed
//
//  Created by Yusuf Ansar on 06/06/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBranchServiceManager.h"
#import "IMConstants.h"
#import "IMSettingsUtility.h"
#import "IMAppDelegate.h"
#import "IMAccountsManager.h"
#import "IMAppSettingsManager.h"

#import "IMProduct.h"


extern NSString * const BRANCH_LINK_DATA_KEY_EMAIL_SUBJECT;
NSString *const IMBranchAppReferralFeature =  @"referral";
NSString *const IMBranchRegisterEvent = @"registered";

@interface IMBranchServiceManager ()

@property (nonatomic, strong) NSDictionary *userParametersDictionary;

@end



@implementation IMBranchServiceManager

/**
 @brief Returns the shared instance of Branch
 @returns Branch*
 */

+ (Branch *)getBranchInstance
{
    
    if([IMSettingsUtility isProduction])
    {
        
        return [Branch getInstance];
    }
    else
    {
        return [Branch getTestInstance];
    }
}


/**
 @brief condition to show Referral success dialog
 @returns BOOL
 */
+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts {
    return [branchOpts[BRANCH_INIT_KEY_IS_FIRST_SESSION] boolValue] && branchOpts[BRANCH_USER_ID_KEY] != nil && branchOpts[BRANCH_USER_FULLNAME_KEY] != nil && ![[self getBranchInstance] isUserIdentified];
    
}


/**
 @brief condition to show Referral failure dialog
 @returns BOOL
 */
+ (BOOL)shouldShowReferralFailureDialog:(NSDictionary *)branchOpts
{
        return ![branchOpts[BRANCH_INIT_KEY_IS_FIRST_SESSION] boolValue] && branchOpts[BRANCH_USER_ID_KEY] != nil && branchOpts[BRANCH_USER_FULLNAME_KEY] != nil && ![[self getBranchInstance] isUserIdentified];
}


/**
 @brief condition to deeplink to product deatil
 @returns BOOL
 */
+ (BOOL)shouldDeeplinkToProductDetail:(NSDictionary *)branchOpts
{
    return [branchOpts[@"+clicked_branch_link"] boolValue] && [branchOpts[@"~feature"] isEqualToString:@"Product share"] && branchOpts[@"variant_id"] != nil && branchOpts[@"product_type"] != nil;
}


/**
 @brief function to share app referral link using Branch
 @returns void
 */
+ (void) shareReferralLinkWithSubject:(NSString *)subject andPromotionalMessage:(NSString *)promotionalMessage completion:(void (^)(NSString *, BOOL))completionHandler
{

    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = IMBranchAppReferralFeature;
    [linkProperties addControlParam:BRANCH_LINK_DATA_KEY_EMAIL_SUBJECT withValue:subject];
    
    BranchUniversalObject *obj = [[BranchUniversalObject alloc] initWithTitle:@"App Invite"];
    obj.title = [IMAppSettingsManager sharedManager].referralLinkTitle;
    obj.contentDescription = [IMAppSettingsManager sharedManager].referralLinkDescription;
    obj.imageUrl = [IMAppSettingsManager sharedManager].referralLinkImageURL;
    
    [obj addMetadataKey:BRANCH_USER_ID_KEY value:[[IMAccountsManager sharedManager] userID]];
    [obj addMetadataKey:BRANCH_USER_FULLNAME_KEY value:[[IMAccountsManager sharedManager] userName]];
    [obj addMetadataKey:BRANCH_USER_SHORT_NAME_KEY value:@""];
    [obj addMetadataKey:BRANCH_USER_IMAGE_URL_KEY value:@""];
    
    IMAppDelegate *appDelegate = (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
    UIViewController *presentingController = appDelegate.window.rootViewController;


    [obj showShareSheetWithLinkProperties:linkProperties andShareText:promotionalMessage fromViewController:presentingController completion:^(NSString *activityType, BOOL completed) {
        if (completionHandler) {
            completionHandler(activityType, completed);
        }
        
    }];


}

/**
 @brief function to share product using Branch
 @returns void
 */
+ (void) shareProduct:(IMProduct *) product ofType:(NSString *)productType withCompletion:(void (^)(NSString *, BOOL))completionHandler
{
    
    NSString *sharingSubject = [[IMAppSettingsManager sharedManager] productShareSubject];
    NSString *sharingMessage  = [[IMAppSettingsManager sharedManager] productShareMessage];
    sharingSubject = [sharingSubject stringByReplacingOccurrencesOfString:IMProductNamePlaceHolder withString:product.name];
    sharingMessage = [sharingMessage stringByReplacingOccurrencesOfString:IMProductNamePlaceHolder withString:product.name];
    sharingMessage = [sharingMessage stringByReplacingOccurrencesOfString:IMProductLinkPlaceHolder withString:@""];
    
    
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"Product share";
    [linkProperties addControlParam:BRANCH_LINK_DATA_KEY_EMAIL_SUBJECT withValue:sharingSubject];
    [linkProperties addControlParam:@"$always_deeplink" withValue:@"true"];
    

    
    BranchUniversalObject *obj = [[BranchUniversalObject alloc] init];
    obj.title = product.name;
    obj.contentDescription = product.variantDescription;
    if(product.imageURRLs.count > 0)
    {
        NSString *imageURL = product.imageURRLs[0];
        obj.imageUrl = [imageURL stringByReplacingOccurrencesOfString:@"/normal/" withString:@"/small/"];
    }
    
     ;
    [obj addMetadataKey:@"variant_id" value:[product.identifier stringValue]];
    [obj addMetadataKey:@"product_type" value:productType];
    
    
    IMAppDelegate *appDelegate = (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
    UIViewController *presentingController = appDelegate.window.rootViewController;
    
    
    [obj showShareSheetWithLinkProperties:linkProperties andShareText:sharingMessage fromViewController:presentingController completion:^(NSString *activityType, BOOL completed) {
        if (completionHandler) {
            [IMFlurry logEvent:IMPDPSharingMediumTapped withParameters:@{ @"Sharing_Channel" : activityType }];
            completionHandler(activityType, completed);
            
        }
        
    }];
}


/**
 @brief function to share app using BRanch
 @returns void
 */
+ (void) shareAppWithSubject:(NSString *)subject message:(NSString *)message completion:(void (^)(NSString *, BOOL))completionHandler
{
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"App share";
    
    [linkProperties addControlParam:@"$always_deeplink" withValue:@"true"];
    [linkProperties addControlParam:BRANCH_LINK_DATA_KEY_EMAIL_SUBJECT withValue:subject];
    
    BranchUniversalObject *obj = [[BranchUniversalObject alloc] init];
    obj.title = [IMAppSettingsManager sharedManager].appSharingLinkTitle;
    obj.contentDescription = [IMAppSettingsManager sharedManager].appSharingLinkDescription;
    obj.imageUrl = [IMAppSettingsManager sharedManager].appSharingLinkImageURL;
    
    
    
    IMAppDelegate *appDelegate = (IMAppDelegate *) [[UIApplication sharedApplication] delegate];
    UIViewController *presentingController = appDelegate.window.rootViewController;
    
    
    [obj showShareSheetWithLinkProperties:linkProperties andShareText:message fromViewController:presentingController completion:^(NSString *activityType, BOOL completed) {
        if (completionHandler) {
            [IMFlurry logEvent:IMOrderSharingMoreMediumSelected withParameters:@{ @"Sharing_Channel" : activityType }];
            completionHandler(activityType, completed);
        }
        
    }];
}


/**
 @brief function to get app sharing link from Branch
 @returns void
 */

+ (void)getAppSharingURLForChannel:(NSString *)channel withCompletion:(void (^)(NSString *url, NSError *error))completion
{
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"App share";
    [linkProperties addControlParam:@"$always_deeplink" withValue:@"true"];
    
    
    BranchUniversalObject *obj = [[BranchUniversalObject alloc] init];
    obj.title = [IMAppSettingsManager sharedManager].appSharingLinkTitle;
    obj.contentDescription = [IMAppSettingsManager sharedManager].appSharingLinkDescription;
    obj.imageUrl = [IMAppSettingsManager sharedManager].appSharingLinkImageURL;

    [obj getShortUrlWithLinkProperties:linkProperties andCallback:^(NSString *url, NSError *error) {
        if(!error)
        {
            completion(url,error);
        }
    }];
}

/**
 @brief function to show referral succussfull dialog
 @returns void
 */
+ (void) showUserWelcomeDialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:IMReferralSuccessMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil];
    [alert show];
}

/**
 @brief function to show referral failure dialog
 @returns void
 */
+ (void) showReferralFailureDialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:IMReferralFailureMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil];
    [alert show];
}


/**
 @brief function to log Branch register Event
 @returns void
 */
+ (void) logBranchRegisterEvent
{
    [[self getBranchInstance] userCompletedAction:IMBranchRegisterEvent];
}


@end
