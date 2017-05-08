//
//  IMPromotionOffer.m
//  InstaMed
//
//  Created by Kavitha on 24/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPromotionOffer.h"
#import "IMCoupon.h"

NSString* const IMPromotionOfferImageURLKey = @"image_url";
NSString* const IMPromotionOfferMainTextKey = @"name";
NSString* const IMPromotionOfferSubTextKey = @"description";
NSString* const IMPromotionOfferCouponKey = @"coupon";


@implementation IMPromotionOffer

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _offerImageURL = dictionary[IMPromotionOfferImageURLKey];
        _mainText = dictionary[IMPromotionOfferMainTextKey];
        _subText = dictionary[IMPromotionOfferSubTextKey];
        // only for applied promotions coupon key will be present
        if (dictionary[IMPromotionOfferCouponKey]) {
            _coupon = [[IMCoupon alloc] initWithDictionary:dictionary[IMPromotionOfferCouponKey]];
        }
    }
    return self;
}

- (BOOL) canShowPromoOffer
{
    return (!self.coupon || self.coupon.hasNoStatus);
}

@end
