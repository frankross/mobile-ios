//
//  IMPatient.h
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMPatient : IMBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *gender;



@end
