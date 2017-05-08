//
//  IMVarientValue.h
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMVarientValue : IMBaseModel

@property (nonatomic, strong)NSNumber * varientProductId;
@property (nonatomic, strong)NSString * primaryValue;
@property (nonatomic, strong)NSString * secondaryValue;
@property (nonatomic, strong)NSString * valueName;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isSupported;
@property (nonatomic, strong) NSString *attribute;


@end
