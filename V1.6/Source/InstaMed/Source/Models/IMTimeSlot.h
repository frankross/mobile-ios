//
//  IMTimeSlot.h
//  InstaMed
//
//  Created by Arjuna on 28/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMTimeSlot : IMBaseModel

@property (nonatomic,strong) NSNumber* startTime;
@property (nonatomic,strong) NSNumber* endTime;

@end
