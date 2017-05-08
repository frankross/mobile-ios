//
//  IMFlurry.m
//  InstaMed
//
//  Created by Suhail K on 03/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFlurry.h"

@implementation IMFlurry


+ (void)logLoginEventWithType:(NSString *)loginType
{

}

+ (void)logScreenVisitedWithName:(NSString *)screenName
{

}

/* Flurry SDK specific calls */

+ (void)setAppVersion:(NSString *)version
{
    [Flurry setAppVersion:version];
}

+ (NSString *)getFlurryAgentVersion
{
    return [Flurry getFlurryAgentVersion];
}

+ (void)setShowErrorInLogEnabled:(BOOL)value
{
    [Flurry setShowErrorInLogEnabled:value];
}

+ (void)setDebugLogEnabled:(BOOL)value
{
    [Flurry setDebugLogEnabled:value];
}

+ (void)setSessionContinueSeconds:(int)seconds
{
    [Flurry setSessionContinueSeconds:seconds];
}

+ (void)startSession:(NSString *)apiKey
{
    [Flurry startSession:apiKey];
}

+ (void)logEvent:(NSString *)eventName
{
    [Flurry logEvent:eventName];
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters
{
    if(![parameters allKeys].count )
    {
           NSLog(@"\n\n*******Loging    %@     *******\n\n\n",eventName );
    }
    else
    {
        NSLog(@"\n\n*******Loging    %@     ******* Parameters     %@ **********\n\n\n",eventName,parameters );
    }

    [Flurry logEvent:eventName withParameters:parameters];
}

+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception
{
    [Flurry logError:errorID message:message exception:exception];
}

+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error
{
    [Flurry logError:errorID message:message error:error];
}

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed
{
    [Flurry logEvent:eventName timed:timed];
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed
{
    if(![parameters allKeys].count )
    {
        NSLog(@"\n\n*******Loging timed Event  %@     *******\n\n\n",eventName );
    }
    else
    {
        NSLog(@"\n\n*******Loging timed Event   %@     ******* Parameters     %@ **********\n\n\n",eventName,parameters );
    }
    [Flurry logEvent:eventName withParameters:parameters timed:timed];
}

+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters
{
    if(![parameters allKeys].count )
    {
        NSLog(@"\n\n*******Ending timed Event  %@     *******\n\n\n",eventName );
    }
    else
    {
        NSLog(@"\n\n*******Ending timed Event   %@     ******* Parameters     %@ **********\n\n\n",eventName,parameters );
    }
    [Flurry endTimedEvent:eventName withParameters:parameters];
}

+ (void)logAllPageViews:(id)target
{
    [Flurry logAllPageViewsForTarget:target];
}

+ (void)logPageView
{
    [Flurry logPageView];
}

+ (void)setUserID:(NSString *)userID
{
    [Flurry setUserID:userID];
}

+ (void)setAge:(int)age
{
    [Flurry setAge:age];
}

+ (void)setGender:(NSString *)gender
{
    [Flurry setGender:gender];
}

+ (void)setLatitude:(double)latitude longitude:(double)longitude horizontalAccuracy:(float)horizontalAccuracy verticalAccuracy:(float)verticalAccuracy
{
    [Flurry setLatitude:latitude longitude:longitude horizontalAccuracy:horizontalAccuracy verticalAccuracy:verticalAccuracy];
}

+ (void)setSessionReportsOnCloseEnabled:(BOOL)sendSessionReportsOnClose
{
    [Flurry setSessionReportsOnCloseEnabled:sendSessionReportsOnClose];
}

+ (void)setSessionReportsOnPauseEnabled:(BOOL)setSessionReportsOnPauseEnabled
{
    [Flurry setSessionReportsOnPauseEnabled:setSessionReportsOnPauseEnabled];
}

+ (void)setEventLoggingEnabled:(BOOL)value
{
    [Flurry setEventLoggingEnabled:value];
}
@end
