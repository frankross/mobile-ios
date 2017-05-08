//
//  IMVarientSelction.h
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@class IMVarientValue;

@interface IMVarientSelction : IMBaseModel

@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) IMVarientValue *selectedVarient;
@property (nonatomic, strong) NSMutableArray *supportedValues;
@end
