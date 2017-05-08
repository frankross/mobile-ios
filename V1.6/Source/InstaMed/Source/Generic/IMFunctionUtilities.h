//
//  IMFunctionUtilities.h
//  InstaMed
//
//  Created by GPB on 24/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

@interface IMFunctionUtilities : NSObject

+ (NSString*)formattedCurrencyStringFromNumber:(NSNumber*)number withCurrencySymbolRequired:(BOOL)currencySymbolRequired;

+ (void)setBackgroundImage:(id)item withImageColor:(UIColor*)color;
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)rectValue;

+ (NSString *)timeAgoStringFromDate:(NSDate *)oldDate;

@end
