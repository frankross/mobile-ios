//
//  IMVariantUtility.m
//  InstaMed
//
//  Created by Kavitha on 25/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSettingsUtility.h"

//Change PRODUCTION to 0 for staging build
#define PRODUCTION  1

NSString* const IMAlgoliaIndexSuffixStaging = @"staging_1_";//ka staging index
NSString* const IMAlgoliaIndexSuffixProduction = @"production";//ka production

//staging app base URL
NSString* const IMBaseURLStaging = @"https://staging.frankross.in/api/";

//production app base URL
NSString* const IMBaseURLProduction = @"https://www.frankross.in/api/";


NSString* const IMPrivacyUrlStaging = @"https://staging.frankross.in/privacy_policy.html";
NSString* const IMPrivacyUrlProduction = @"https://www.frankross.in/privacy_policy.html"; // production

NSString* const IMBaseUrlPreferenceId = @"base_url";
NSString* const IMPrivacyUrlPreferenceId = @"privacy_url";
NSString* const IMalgoliaPreferenceId = @"algolia_index";
NSString* const IMApiStatusId = @"api_status";


//paytm
NSString* const IMPayTMStagingChecksumURL = @"https://frankross-pr-1091.herokuapp.com/paytm/generate_checksum";
NSString* const IMPayTMStagingValidationURL = @"https://frankross-pr-1091.herokuapp.com/paytm/verify_checksum";

NSString* const IMPayTMProductionChecksumURL = @"https://www.frankross.in/paytm/generate_checksum";
NSString* const IMPayTMProductionValidationURL = @"https://www.frankross.in/paytm/verify_checksum";

//PayTM related


//staging
NSString* const IMStagingMerchantID = @"EMAMIF27433313344162";
NSString* const IMStagingChannelID = @"WAP";
NSString* const IMStagingIndustryType = @"Retail";
NSString* const IMStagingWebsite = @"EmamifrankWAP";


//production
NSString* const IMProductionMerchantID = @"frankr25616696649223";
NSString* const IMProductionChannelID = @"WAP";
NSString* const IMProductionIndustryType = @"Retail92";
NSString* const IMProductionWebsite = @"Emamiwap";


@implementation IMSettingsUtility

+ (NSString*) baseUrl{
    NSString *baseServerUrl = (PRODUCTION == 1)?IMBaseURLProduction:IMBaseURLStaging;
    NSString *urlValue = [[NSUserDefaults standardUserDefaults] objectForKey:IMBaseUrlPreferenceId];
    if (urlValue != nil && urlValue.length > 0) {
        baseServerUrl = urlValue;
    }
    return baseServerUrl;
}

+ (NSString*) privacyUrl{
    NSString *privacyUrl = (PRODUCTION == 1)?IMPrivacyUrlProduction:IMPrivacyUrlStaging;
    NSString *privacyUrlValue = [[NSUserDefaults standardUserDefaults] objectForKey:IMPrivacyUrlPreferenceId];
    if (privacyUrlValue != nil && privacyUrlValue.length > 0) {
        privacyUrl = privacyUrlValue;
    }
    return privacyUrl;
}

+ (NSString*) algoliaIndexSuffix{
    NSString *algoliaIndex = (PRODUCTION == 1)?IMAlgoliaIndexSuffixProduction:IMAlgoliaIndexSuffixStaging;
    NSString *algoliaValue = [[NSUserDefaults standardUserDefaults] objectForKey:IMalgoliaPreferenceId];
    if (algoliaValue != nil && algoliaValue.length > 0) {
        algoliaIndex = algoliaValue;
    }
    return algoliaIndex;
}

+ (NSUInteger) apiStatus{
    NSUInteger apiStatus = 1;
    NSString *apiStatusValue = [[NSUserDefaults standardUserDefaults] objectForKey:IMApiStatusId];
    if (apiStatusValue != nil && apiStatusValue.length > 0) {
        apiStatus = [apiStatusValue integerValue];
    }
    return apiStatus;
}


+ (BOOL) isProduction
{
    return (PRODUCTION == 1) ? YES:NO;
}

+ (NSString *) getpayTMCheckSumURL
{
    NSString *baseDomainUrlString = [self baseUrl];
    NSURL* url = [NSURL URLWithString:baseDomainUrlString];
    NSString* domain = [url host];
    NSString *checksumUrl = [NSString stringWithFormat:@"https://%@/paytm/generate_checksum",domain];
    return checksumUrl;
}

+ (NSString *) getpayTMCheckSumValidationURL
{
    NSString *baseDomainUrlString = [self baseUrl];
    NSURL* url = [NSURL URLWithString:baseDomainUrlString];
    NSString* domain = [url host];
    NSString *validationUrl = [NSString stringWithFormat:@"https://%@/paytm/verify_checksum",domain];
    return validationUrl;
}

+ (NSString *) getpayTMMerchantID
{
    NSString *merchantID = (PRODUCTION == 1)?IMProductionMerchantID :IMStagingMerchantID;
    return merchantID;
}

+ (NSString *) getpayTMChannelID
{
    NSString *channelID = (PRODUCTION == 1)?IMProductionChannelID :IMStagingChannelID;
    return channelID;
}

+ (NSString *) getpayTMIndustryType
{
    NSString *industryType = (PRODUCTION == 1)?IMProductionIndustryType :IMStagingIndustryType;
    return industryType;
}

+ (NSString *) getpayTMWebsite
{
    NSString *merchantID = (PRODUCTION == 1)?IMProductionWebsite :IMStagingWebsite;
    return merchantID;
}


@end
