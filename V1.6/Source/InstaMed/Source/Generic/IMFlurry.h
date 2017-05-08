//
//  IMFlurry.h
//  InstaMed
//
//  Created by Suhail K on 03/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "Flurry.h"

@interface IMFlurry : NSObject


+ (void)logLoginEventWithType:(NSString *)loginType;
+ (void)logScreenVisitedWithName:(NSString *)screenName;


/*
 optional sdk settings that should be called before start session
 */
+ (void)setAppVersion:(NSString *)version;		// override the app version
+ (NSString *)getFlurryAgentVersion;			// get the Flurry Agent version number
+ (void)setShowErrorInLogEnabled:(BOOL)value;	// default is NO
+ (void)setDebugLogEnabled:(BOOL)value;			// generate debug logs for Flurry support, default is NO
+ (void)setSessionContinueSeconds:(int)seconds; // default is 10 seconds

/*
 start session, attempt to send saved sessions to server
 */
+ (void)startSession:(NSString *)apiKey;

/*
 log events or errors after session has started
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;
+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

/*
 start or end timed events
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;	// non-nil parameters will update the parameters

/*
 count page views
 */
+ (void)logAllPageViews:(id)target;		// automatically track page view on UINavigationController or UITabBarController
+ (void)logPageView;					// manually increment page view by 1

/*
 set user info
 */
+ (void)setUserID:(NSString *)userID;	// user's id in your system
+ (void)setAge:(int)age;				// user's age in years
+ (void)setGender:(NSString *)gender;	// user's gender m or f

/*
 set location information
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(float)horizontalAccuracy verticalAccuracy:(float)verticalAccuracy;

/*
 optional session settings that can be changed after start session
 */
+ (void)setSessionReportsOnCloseEnabled:(BOOL)sendSessionReportsOnClose;	// default is YES
+ (void)setSessionReportsOnPauseEnabled:(BOOL)setSessionReportsOnPauseEnabled;	// default is NO
+ (void)setEventLoggingEnabled:(BOOL)value;
@end
