//
//  IMPayment.m
//  InstaMed
//
//  Created by Yusuf Ansar on 03/06/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPayment.h"

NSString* const IMPaymentMethodKey = @"payment_method";
NSString* const IMPaymentInstrumentKey = @"payment_instrument";
NSString* const IMPaymentAmountKey = @"amount";
NSString* const IMPaymentStatusKey = @"status";



@implementation IMPayment






-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.paymentMethod = dictionary[IMPaymentMethodKey];
        self.paymentInstrument = dictionary[IMPaymentInstrumentKey];
        self.amount = dictionary[IMPaymentAmountKey];
        self.status = dictionary[IMPaymentStatusKey];
    }
    return self;
}


@end
