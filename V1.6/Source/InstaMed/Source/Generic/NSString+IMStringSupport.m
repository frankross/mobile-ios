//
//  NSString+IMStringSupport.m
//  InstaMed
//
//  Created by Arjuna on 02/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "NSString+IMStringSupport.h"

@implementation NSString (IMStringSupport)

-(NSString*)capitalizeFirstLetter
{
   return  [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                       withString:[[self substringToIndex:1] capitalizedString]];
}

-(BOOL)isOnlyWhitespaceCharacters
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return ([trimmedString isEqualToString:@""]);

}

-(NSString *)rupeeSymbolPrefixedString
{
    return [NSString stringWithFormat:@"₹ %@",self];
}
@end
