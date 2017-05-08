//
//  IMCoupon.m
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCoupon.h"

NSString* const IMCouponIdKey = @"coupon_id";
NSString* const IMCouponCodeKey = @"code";
NSString* const IMCouponMessageKey = @"message";
NSString* const IMCouponStatusKey = @"status";

NSString* const IMCartCouponStatusApplied = @"Applied";
NSString* const IMCartCouponStatusExpired = @"Ineligible";

@implementation IMCoupon

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        self.couponId = dictionary[IMCouponIdKey];
        self.couponCode = dictionary[IMCouponCodeKey];
        self.message = dictionary[IMCouponMessageKey];
        self.status = dictionary[IMCouponStatusKey];
    }
    return self;
}

- (BOOL) isExternallyAppliedCoupon
{
    return (self.couponCode && ![self.couponCode isEqualToString:@""] &&
            self.status && ([self.status caseInsensitiveCompare:IMCartCouponStatusApplied] == NSOrderedSame || [self.status caseInsensitiveCompare:IMCartCouponStatusExpired] == NSOrderedSame));
}

- (BOOL) isApplied
{
    return (self.couponCode && ![self.couponCode isEqualToString:@""] &&
            self.status && ([self.status caseInsensitiveCompare:IMCartCouponStatusApplied] == NSOrderedSame ));
}

- (BOOL) isExpired
{
    return (self.couponCode && ![self.couponCode isEqualToString:@""] &&
            self.status && ([self.status caseInsensitiveCompare:IMCartCouponStatusExpired] == NSOrderedSame));
}

- (BOOL) hasNoStatus
{
    return (!self.status || [self.status isEqualToString:@""]);
}

- (BOOL) hasNoCouponCode
{
    return (!self.couponCode || [self.couponCode isEqualToString:@""]);
}

@end
