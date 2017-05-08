//
//  NSString+NSString_Validations.h
//  InstaMed
//
//  Created by Arjuna on 28/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

@interface NSString (Validations)

-(BOOL)isEmailAddress;
-(BOOL)isPhoneNumber;
-(BOOL)isPassword;
-(BOOL)isValidPinCode;
@end
