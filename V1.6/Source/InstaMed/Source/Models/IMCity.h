//
//  IMCity.h
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMArea.h"

@interface IMCity : IMBaseModel<NSCoding>

@property(nonatomic,strong)NSString* name;
@property(nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSNumber *contactNumber;

@end
