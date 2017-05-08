//
//  IMTimeSlot.m
//  InstaMed
//
//  Created by Arjuna on 28/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMTimeSlot.h"

@implementation IMTimeSlot

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.startTime = dictionary[@"start_time"];
        self.endTime = dictionary[@"end_time"];
    }
    return self;
}

-(NSString*)timePeriodStringForHour:(NSNumber*)hour
{
    
    NSString* string = @"noon";
    
    if(hour.integerValue < 12)
    {
        string = @"am";
    }
    else if(hour.integerValue > 12)
    {
        string = @"pm";
    }
    
    NSInteger convertedHour = hour.integerValue;
    
    if(convertedHour > 12)
    {
        convertedHour-=12;
    }
    else if(convertedHour == 0)
    {
        convertedHour = 12;
    }
    
    return [NSString stringWithFormat:@"%ld %@",(long)convertedHour,string];
}


-(NSString*)description
{
    NSString* timeOfDay = @"Morning";
    if([self.startTime integerValue] >= 16)
    {
        timeOfDay = @"Evening";
    }
    else if([self.startTime integerValue] >= 12)
    {
        timeOfDay = @"Afternoon";
    }
    
    return  [NSString stringWithFormat:@"%@(%@ to %@)",timeOfDay,[self timePeriodStringForHour:self.startTime],[self timePeriodStringForHour:self.endTime]];
}

@end
