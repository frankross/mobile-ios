//
//  IMVarients.h
//  InstaMed
//
//  Created by Suhail K on 13/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMVarient : IMBaseModel

//@property (nonatomic,strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSMutableArray *supportedValues;


@end
