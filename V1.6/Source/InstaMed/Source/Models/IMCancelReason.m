//
//  IMCancelReason.m
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCancelReason.h"

@implementation IMCancelReason

-(NSDictionary*)dictionaryForCancelling
{
    return @{@"reason":self.reason,@"remarks":self.remarks};
}


@end
