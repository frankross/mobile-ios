//
//  IMOffer.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

extern NSString* const IMOfferImageURLKey;

@interface IMOffer : IMBaseModel

@property (nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* offerImageURL;
@property (nonatomic,strong) NSNumber* promotionID;
@property(nonatomic,strong) NSString* htmlURL;
@property(nonatomic,strong) NSString* offerType;


@end


