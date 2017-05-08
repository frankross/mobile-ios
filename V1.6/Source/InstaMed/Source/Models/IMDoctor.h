//
//  IMDoctor.h
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMAddress.h"

@interface IMDoctor : IMBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *regNumber;
@property (strong, nonatomic) NSString *speciality;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *facility;
@property (strong, nonatomic) NSString *address;

@end
