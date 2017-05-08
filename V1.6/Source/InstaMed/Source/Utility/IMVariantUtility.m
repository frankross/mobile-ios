//
//  IMVariantUtility.m
//  InstaMed
//
//  Created by Kavitha on 02/09/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMVariantUtility.h"
#import "IMVarientSelction.h"
#import "IMVariationTheme.h"
#import "IMProduct.h"
#import "IMVarientValue.h"

@implementation IMVariantUtility

+(IMVarientSelction*) varientSelectionModelfromProduct:(IMProduct*) product isPrimary:(BOOL)isPrimary currentSelection:(NSArray*) selectedVariants
{
    IMVarientSelction *varientModel = [[IMVarientSelction alloc] init];
    // get the variation theme
    NSArray *variationThemes = product.variationThemes;
    IMVariationTheme *selectedVariationtheme = nil;
    if (isPrimary) {
        selectedVariationtheme = variationThemes[0];
    }
    else{
        selectedVariationtheme = variationThemes[1];
    }
    varientModel.attributeName = selectedVariationtheme.displayName;
    varientModel.supportedValues = [NSMutableArray array];
    
    NSArray *productVarientvalues = selectedVariants;
    NSLog(@"productVarientvalues = %@",productVarientvalues);
    
    IMVarientValue *productPrimaryvarient = nil;
    IMVarientValue *productSecondaryvarient = nil;
    
    // in case of primary varient display all supported values
    if (isPrimary) {
        // Add all the supported values of primary variant
        // Mark currently shown primary variant as selected
        NSArray *primarySupprotedValues = selectedVariationtheme.supportedValues;
        productPrimaryvarient = productVarientvalues[0];
        for (NSString* varient in primarySupprotedValues) {
            IMVarientValue *varientValue = [[IMVarientValue alloc] init];
            varientValue.valueName = varient;
            if ([varient isEqualToString:productPrimaryvarient.valueName]) {
                varientValue.isSelected = YES;
            }
            else{
                varientValue.isSelected = NO;
            }
            varientValue.isSupported = YES;
            [varientModel.supportedValues addObject:varientValue];
        }
    }
    else{
        productPrimaryvarient = productVarientvalues[0];
        productSecondaryvarient = productVarientvalues[1];
        NSArray *secondarySupprotedValues = selectedVariationtheme.supportedValues;
        NSLog(@"secondarySupprotedValues = %@",secondarySupprotedValues);
        // get the supported secondary varients for the selected primary varient
        NSArray *secondayvarientsForselectedPrimary = product.otherVarients[productPrimaryvarient.valueName];
        BOOL firstSupportedSecVariantFound = NO;
        for (NSString* varient in secondarySupprotedValues) {
            // Add all the supported values of secondary variant
            // Mark only the secondary variants associated with the selected primary variant as supported
            // If previously selected secondary variant is supported by the current one, then mark it as selected
            IMVarientValue *varientValue = [[IMVarientValue alloc] init];
            varientValue.valueName = varient;
            varientValue.isSelected = NO;
            varientValue.isSupported = NO;
            NSLog(@"productPrimaryvarient = %@",productPrimaryvarient.valueName);
            NSLog(@"productSecondaryvarient = %@",productSecondaryvarient.valueName);
            NSLog(@"varient = %@",varientValue);
            NSLog(@"secondayvarientsForselectedPrimary = %@",secondayvarientsForselectedPrimary);
            for (IMVarientValue *secvarvalue in secondayvarientsForselectedPrimary) {
                if ([varient isEqualToString:secvarvalue.secondaryValue] && secvarvalue.isSupported) {
                    varientValue.isSupported = YES;
                    if (!firstSupportedSecVariantFound) {
                        firstSupportedSecVariantFound = YES;
                        varientValue.isSelected = YES;
                        varientModel.selectedVarient = varientValue;
                    }
                    break;
                }
            }
            [varientModel.supportedValues addObject:varientValue];
        }
    }
    return varientModel;
}

@end
