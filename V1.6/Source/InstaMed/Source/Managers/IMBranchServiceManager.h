//
//  IMBranchServiceManager.h
//  InstaMed
//
//  Created by Yusuf Ansar on 06/06/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "branch.h"
#import "BranchUniversalObject.h"

@class IMProduct;

typedef void (^callbackWithParams) (NSDictionary *params, NSError *error);

/**
 @brief Class to manage Branch related tasks.
 */

@interface IMBranchServiceManager : NSObject

/**
 @brief Returns the shared instance of Branch
 @returns Branch*
 */

+ (Branch *)getBranchInstance;

+ (BOOL)shouldShowWelcome:(NSDictionary *)branchOpts;

+ (BOOL) shouldShowReferralFailureDialog:(NSDictionary *)branchOpts;

+ (BOOL)shouldDeeplinkToProductDetail:(NSDictionary *)branchOpts;


+ (void) shareReferralLinkWithSubject:(NSString *)subject andPromotionalMessage:(NSString *)promotionalMessage completion:(void (^)(NSString *, BOOL))completionHandler;

+ (void) shareProduct:(IMProduct *) product ofType:(NSString *)productType withCompletion:(void (^)(NSString *, BOOL))completionHandler;


+ (void) shareAppWithSubject:(NSString *)subject message:(NSString *)message completion:(void (^)(NSString *, BOOL))completionHandler;

+ (void)getAppSharingURLForChannel:(NSString *)channel withCompletion:(void (^)(NSString *url, NSError *error))completion;


+ (void) showUserWelcomeDialog;
+ (void) showReferralFailureDialog;


+ (void) logBranchRegisterEvent;

@end
