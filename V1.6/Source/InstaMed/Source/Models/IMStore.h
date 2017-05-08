//
//  IMStore.h
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMAddress.h"

@interface IMStore : IMBaseModel

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) IMAddress *address;
@property(nonatomic, strong) NSString *timing;
@property(nonatomic, strong) NSString *kiloMeter;

@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) NSArray *phoneNumbers;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@end
