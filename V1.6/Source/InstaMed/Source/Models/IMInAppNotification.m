//
//  IMInAppNotification.m
//  InstaMed
//
//  Created by Yusuf Ansar on 24/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMInAppNotification.h"

static NSString *const IMInAppNotificationDateFormatString = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";


static NSString *const IMInAppNotificationTypeKey = @"notification_type";
static NSString *const IMInAppNotificationTitleKey = @"header";
static NSString *const IMInAppNotificationMessageKey = @"message";
static NSString *const IMInAppNotificationSentDateKey = @"sent_at";
static NSString *const IMInAppNotificationPayloadKey = @"payload";
static NSString *const IMInAppNotificationPromotionIDKey = @"promotion_id";
static NSString *const IMInAppNotificationCategoryIDKey = @"category_id";
static NSString *const IMInAppNotificationVariantIDKey = @"variant_id";
static NSString *const IMInAppNotificationPrescriptionIDKey = @"prescription_id";
static NSString *const IMInAppNotificationOrderIDKey = @"order_id";
static NSString *const IMInAppNotificationCouponCodeKey = @"coupon_code";
static NSString *const IMInAppNotificationImageURLKey = @"image_url";
static NSString *const IMInAppNotificationHTMLURLKey = @"page_link";
static NSString *const IMInAppNotificationIsPharmaKey = @"is_pharma";


@implementation IMInAppNotification


-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _notificationType = [dictionary[IMInAppNotificationTypeKey] integerValue];
        _title = dictionary[IMInAppNotificationTitleKey];
        _message = dictionary[IMInAppNotificationMessageKey];
        
        NSString *dateString = dictionary[IMInAppNotificationSentDateKey];
        _sentDate = [self formattedDateFromDateString:dateString];
        
        NSDictionary *payloadDictionary = dictionary[IMInAppNotificationPayloadKey];
        
        _promotionID = payloadDictionary[IMInAppNotificationPromotionIDKey];
        _categoryID = payloadDictionary[IMInAppNotificationCategoryIDKey];
        _variantID = payloadDictionary[IMInAppNotificationVariantIDKey];
        _prescriptionID = payloadDictionary[IMInAppNotificationPrescriptionIDKey];
        _orderID = payloadDictionary[IMInAppNotificationOrderIDKey];
        _couponCode = payloadDictionary[IMInAppNotificationCouponCodeKey];
        _imageURL = payloadDictionary[IMInAppNotificationImageURLKey];
        _htmlURL = payloadDictionary[IMInAppNotificationHTMLURLKey];
        _isPharma = [payloadDictionary[IMInAppNotificationIsPharmaKey] boolValue];
        
    }
    return self;
}


- (NSDate *) formattedDateFromDateString:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = IMInAppNotificationDateFormatString;
    return [dateFormatter dateFromString:dateString];
}

@end
