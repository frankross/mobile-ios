//
//  IMPaymentDetails.m
//  InstaMed
//
//  Created by Yusuf Ansar on 11/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPaymentDetails.h"

static NSString *const IMTransactionIDKey = @"TXNID";
static NSString *const IMBankTransactionIDKey = @"BANKTXNID";
static NSString *const IMOrderIDKey = @"ORDERID";
static NSString *const IMTransactionAmountKey = @"TXNAMOUNT";
static NSString *const IMStatusKey = @"STATUS";
static NSString *const IMTransactionTypeKey = @"TXNTYPE";
static NSString *const IMCurrencyKey = @"CURRENCY";
static NSString *const IMGatewayNameKey = @"GATEWAYNAME";
static NSString *const IMResponseCodeKey = @"RESPCODE";
static NSString *const IMResponseMessageKey = @"RESPMSG";
static NSString *const IMBankNameKey = @"BANKNAME";
static NSString *const IMMerchantIDKey = @"MID";
static NSString *const IMPaymentModeKey = @"PAYMENTMODE";
static NSString *const IMRefundAmountKey = @"REFUNDAMT";
static NSString *const IMTransactionDateKey = @"TXNDATE";
static NSString *const IMIsChecksumValidKey = @"IS_CHECKSUM_VALID";



@implementation IMPaymentDetails

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _transactionID = dictionary[IMTransactionIDKey];
        _bankTransactionID = dictionary[IMBankTransactionIDKey];
        _orderID = dictionary[IMOrderIDKey];
        _transactionAmount = dictionary[IMTransactionAmountKey];
        _status = dictionary[IMStatusKey];
        _transactionType = dictionary[IMTransactionTypeKey];
        _currency = dictionary[IMCurrencyKey];
        _gatewayName = dictionary[IMGatewayNameKey];
        _responseCode = dictionary[IMResponseCodeKey];
        _responseMessage = dictionary[IMResponseMessageKey];
        _bankName = dictionary[IMBankNameKey];
        _MID = dictionary[IMMerchantIDKey];
        _paymentMode = dictionary[IMPaymentModeKey];
        _refundAmount = dictionary[IMRefundAmountKey];
        _transactionDate = dictionary[IMTransactionDateKey];
        _isChecksumValid = dictionary[IMIsChecksumValidKey];
        
        
    }
    return self;
}

- (NSDictionary *) dictionaryForOrderComplete
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[IMTransactionIDKey] = self.transactionID ? self.transactionID : @"";
    dictionary[IMBankTransactionIDKey] = self.bankTransactionID ? self.bankTransactionID : @"";
    dictionary[IMOrderIDKey] = self.orderID ? self.orderID : @"";
    dictionary[IMTransactionAmountKey]  = self.transactionAmount ? self.transactionAmount : @"";
    dictionary[IMStatusKey] = self.status ? self.status : @"";
    dictionary[IMTransactionTypeKey] = self.transactionType ? self.transactionType : @"";
    dictionary[IMCurrencyKey] = self.currency ? self.currency : @"";
    dictionary[IMGatewayNameKey] = self.gatewayName ? self.gatewayName : @"";
    dictionary[IMResponseCodeKey] = self.responseCode ? self.responseCode : @"";
    dictionary[IMResponseMessageKey] = self.responseMessage ? self.responseMessage : @"";
    dictionary[IMBankNameKey] = self.bankName ? self.bankName : @"";
    dictionary[IMMerchantIDKey] = self.MID ? self.MID : @"";
    dictionary[IMPaymentModeKey] = self.paymentMode ? self.paymentMode : @"";
    dictionary[IMRefundAmountKey] = self.refundAmount ? self.refundAmount : @"";
    dictionary[IMTransactionDateKey] = self.transactionDate ? self.transactionDate : @"";
    dictionary[IMIsChecksumValidKey] = self.isChecksumValid ? self.isChecksumValid : @"";
    return dictionary;
}

+ (NSDictionary *) getEmptyDictionaryForOrderComplete
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[IMTransactionIDKey] = @"";
    dictionary[IMBankTransactionIDKey] = @"";
    dictionary[IMOrderIDKey] = @"";
    dictionary[IMTransactionAmountKey]  = @"";
    dictionary[IMStatusKey] = @"";
    dictionary[IMTransactionTypeKey] = @"";
    dictionary[IMCurrencyKey] = @"";
    dictionary[IMGatewayNameKey] = @"";
    dictionary[IMResponseCodeKey] = @"";
    dictionary[IMResponseMessageKey] = @"";
    dictionary[IMBankNameKey] = @"";
    dictionary[IMMerchantIDKey] = @"";
    dictionary[IMPaymentModeKey] = @"";
    dictionary[IMRefundAmountKey] = @"";
    dictionary[IMTransactionDateKey] = @"";
    dictionary[IMIsChecksumValidKey] = @"";
    return dictionary;
}

@end
