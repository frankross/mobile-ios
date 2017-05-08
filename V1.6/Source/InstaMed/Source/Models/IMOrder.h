//
//  IMOrder.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMLineItem.h"
#import "IMAddress.h"
#import "IMDeliverySlot.h"
#import "IMReorderReminder.h"

typedef enum
{
    IMOrderApproval = 0,
    IMOrderProcessing,
    IMOrderShipped,
    IMOrderDelivered
    
}IMOrderStatus;

@interface IMOrder : IMBaseModel

@property(nonatomic,strong) NSString* state;
@property(nonatomic,strong) NSString* stateDisplayName;

@property(nonatomic,strong) NSString* orderDate;
@property(nonatomic,strong) NSString* ETA;
@property(nonatomic,assign) IMOrderStatus status;
@property(nonatomic,strong) NSMutableArray* orderedItems;
@property(nonatomic,strong) NSString* deliveredDate;
@property(nonatomic,strong) IMAddress* deliveryAddress;
@property(nonatomic,strong) IMAddress* shippedFromAddress;
@property(nonatomic,strong) NSString* drugLicenceNumber;
@property(nonatomic,strong) NSString* vatNumber;
@property(nonatomic,strong) NSString *shippingCharges;
@property(nonatomic,strong) NSString *totalAmount;
@property(nonatomic,strong) NSString *lineItemsTotal;
@property(nonatomic,strong) NSString *discountsTotal;

//Reminder
@property (nonatomic,strong) NSNumber* reminderFrequency;
@property (nonatomic,strong) NSString* frequencyType;
@property (nonatomic,strong) NSString* nextDueDate;

/**
 @brief Returns the order revise reasons as bulletted points
 @returns NSString*
 */
@property (nonatomic,strong) NSString* orderReviseReason;

@property(nonatomic,strong) IMReorderReminder* reorderReminder;


@property (nonatomic,strong) IMDeliverySlot *deliverySlot;
@property (nonatomic) BOOL hasReoorderReminder;
@property (nonatomic) BOOL isReturnable;
@property (nonatomic) BOOL isCancellable;
@property (nonatomic) BOOL isReorderable;
@property (nonatomic) BOOL isMismatched;
@property (nonatomic) NSString *usedPaymentMethod;
@property(nonatomic,strong) NSMutableArray* prescriptionDetails;
@property(nonatomic) NSString* shippingDescription;

@property (nonatomic) BOOL isCompleteDetailPresent;

@property(nonatomic) NSString* patientDetailRequired;
@property(nonatomic) NSString* patientName;
@property(nonatomic) NSString* doctorName;
@property(nonatomic,strong) NSString* promotionDiscountTotal;

@property(nonatomic) BOOL atTheTimeOfDeliveryAllowed;

@property (nonatomic, assign, getter=isApplyWallet) BOOL applyWallet;
@property (nonatomic, strong) NSNumber *walletAmount;
@property (nonatomic, strong) NSArray *paymentMethods;
@property (nonatomic, strong) NSString *transactionID;


-(void)updateWithOrder:(IMOrder*)order;
-(BOOL) isOrderRefundable;


@end
