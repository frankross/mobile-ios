//
//  IMPayment.h
//  InstaMed
//
//  Created by Yusuf Ansar on 03/06/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMPayment : IMBaseModel

@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSString *paymentInstrument;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *status;

@end
