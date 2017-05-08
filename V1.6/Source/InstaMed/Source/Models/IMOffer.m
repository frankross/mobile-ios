//
//  IMOffer.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOffer.h"

NSString* const IMOfferTypeKey = @"type";
NSString* const IMOfferPromotionIDKey = @"promotion_id";
NSString* const IMOfferImageURLKey = @"url";
NSString* const IMOfferHTMLURLKey = @"html_page";



@implementation IMOffer

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _offerImageURL = dictionary[IMOfferImageURLKey];
        _offerType = dictionary[IMOfferTypeKey];
        _promotionID = dictionary[IMOfferPromotionIDKey];
        _htmlURL = dictionary[IMOfferHTMLURLKey];
//        _htmlURL = @"http://www.emamifrankross.com";
    }
    return self;
}
@end
