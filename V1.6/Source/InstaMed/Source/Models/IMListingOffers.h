//
//  IMListingOffers.h
//  InstaMed
//
//  Created by Yusuf Ansar on 21/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMListingOffers : IMBaseModel


@property (nonatomic, strong) NSString *offerImageURL;
@property (nonatomic, strong) NSNumber *promotionID;
@property (nonatomic, strong) NSString *htmlURL;
@property (nonatomic, strong) NSString *couponCode;
@property (nonatomic, assign,getter=isListable) BOOL listable;
@end
