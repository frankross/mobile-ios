//
//  IMPromotionOffer.h
//  InstaMed
//
//  Created by Kavitha on 24/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@class IMCoupon;

/**
 @brief Class representing the Promotional offer having main promotion text, sub text, promotion image and applied coupon detail.
 */
@interface IMPromotionOffer : IMBaseModel

@property (nonatomic,strong) NSString* mainText;
@property(nonatomic,strong) NSString* subText;
@property(nonatomic,strong) NSString* offerImageURL;
@property(nonatomic,strong) IMCoupon* coupon;
@property (strong, nonatomic) NSString *promoCode;

/**
 @brief Returns a boolean indicating whether the promo offer can be shown or not in the cart screen
 @brief If no coupon or coupon code is empty then YES is returned; else NO is returned
 @returns NSAttributedString*
 */
@property(nonatomic) BOOL canShowPromoOffer;

@end
