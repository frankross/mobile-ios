//
//  NSString+NSString_Validations.m
//  InstaMed
//
//  Created by Arjuna on 28/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "NSString+Validations.h"

@implementation NSString (Validations)

-(BOOL)isEmailAddress
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isPhoneNumber
{
    NSString* phoneNumberRegex=@"[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    return [phoneTest evaluateWithObject:self];

}

-(BOOL)isPassword
{
    NSString* passwordRegex=@"\\S{6,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];

}

-(BOOL)isValidPinCode
{
    NSString *pinRegex = @"^[0-9]{6}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    BOOL pinValidates = [pinTest evaluateWithObject:self];
    return pinValidates;
}


@end
