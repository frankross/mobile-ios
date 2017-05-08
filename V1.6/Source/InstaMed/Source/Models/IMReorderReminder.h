//
//  IMReorderReminder.h
//  InstaMed
//
//  Created by Arjuna on 19/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMReorderReminder : IMBaseModel

@property (nonatomic,strong) NSDate* date;
@property (nonatomic,strong) NSNumber* duration;
@property (nonatomic,strong) NSString* unit;

@end
