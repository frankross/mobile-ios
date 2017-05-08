//
//  IMVariantUtility.h
//  InstaMed
//
//  Created by Kavitha on 02/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

@class IMVarientSelction;
@class IMProduct;

/**
 @class IMVariantUtility
 @brief Utility class for the variants
 */
@interface IMVariantUtility : NSObject

/**
 @brief Returns IMCart object created from the input order and cart operation type
 @param order: IMProduct* object
 @param isPrimary: BOOL Indicates whether the variant is primary or not (The supported variant types are primary and secondary)
 @param currentSelection: NSArray* List of selected variants
 @returns IMVarientSelction*
 */
+(IMVarientSelction*) varientSelectionModelfromProduct:(IMProduct*) product isPrimary:(BOOL)isPrimary currentSelection:(NSArray*) selectedVariants;

@end
