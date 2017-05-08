//
//  IMOrderPrescription.h
//  InstaMed
//
//  Created by Suhail K on 30/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMOrderPrescription: IMBaseModel

@property (strong, nonatomic) NSString *escalationReason;
@property (nonatomic,strong) NSString* imageUrlStr;

@end
