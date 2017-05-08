//
//  IMVarientValue.m
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMVarientValue.h"

@implementation IMVarientValue

- (NSString *)description
{
    return [NSString stringWithFormat:@"primary = %@, variant id = %@, secondary = %@, value = %@, isSelected = %d, isSupported = %d", _primaryValue,_varientProductId,_secondaryValue,_valueName,_isSelected,_isSupported];
}
@end
