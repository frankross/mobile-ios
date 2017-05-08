//
//  IMNotification.m
//  InstaMed
//
//  Created by Yusuf Ansar on 04/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNotification.h"
#import "IMConstants.h"

@implementation IMNotification

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        _ID = dictionary[IMNotificationIDKey];
        _notificationType = [dictionary[IMNotificationTypeKey] stringValue];
        _message = dictionary[IMNotificationAPSKey][IMNotificationMessageKey];
        _couponCode = dictionary[IMNotificationCouponCodeKey];
        _htmlURL = dictionary[IMNotificationHTMLPageURLKey];
        _isPharma = [dictionary[IMNotificationIsPharmaKey] boolValue];
    }
    return self;
}
@end
