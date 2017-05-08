//
//  IMOrder.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrder.h"
#import "IMLineItem.h"
#import "IMOrderPrescription.h"
#import "IMPaymentMethod.h"

NSString* const IMOrderPromotionDiscountTotalKey = @"promotion_discount_total";

@implementation IMOrder

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    self.state = dictionary[@"state"];

    self.stateDisplayName = dictionary[@"state_display_name"];
    self.orderDate = dictionary[@"confirmed_on"];
    self.shippingCharges = dictionary[@"shipping_total"];
    self.totalAmount = dictionary[@"total"];
    self.lineItemsTotal = dictionary[@"line_items_total"];
    self.discountsTotal = dictionary[@"discount_total"];
    self.promotionDiscountTotal = dictionary[IMOrderPromotionDiscountTotalKey];
    NSDictionary *deliveryAddressDict = dictionary[@"shipping_address"];
    IMAddress *deliveryTo = [[IMAddress alloc] initWithDictionary:deliveryAddressDict];
    self.deliveryAddress = deliveryTo;
    NSArray *productDictArray =  dictionary[@"line_items"];
    self.hasReoorderReminder = [dictionary[@"reorder_reminder"] boolValue];
    if(productDictArray.count)
    {
        self.orderedItems  = [[NSMutableArray alloc] init];
        for(NSDictionary *productDict in productDictArray)
        {
            IMLineItem *product = [[IMLineItem alloc] initWithDictionary:productDict];
            [self.orderedItems addObject:product];
        }
    }
    
    self.deliverySlot = [[IMDeliverySlot alloc] initWithDictionary:dictionary[@"delivery_slot"]];
    
    self.patientDetailRequired = dictionary[@"patient_details_required"];
    self.patientName = dictionary[@"patient_name"];
    self.doctorName = dictionary[@"doctor_names"];
    
    self.isCancellable = [dictionary[@"is_cancellable"] boolValue];
    self.isReturnable = [dictionary[@"is_returnable"] boolValue];
    self.isReorderable = [dictionary[@"is_reorderable"] boolValue];
    self.isMismatched = [dictionary[@"is_mismatched"] boolValue];
    self.usedPaymentMethod = dictionary[@"payment_method"];
    
    if(dictionary[@"reorder_reminder_details"])
    {
        self.reorderReminder = [[IMReorderReminder alloc] initWithDictionary:dictionary[@"reorder_reminder_details"]];
    }
    
    NSArray *prescriptionDetailsList =  dictionary[@"prescription_details"];
    if(prescriptionDetailsList.count)
    {
        self.prescriptionDetails  = [[NSMutableArray alloc] init];
        for(NSDictionary *prescriptionDetail in prescriptionDetailsList)
        {
            IMOrderPrescription *prescription = [[IMOrderPrescription alloc] initWithDictionary:prescriptionDetail];
            [self.prescriptionDetails addObject:prescription];
        }
    }
    self.shippingDescription = dictionary[@"shipping_description"];
    self.atTheTimeOfDeliveryAllowed = [dictionary[@"order_without_prescription"] boolValue];
    
    
    self.applyWallet = [dictionary[@"apply_wallet"] boolValue];
    self.walletAmount = dictionary[@"wallet_amount"];
    
    NSMutableArray *paymentMethodsArray = [NSMutableArray array];
    for (NSDictionary *paymentMethodDictionary in dictionary[@"payment_methods"])
    {
        IMPaymentMethod *paymentMethod = [[IMPaymentMethod alloc] initWithDictionary:paymentMethodDictionary];
        [paymentMethodsArray addObject:paymentMethod];
    }
    _paymentMethods = [NSArray arrayWithArray:paymentMethodsArray];
    
    

    return self;
}


-(void)updateWithOrder:(IMOrder*)order
{
    self.orderedItems = order.orderedItems;
    self.shippingCharges = order.shippingCharges;
    self.lineItemsTotal = order.lineItemsTotal;
    self.totalAmount = order.totalAmount;
    self.discountsTotal = order.discountsTotal;
    self.promotionDiscountTotal = order.promotionDiscountTotal;
    self.prescriptionDetails = order.prescriptionDetails;
}

- (NSString*) orderReviseReason
{
    // enable for testing
    /*
    IMOrderPrescription *prescr1 = [[IMOrderPrescription alloc] init];
    prescr1.escalationReason = @"The medicines name not clear";
    IMOrderPrescription *prescr2 = [[IMOrderPrescription alloc] init];
    prescr2.escalationReason = @"The medicines strength improper ";
    IMOrderPrescription *prescr3 = [[IMOrderPrescription alloc] init];
    IMOrderPrescription *prescr4 = [[IMOrderPrescription alloc] init];
    prescr4.escalationReason = @"The prescription image is blurr can't read the medicines details. ";
    self.prescriptionDetails  = [[NSMutableArray alloc] init];
    [self.prescriptionDetails addObject:prescr1];
    [self.prescriptionDetails addObject:prescr2];
    [self.prescriptionDetails addObject:prescr3];
    [self.prescriptionDetails addObject:prescr4];
     */
    NSString *orderReviseReason = @"";
    if (_prescriptionDetails.count > 0) {
        for (IMOrderPrescription *orderPrescription in _prescriptionDetails) {
            if (orderPrescription.escalationReason) {
                if (orderReviseReason .length > 0) {
                    orderReviseReason = [orderReviseReason stringByAppendingString:@"\n"];
                }
                orderReviseReason = [orderReviseReason stringByAppendingFormat:@"•  %@",orderPrescription.escalationReason];
            }
        }
    }
    return orderReviseReason;
    
}

-(BOOL) isOrderRefundable
{
    if([self.usedPaymentMethod isEqualToString:@"prepaid"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
