//
//  NSString+IMStringSupport.h
//  InstaMed
//
//  Created by Arjuna on 02/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

@interface NSString (IMStringSupport)

-(NSString*)capitalizeFirstLetter;
-(BOOL)isOnlyWhitespaceCharacters;
-(NSString *) rupeeSymbolPrefixedString;

@end
