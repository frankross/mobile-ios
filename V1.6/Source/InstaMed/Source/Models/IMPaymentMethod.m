//
//  IMPaymentMethod.m
//  InstaMed
//
//  Created by Yusuf Ansar on 06/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPaymentMethod.h"
#import "IMPaymentInstrument.h"

@implementation IMPaymentMethod

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _ID = dictionary[@"id"];
        _name = dictionary[@"name"];
        NSMutableArray *paymentInstrumentsArray = [NSMutableArray array];
        for (NSDictionary *paymentInstrumentDictionary in dictionary[@"payment_instruments"])
        {
            IMPaymentInstrument *paymentInstrument = [[IMPaymentInstrument alloc] initWithDictionary:paymentInstrumentDictionary];
            [paymentInstrumentsArray addObject:paymentInstrument];
        }
        _paymentInstruments = [NSArray arrayWithArray:paymentInstrumentsArray];
        
        if([dictionary[@"payment_type"] isEqualToString:@"prepay"])
        {
            _isPrepaid = YES;
        }
        
    }
    return self;
}

@end
