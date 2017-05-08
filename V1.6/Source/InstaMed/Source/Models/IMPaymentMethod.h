//
//  IMPaymentMethod.h
//  InstaMed
//
//  Created by Yusuf Ansar on 06/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMPaymentMethod : IMBaseModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *paymentInstruments;
@property (nonatomic, assign) BOOL isPrepaid;

@end
