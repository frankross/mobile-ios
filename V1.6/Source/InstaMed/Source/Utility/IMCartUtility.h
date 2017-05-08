//
//  IMCartUtility.h
//  InstaMed
//
//  Created by Kavitha on 25/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

#import "IMCart.h"
#import "IMOrder.h"

/**
 @class IMCartUtility
 @brief Utility class for the cart
 */
@interface IMCartUtility : NSObject

/**
 @brief Returns IMCart object created from the input order and cart operation type
 @param order: IMOrder* object
 @param type: IMCartOperationType (new cart, revise cart)
 @returns IMCart*
 */
+(IMCart*)getCartFromOrder:(IMOrder*)order forType:(IMCartOperationType)type;

/**
 @brief Bolds a part of string in the input string parameter
 @param bold: NSString* strings to bold
 @param fullString: NSString* string in which a part of string needs to be bold
 @returns NSAttributedString*
 */
+ (NSAttributedString*) bold:(NSString*) boldString inText:(NSString*) fullString;

/**
 @brief Applies paragraph style to the bulleted string
 @param paragraph: NSString* strings to apply paragraph style
 @returns NSAttributedString*
 */
+ (NSAttributedString*) bulletedParagraphString:(NSString*) paragraph;

/**
 @brief Returns the crossed out text created from the input string parameter
 @param textToStrikeThrough: NSString* strings to strike through
 @returns NSAttributedString*
 */
+ (NSAttributedString*) strikeThroughText:(NSString*) textToStrikeThrough;

@end
