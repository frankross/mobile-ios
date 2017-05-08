//
//  IMCoupon.h
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMBaseModel.h"

/**
 @brief Class representing the Coupon having coupon code, id, status and message detail.
 */
@interface IMCoupon : IMBaseModel

@property (strong, nonatomic) NSString *couponId;
@property (strong, nonatomic) NSString *couponCode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *status;
@property (nonatomic) BOOL isExternallyAppliedCoupon;
@property (nonatomic) BOOL isApplied;
@property (nonatomic) BOOL isExpired;
@property (nonatomic) BOOL hasNoStatus;
@property (nonatomic) BOOL hasNoCouponCode;

@end
