//
//  IMFunctionUtilities.m
//  InstaMed
//
//  Created by GPB on 24/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFunctionUtilities.h"

//static NSString *const IMInAppNotificationDateFormatString = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";


@implementation IMFunctionUtilities

+ (NSString*)formattedCurrencyStringFromNumber:(NSNumber*)number withCurrencySymbolRequired:(BOOL)currencySymbolRequired
{
    NSNumberFormatter *indCurrencyFormatter = [[NSNumberFormatter alloc] init];
    [indCurrencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if (currencySymbolRequired) {
        [indCurrencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    [indCurrencyFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"]];
    
    NSString *formattedString =  [indCurrencyFormatter stringFromNumber:number];
    
    //    if ([formattedString rangeOfString:@".00"].location != NSNotFound) {
    //        formattedString = [formattedString substringToIndex:formattedString.length-3];
    //    }
    
    return formattedString;
}

+ (void)setBackgroundImage:(id)item withImageColor:(UIColor*)color
{
    if([item isKindOfClass:[UIButton class]]) {
        [item setBackgroundImage:[IMFunctionUtilities imageWithColor:color frame:CGRectMake(0, 0, 1.0, 1.0)] forState:UIControlStateNormal];
    }
    else {
        [item setBackgroundImage:[IMFunctionUtilities imageWithColor:color frame:CGRectMake(0, 0, 1.0, 1.0)]];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)rectValue
{
    CGRect frame = rectValue;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)timeAgoStringFromDate:(NSDate *)oldDate
{
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:IMInAppNotificationDateFormatString];
//    NSDate *newDate = [dateFormat dateFromString: date];
    
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    
    if (oldDate != nil && now != nil)
    {
        components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                 fromDate:oldDate
                                   toDate:now
                                  options:0];
    }
    
    
    if (components.year > 0){
        formatter.allowedUnits = NSCalendarUnitYear;
    } else if (components.month > 0) {
        formatter.allowedUnits = NSCalendarUnitMonth;
    } else if (components.weekOfMonth > 0) {
        formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
    } else if (components.day > 0) {
        formatter.allowedUnits = NSCalendarUnitDay;
    } else if (components.hour > 0) {
        formatter.allowedUnits = NSCalendarUnitHour;
    } else if (components.minute > 0) {
        formatter.allowedUnits = NSCalendarUnitMinute;
    } else {
        formatter.allowedUnits = NSCalendarUnitSecond;
    }
    
    if (components.minute < 0 || components.second < 0)
    {
        return @"Just now";
    }
    if  (formatter.allowedUnits == NSCalendarUnitSecond)
    {
        return @"Just now";
    }
    return [NSString stringWithFormat:@"%@", [formatter stringFromDateComponents:components]];
}

@end
