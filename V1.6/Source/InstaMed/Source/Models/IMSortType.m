//
//  IMSortType.m
//  InstaMed
//
//  Created by Arjuna on 08/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSortType.h"

@implementation IMSortType

-(BOOL)isEqual:(IMSortType*)object
{
    return [self.name isEqual:object.name];
}
@end
