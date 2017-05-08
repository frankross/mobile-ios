//
//  IMAddress.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "IMCity.h"

@interface IMAddress : IMBaseModel

@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* addressLine1;
@property(nonatomic,strong) NSString* addressLine2;
@property(nonatomic,strong) NSString* landmark;
@property(nonatomic,strong)NSNumber* pinCode;
@property(nonatomic,strong)IMCity* city;
@property(nonatomic,strong)NSString* phoneNumber;
@property(nonatomic,strong)NSString* tag;
@property(nonatomic) BOOL isDefault;
@property(nonatomic) BOOL isLastDelivered;
@property(nonatomic,strong)NSNumber* areaID;
@property(nonatomic,strong)NSString* cityName;

@property(nonatomic) BOOL isActive;

- (NSDictionary *)dictinaryRepresentation;
-(NSDictionary*)dictionaryForDefaultAddress;

@end
