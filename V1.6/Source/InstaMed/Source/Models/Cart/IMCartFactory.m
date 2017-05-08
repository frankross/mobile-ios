//
//  IMCartFactory.m
//  InstaMed
//
//  Created by Kavitha on 25/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartFactory.h"
#import "IMCart.h"
#import "IMOrderUpdateCart.h"

@implementation IMCartFactory

+(IMCart*) cartForOperationtype:(IMCartOperationType) type details: (NSDictionary*) details{
    IMCart *cart = nil;
    
    switch (type) {
        case IMUpdateOrder:
            cart = [[IMOrderUpdateCart alloc] initWithDictionary:details];
            break;
        
        default:
            cart = [[IMCart alloc] initWithDictionary:details];
            break;
    }
    return cart;
    
}
@end
