//
//  IMListingOffers.m
//  InstaMed
//
//  Created by Yusuf Ansar on 21/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMListingOffers.h"

NSString* const IMListingOfferPromotionIDKey = @"promotion_id";
NSString* const IMListingOfferImageURLKey = @"image_url";
NSString* const IMListingOfferHTMLURLKey = @"html_link";
NSString* const IMListingOfferCouponCodeKey = @"coupon_code";
NSString* const IMListingOfferListableKey = @"listable";

@implementation IMListingOffers


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _offerImageURL = dictionary[IMListingOfferImageURLKey];
        _promotionID = dictionary[IMListingOfferPromotionIDKey];
        _htmlURL = dictionary[IMListingOfferHTMLURLKey];
        _couponCode = dictionary[IMListingOfferCouponCodeKey];
        _listable = [dictionary[IMListingOfferListableKey] boolValue];
    }
    return self;
}


@end
