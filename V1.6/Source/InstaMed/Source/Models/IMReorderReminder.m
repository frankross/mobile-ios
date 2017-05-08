//
//  IMReorderReminder.m
//  InstaMed
//
//  Created by Arjuna on 19/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//



#import "IMReorderReminder.h"

@implementation IMReorderReminder


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        if(dictionary[@"reoder_reminder_date"])
        {
            self.date =  [formatter dateFromString:dictionary[@"reoder_reminder_date"]];
            self.duration = dictionary[@"reorder_reminder_duration"];
            self.unit = dictionary[@"reorder_reminder_unit"];
        }
    }
    return self;
}

@end
