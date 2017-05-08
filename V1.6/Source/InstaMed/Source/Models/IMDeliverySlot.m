//
//  IMDeliverySlot.m
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDeliverySlot.h"

@implementation IMDeliverySlot

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.slotId = dictionary[@"slot_id"];
        NSDateFormatter* dateFormatter =  [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.slotDate =  [dateFormatter dateFromString:dictionary[@"slot_date"]] ;
        self.slotDescription = dictionary[@"slot_description"] ;
        
    }
    return self;
}

@end
