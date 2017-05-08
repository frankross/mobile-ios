//
//  IMProductDosage.m
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProductDosage.h"

@implementation IMProductDosage

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.identifier = dictionary[@"variant_id"];
        self.productName = dictionary[@"medicineName"];
        self.quantity = dictionary[@"quantity"];
        self.foodInstruction = dictionary[@"food_instruction"];
        self.duration = dictionary[@"duration"];
        self.specificTimings = dictionary[@"specific_timings"];
        self.frequency = dictionary[@"frequency"];;
        self.timeMorning = [dictionary[@"time_morning"] boolValue];
        self.timeAfternoon =  [dictionary[@"time_afternoon"] boolValue];
        self.timeEvening =  [dictionary[@"time_evening"] boolValue];
        self.timeNight = [dictionary[@"time_night"] boolValue];
        self.sos = [dictionary[@"sos"] boolValue];
        self.remarks = dictionary[@"remarks"];
    }
    return self;
}
@end
