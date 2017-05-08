//
//  IMAppSettingsManager.m
//  InstaMed
//
//  Created by Yusuf Ansar on 06/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAppSettingsManager.h"
#import "IMServerManager.h"

//default values
static NSString *const IMAppSharingSubject =  @"Install FrankRoss app now";
static NSString *const IMAppSharingMessage =  @"Install FrankRoss app now ";
static NSString *const IMProductSharingSubject = @"Check out this product on the Frank Ross App ";
static NSString *const IMProductSharingMessage = @"Hey, Click here to check out the <product name> on the Frank Ross App ";
static NSString *const IMAppSharingLinkTitle = @"Check out the Frank Ross App";
static NSString *const IMAppSharingLinkDescription = @"I just ordered using Frank Ross. Download the app now!";
static NSString *const IMAppSharingLinkImageURL = @"https://s3-ap-southeast-1.amazonaws.com/emami-production-2/brand/FRLogo.png";
static NSString *const IMReferralLinkTitle = @"Check out the Frank Ross App";
static NSString *const IMReferralLinkDescription = @"I just ordered using Frank Ross. Download the app now!";
static NSString *const IMReferralLinkImageURL = @"https://s3-ap-southeast-1.amazonaws.com/emami-production-2/brand/FRLogo.png";


//JSON keys
static NSString *const IMAppSettingsKey = @"app_settings";
static NSString *const IMShowRedeemKey = @"show_redeem";
static NSString *const IMAppSharingSubjectKey =  @"app_share_subject";
static NSString *const IMAppSharingMessageKey =  @"app_share_text";
static NSString *const IMProductSharingSubjectKey = @"pdp_share_subject";
static NSString *const IMProductSharingMessageKey = @"pdp_share_text";
static NSString *const IMAppSharingLinkTitleKey = @"app_sharing_link_title";
static NSString *const IMAppSharingLinkDescriptionKey = @"app_sharing_link_description";
static NSString *const IMAppSharingLinkImageURLKey = @"app_sharing_link_image_url";
static NSString *const IMReferralLinkTitleKey = @"referral_link_title";
static NSString *const IMReferralLinkDescriptionKey = @"referral_link_description";
static NSString *const IMReferralLinkImageURLKey = @"referral_link_image_url";


@interface IMAppSettingsManager ()

@property (nonatomic, assign,getter=isShowRedeem) BOOL showRedeem;
@property (nonatomic, strong, readwrite) NSString *appShareSubject;
@property (nonatomic, strong, readwrite) NSString *appShareMessage;
@property (nonatomic, strong, readwrite) NSString *productShareSubject;
@property (nonatomic, strong, readwrite) NSString *productShareMessage;
@property (nonatomic, strong, readwrite) NSString *appSharingLinkTitle;
@property (nonatomic, strong, readwrite) NSString *appSharingLinkDescription;
@property (nonatomic, strong, readwrite) NSString *appSharingLinkImageURL;
@property (nonatomic, strong, readwrite) NSString *referralLinkTitle;
@property (nonatomic, strong, readwrite) NSString *referralLinkDescription;
@property (nonatomic, strong, readwrite) NSString *referralLinkImageURL;

@end

@implementation IMAppSettingsManager

+ (IMAppSettingsManager *)sharedManager
{
    static IMAppSettingsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //set default values
        sharedManager = [[self alloc] init];
        sharedManager.showRedeem = NO;
        sharedManager.appShareSubject = IMAppSharingSubject;
        sharedManager.appShareMessage = IMAppSharingMessage;
        sharedManager.productShareSubject = IMProductSharingSubject;
        sharedManager.productShareMessage = IMProductSharingMessage;
        sharedManager.appSharingLinkTitle = IMAppSharingLinkTitle;
        sharedManager.appSharingLinkDescription = IMAppSharingLinkDescription;
        sharedManager.appSharingLinkImageURL = IMAppSharingLinkImageURL;
        sharedManager.referralLinkTitle = IMReferralLinkTitle;
        sharedManager.referralLinkDescription = IMReferralLinkDescription;
        sharedManager.referralLinkImageURL = IMReferralLinkImageURL;

    });
    return sharedManager;
}


- (BOOL)isShowRedeem
{
    return self.showRedeem;
}


-(void) fetchAppSettingsDetailswithCompletion:(void (^)(NSError *))completion
{
    [[IMServerManager sharedManager] fetchAppSettingsDetailsWithCompletion:^(NSDictionary *appSettingsDictionary, NSError *error) {
        
        if(!error)
        {
            NSDictionary *settingsDictionary = appSettingsDictionary[IMAppSettingsKey];
            self.showRedeem = [settingsDictionary[IMShowRedeemKey] boolValue];
            self.appShareSubject = settingsDictionary[IMAppSharingSubjectKey];
            self.appShareMessage = settingsDictionary[IMAppSharingMessageKey];
            self.productShareSubject = settingsDictionary[IMProductSharingSubjectKey];
            self.productShareMessage = settingsDictionary[IMProductSharingMessageKey];
            self.appSharingLinkTitle = settingsDictionary[IMAppSharingLinkTitleKey];
            self.appSharingLinkDescription = settingsDictionary[IMAppSharingLinkDescriptionKey];
            self.appSharingLinkImageURL = settingsDictionary[IMAppSharingLinkImageURLKey];
            self.referralLinkTitle = settingsDictionary[IMReferralLinkTitleKey];
            self.referralLinkDescription = settingsDictionary[IMReferralLinkDescriptionKey];
            self.referralLinkImageURL = settingsDictionary[IMReferralLinkImageURLKey];
        }
        completion(error);
        
    }];
}

@end
