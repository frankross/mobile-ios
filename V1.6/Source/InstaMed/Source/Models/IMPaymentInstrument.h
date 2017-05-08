//
//  IMPaymentInstrument.h
//  InstaMed
//
//  Created by Yusuf Ansar on 06/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMPaymentInstrument : IMBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;

@end
