//
//  IMCart.m
//  InstaMed
//
//  Created by Arjuna on 25/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCart.h"
#import "IMAccountsManager.h"
#import "IMPromotionOffer.h"
#import "IMPaymentInstrument.h"
#import "IMPayment.h"

NSString* const IMCartPromotionsKey = @"promotions";
NSString* const IMCartPromotionDiscountTotalKey = @"promotion_discount_total";
NSString* const IMCartCouponCodeKey = @"coupon_code";
NSString *const IMApplyWalletDebitKey = @"debit";

@implementation IMCart


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    dictionary = dictionary[@"cart"];
    
    self.lineItems = [NSMutableArray array];
    
    for(NSDictionary* lineItemDict in dictionary[@"line_items"])
    {
        IMLineItem* lineItem = [[IMLineItem alloc] initWithDictionary:lineItemDict];
        [self.lineItems addObject:lineItem];
        
    }
    
    self.orderId = dictionary[@"order_id"];
    self.shippingsTotal = dictionary[@"shipping_total"];
    self.cartTotal = dictionary[@"cart_total"];
    self.netPayableAmount = dictionary[@"net_payable_amount"];
    self.lineItemsTotal = dictionary[@"line_items_total"];
    self.discountTotal = dictionary[@"discount_total"];
    self.canEditQuantity = true;
    self.canShowCoupon = true;
    self.canUpdateAddress = true;
    self.isNewOrder = true; // fresh order
    self.screenTitle = @"Cart";
    self.placeOrderButtonTitle = @"Place order";
    self.shouldCheckPrescriptionPending = YES;
    self.shouldCheckLineItemsQuantity = YES;
    //ka to display along with delivery charges
    self.shippingDescription = dictionary[@"shipping_description"];
    self.maxAllowedPOD = dictionary[@"max_allowed_cod_amount"];
    self.cartOperationType = IMUserCartCheckout;
    self.needToCheckForProductAvailability = YES;
    self.canRemoveLineItem = YES;
    self.patientDetailRequired = dictionary[@"patient_details_required"];
    self.promotionDiscountTotal = dictionary[IMCartPromotionDiscountTotalKey];
    self.atTheTimeOfDeliveryAllowed = [dictionary[@"order_without_prescription"] boolValue];
    
    self.cashback = [dictionary[@"cash_back"] boolValue];
    self.cashbackDescription = dictionary[@"cash_back_desc"];
    
    self.applyWallet = [dictionary[@"apply_wallet"] boolValue];
    self.walletAmount = dictionary[@"wallet_amount"];
    self.isPaymentFullyDoneByWallet = [dictionary[@"fully_paid_by_wallet"] boolValue];
    self.isPaymentRetryable = [dictionary[@"payment_retryable"] boolValue];
    
    NSMutableArray *paymentMethodsArray = [NSMutableArray array];
    for (NSDictionary *paymentMethodDictionary in dictionary[@"payment_methods"])
    {
        IMPaymentMethod *paymentMethod = [[IMPaymentMethod alloc] initWithDictionary:paymentMethodDictionary];
        [paymentMethodsArray addObject:paymentMethod];
    }
    self.paymentMethods = [NSArray arrayWithArray:paymentMethodsArray];
    //by default select the first payment method as selected payment
    if(self.paymentMethods.count > 0)
    {
        self.selectedPaymentMethod = self.paymentMethods[0];
    }
    
    NSMutableArray *paymentsArray = [NSMutableArray array];
    for(NSDictionary *paymentDictionary in dictionary[@"payments"])
    {
        IMPayment *payment = [[IMPayment alloc] initWithDictionary:paymentDictionary];
        [paymentsArray addObject:payment];
    }
    self.paymentsArray = [NSArray arrayWithArray:paymentsArray];
    

    [self setPromoOffers:dictionary[IMCartPromotionsKey]];
    return self;
}


-(void)updateWithCart:(IMCart*)cart
{
    self.lineItems = cart.lineItems;
    self.shippingsTotal = cart.shippingsTotal;
    self.lineItemsTotal = cart.lineItemsTotal;
    self.cartTotal = cart.cartTotal;
    self.discountTotal = cart.discountTotal;
    self.promotionDiscountTotal = cart.promotionDiscountTotal;
    self.prescriptionDetails = cart.prescriptionDetails;
    self.shippingDescription = cart.shippingDescription;
    self.maxAllowedPOD = cart.maxAllowedPOD;
    self.patientDetailRequired = cart.patientDetailRequired;
    self.promotionalOffers = cart.promotionalOffers;
    self.originalPromotionalOffers = cart.originalPromotionalOffers;
    self.atTheTimeOfDeliveryAllowed = cart.atTheTimeOfDeliveryAllowed;
    self.cashback = cart.isCashBackAvailable;
    self.cashbackDescription = cart.cashbackDescription;
    self.applyWallet = cart.isApplyWallet;
    self.walletAmount = cart.walletAmount;
    self.paymentMethods = cart.paymentMethods;
    self.netPayableAmount = cart.netPayableAmount;
    self.isPaymentFullyDoneByWallet = cart.isPaymentFullyDoneByWallet;
    self.paymentsArray = cart.paymentsArray;
    self.isPaymentRetryable = cart.isPaymentRetryable;
    

}

- (void) updateCartForApplyWalletWithCart:(IMCart *)cart
{
    self.cartTotal = cart.cartTotal;
    self.applyWallet = cart.isApplyWallet;
    self.paymentMethods = cart.paymentMethods;
    self.netPayableAmount = cart.netPayableAmount;
    self.isPaymentFullyDoneByWallet = cart.isPaymentFullyDoneByWallet;
    self.paymentsArray = cart.paymentsArray;
    
}

-(BOOL)checkLineItemsQuantity
{
    BOOL success = YES;
    // TODO:Check against available 14-sep-15
    for(IMLineItem* lineItem in self.lineItems)
    {
        if(lineItem.quantity > lineItem.maxOrderQuanitity.integerValue )
        {
            success  = NO;
            break;
        }
    }
   return success;
}

- (BOOL)checkMaxAllowedPOD
{
    BOOL success = YES;
    if(self.cartTotal > self.maxAllowedPOD)
    {
         success  = NO;
    }
    return success;
}

-(NSDictionary *)dictionaryForOrderFullfillmentCenter
{
    return  @{@"billing_address_id":self.deliveryAddress.identifier, @"area_id":self.deliveryAddress.areaID, @"shipping_address_id":self.deliveryAddress.identifier};
}

-(NSDictionary*)dictionaryForOrderComplete
{
    IMPayment *payment = self.paymentsArray.count > 0 ? self.paymentsArray[0] : nil;
    NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
    NSString *paymentInstrumentWhenFullyDoneByWallet = payment.paymentInstrument;
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[@"delivery_slot_id"] = self.deliverySlot.identifier;
    dictionary[@"shipping_address_id"] = self.deliveryAddress.identifier;
    dictionary[@"billing_address_id"] = self.deliveryAddress.identifier;
    if(self.isPaymentFullyDoneByWallet)
    {
        dictionary[@"payment_method"] = paymentMethodWhenFullyDoneByWallet ? paymentMethodWhenFullyDoneByWallet : @"";
        dictionary[@"payment_instrument"] = paymentInstrumentWhenFullyDoneByWallet ? paymentInstrumentWhenFullyDoneByWallet : @"";
    }
    else
    {
        dictionary[@"payment_method"] = self.selectedPaymentMethod.ID ? self.selectedPaymentMethod.ID :@"";
        IMPaymentInstrument *usedInstrumentForPayment = self.selectedPaymentMethod.paymentInstruments[0];
        dictionary[@"payment_instrument"] = usedInstrumentForPayment.ID ? usedInstrumentForPayment.ID :@"";;
    }
    
    if([self.selectedPaymentMethod.ID isEqualToString:IMPaytmWalletPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMDebitCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMCreditCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMNetBankingPaymentmethod] )
    {
        if(self.paymentDetails)
        {
            dictionary[@"payment_details"] = [self.paymentDetails dictionaryForOrderComplete];
        }
        else
        {
            dictionary[@"payment_details"] = [IMPaymentDetails getEmptyDictionaryForOrderComplete];
        }
    }

    

    if([IMAccountsManager sharedManager].currentOrderPrescriptionUploadId)
    {
            dictionary[@"prescription_upload_id"] = [IMAccountsManager sharedManager].currentOrderPrescriptionUploadId;
    }
    return @{@"order" : dictionary};
}

-(NSDictionary*)dictionaryForPaymentFailure
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    IMPayment *payment = self.paymentsArray.count > 0 ? self.paymentsArray[0] : nil;
    NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
    NSString *paymentInstrumentWhenFullyDoneByWallet = payment.paymentInstrument;

    if(self.isPaymentFullyDoneByWallet)
    {
        dictionary[@"payment_method"] = paymentMethodWhenFullyDoneByWallet ? paymentMethodWhenFullyDoneByWallet : @"";
        dictionary[@"payment_instrument"] = paymentInstrumentWhenFullyDoneByWallet ? paymentInstrumentWhenFullyDoneByWallet : @"";
    }
    else
    {
        dictionary[@"payment_method"] = self.selectedPaymentMethod.ID ? self.selectedPaymentMethod.ID :@"";
        IMPaymentInstrument *usedInstrumentForPayment = self.selectedPaymentMethod.paymentInstruments[0];
        dictionary[@"payment_instrument"] = usedInstrumentForPayment.ID ? usedInstrumentForPayment.ID :@"";;
    }
    
    if([self.selectedPaymentMethod.ID isEqualToString:IMPaytmWalletPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMDebitCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMCreditCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMNetBankingPaymentmethod] )
    {
        if(self.paymentDetails)
        {
            dictionary[@"payment_details"] = [self.paymentDetails dictionaryForOrderComplete];
        }
        else
        {
            dictionary[@"payment_details"] = [IMPaymentDetails getEmptyDictionaryForOrderComplete];
        }
    }
    return @{@"order" : dictionary};
}


-(NSDictionary*)dictionaryForOrderUpdate
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    IMPayment *payment = self.paymentsArray.count > 0 ? self.paymentsArray[0] : nil;
    NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
    NSString *paymentInstrumentWhenFullyDoneByWallet = payment.paymentInstrument;
    dictionary[@"delivery_slot_id"] = self.deliverySlot.identifier;
    dictionary[@"shipping_address_id"] = self.deliveryAddress.identifier;
    dictionary[@"billing_address_id"] = self.deliveryAddress.identifier;
    dictionary[@"patient_name"]= self.patientName;
    dictionary[@"doctor_names"]= self.doctorName;
    
    if(self.isPaymentFullyDoneByWallet)
    {
        dictionary[@"payment_method"] = paymentMethodWhenFullyDoneByWallet ? paymentMethodWhenFullyDoneByWallet : @"";
        dictionary[@"payment_instrument"] = paymentInstrumentWhenFullyDoneByWallet ? paymentInstrumentWhenFullyDoneByWallet : @"";
    }
    else
    {
        dictionary[@"payment_method"] = self.selectedPaymentMethod.ID ? self.selectedPaymentMethod.ID :@"";
        IMPaymentInstrument *usedInstrumentForPayment = self.selectedPaymentMethod.paymentInstruments[0];
        dictionary[@"payment_instrument"] = usedInstrumentForPayment.ID ? usedInstrumentForPayment.ID :@"";;
    }
    
    if([self.selectedPaymentMethod.ID isEqualToString:IMPaytmWalletPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMDebitCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMCreditCardPaymentmethod] || [self.selectedPaymentMethod.ID isEqualToString:IMNetBankingPaymentmethod] )
    {
        if(self.paymentDetails)
        {
            dictionary[@"payment_details"] = [self.paymentDetails dictionaryForOrderComplete];
        }
        else
        {
            dictionary[@"payment_details"] = [IMPaymentDetails getEmptyDictionaryForOrderComplete];
        }
    }
    if([IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId)
    {
        dictionary[@"prescription_upload_id"] = [IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId;
    }
    NSLog(@"dictionaryForOrderUpdate = %@",dictionary);
    return @{@"order" : dictionary};
}

-(NSDictionary*)dictionaryForOrderCheckOut
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[@"patient_name"]= self.patientName;
    dictionary[@"doctor_names"]= self.doctorName;
    return dictionary;
}

- (NSDictionary *)dictionaryForPaymentInitiation
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"delivery_slot_id"] = self.deliverySlot.identifier;
    dictionary[@"shipping_address_id"] = self.deliveryAddress.identifier;
    dictionary[@"billing_address_id"] = self.deliveryAddress.identifier;
    
    IMPayment *payment = self.paymentsArray.count > 0 ? self.paymentsArray[0] : nil;
    NSString *paymentMethodWhenFullyDoneByWallet = payment.paymentMethod;
    NSString *paymentInstrumentWhenFullyDoneByWallet = payment.paymentInstrument;
    
    if(self.isPaymentFullyDoneByWallet)
    {
        dictionary[@"payment_method"] = paymentMethodWhenFullyDoneByWallet ? paymentMethodWhenFullyDoneByWallet : @"";
        dictionary[@"payment_instrument"] = paymentInstrumentWhenFullyDoneByWallet ? paymentInstrumentWhenFullyDoneByWallet : @"";
    }
    else
    {
        dictionary[@"payment_method"] = self.selectedPaymentMethod.ID ? self.selectedPaymentMethod.ID :@"";
        IMPaymentInstrument *usedInstrumentForPayment = self.selectedPaymentMethod.paymentInstruments[0];
        dictionary[@"payment_instrument"] = usedInstrumentForPayment.ID ? usedInstrumentForPayment.ID :@"";;
    }
    
    if([IMAccountsManager sharedManager].currentOrderPrescriptionUploadId)
    {
        dictionary[@"prescription_upload_id"] = [IMAccountsManager sharedManager].currentOrderPrescriptionUploadId;
    }
    return dictionary;
}

-(NSDictionary *)dictionaryForApplyWallet
{
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[@"debit"]= [NSNumber numberWithBool:self.isApplyWallet];
    return  dictionary;
}

//ka if user chose prescription upload at the time of delivery then prescriptionUploadId will be nil
-(BOOL) isPrescriptionPresent
{
    return ([IMAccountsManager sharedManager].currentOrderPrescriptionUploadId != nil);
}

//TODO: for testing
-(void) setPromoOffers:(NSArray *)promotions
{
    _originalPromotionalOffers = [[NSMutableArray alloc]init];
    _promotionalOffers = [[NSMutableArray alloc]init];
    
    for(NSDictionary* promotionsDict in promotions)
    {
        IMPromotionOffer* offer = [[IMPromotionOffer alloc] initWithDictionary:promotionsDict];
        [_originalPromotionalOffers addObject:offer];
        if (offer.canShowPromoOffer) {
            [_promotionalOffers addObject:offer];
        }
    }
    /*
    //TODO: for testing
    IMPromotionOffer *offer1 = [[IMPromotionOffer alloc] initWithDictionary:@{@"main_text": @"Thermometer worth Rs. 200 free", @"sub_text":@"on purchase of Rs. 1500 or above"}];
    IMPromotionOffer *offer2 = [[IMPromotionOffer alloc] initWithDictionary:@{@"main_text": @"Thermometer worth Rs. 200 free", @"sub_text":@"on purchase of Rs. 1500 or above"}];
    [_originalPromotionalOffers addObjectsFromArray:@[offer1, offer2]];
     */
}

- (NSArray*) appliedCoupons
{
    NSMutableArray *appliedCoupons = [[NSMutableArray alloc] init];
    for (IMPromotionOffer *promoOffer in _originalPromotionalOffers) {
        IMCoupon *coupon = promoOffer.coupon;
        if (coupon.isExternallyAppliedCoupon) {
            // only one coupon can be applied. For next phase multiple coupons may need to be supported
            [appliedCoupons addObject:promoOffer.coupon];
            break;
        }
    }
    //TODO: for testing
    /*IMCoupon *coupon1 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA10"}];
    IMCoupon *coupon2 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA20"}];
    IMCoupon *coupon3 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA30"}];
    IMCoupon *coupon4 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA40"}];
    IMCoupon *coupon5 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA50"}];
    IMCoupon *coupon6 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA60"}];
    IMCoupon *coupon7 = [[IMCoupon alloc] initWithDictionary:@{@"message": @"extra 10 % off", @"code":@"EXTRA70"}];
    appliedCoupons = [NSMutableArray array];
    [appliedCoupons addObjectsFromArray:@[coupon1, coupon2, coupon3, coupon4, coupon5, coupon6,coupon7]];
    */
    return appliedCoupons;
}

- (BOOL) hasAppliedCouponCode
{
    BOOL hasAppliedCoupon = NO;
    NSArray *appliedCoupons = [self appliedCoupons];
    if (appliedCoupons && appliedCoupons.count > 0) {
        hasAppliedCoupon = YES;
    }
    return hasAppliedCoupon;
}

-(NSDictionary*)dictionaryForCouponApply: (NSString*) coupon
{
    return @{IMCartCouponCodeKey: coupon};
}


@end
