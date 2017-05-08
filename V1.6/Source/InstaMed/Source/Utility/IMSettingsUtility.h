//
//  IMVariantUtility.h
//  InstaMed
//
//  Created by Kavitha on 25/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//



#import <Foundation/Foundation.h>

/**
 @class IMSettingsUtility
 @brief Utility class for the settings
 */
@interface IMSettingsUtility : NSObject

/**
 @brief Returns server base url
 @returns NSString*
 */
+ (NSString*) baseUrl;

/**
 @brief Returns app privacy url
 @returns NSString*
 */
+ (NSString*) privacyUrl;

/**
 @brief Returns algolia index string
 @returns NSString*
 */
+ (NSString*) algoliaIndexSuffix;

/**
 @brief Returns API status (Live, discontinued, deprecated)
 @returns NSString*
 */
+ (NSUInteger) apiStatus;

+ (BOOL) isProduction;

+ (NSString *) getpayTMCheckSumURL;


+ (NSString *) getpayTMCheckSumValidationURL;

+ (NSString *) getpayTMMerchantID;
+ (NSString *) getpayTMChannelID;
+ (NSString *) getpayTMIndustryType;
+ (NSString *) getpayTMWebsite;

@end
