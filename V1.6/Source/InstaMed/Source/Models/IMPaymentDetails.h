//
//  IMPaymentDetails.h
//  InstaMed
//
//  Created by Yusuf Ansar on 11/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMPaymentDetails : IMBaseModel

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *bankTransactionID;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString  *transactionAmount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *transactionType;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *gatewayName;
@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseMessage;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *MID;
@property (nonatomic, strong) NSString *paymentMode;
@property (nonatomic, strong) NSString *refundAmount;
@property (nonatomic, strong) NSString *transactionDate;
@property (nonatomic, strong) NSString *isChecksumValid;

- (NSDictionary *) dictionaryForOrderComplete;
+ (NSDictionary *) getEmptyDictionaryForOrderComplete;

@end
