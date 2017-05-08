//
//  IMCart.h
//  InstaMed
//
//  Created by Arjuna on 25/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMLineItem.h"
#import "IMDeliverySlot.h"
#import "IMAddress.h"
#import "IMCoupon.h"
#import "IMPaymentMethod.h"
#import "IMPaymentDetails.h"

typedef enum : NSUInteger {
    IMUserCartCheckout,
    IMReoder,
    IMBuyNow,
    IMUpdateOrder
} IMCartOperationType;

extern NSString *const IMApplyWalletDebitKey;

@interface IMCart : IMBaseModel

@property(nonatomic,strong) NSNumber* shippingsTotal;
@property(nonatomic,strong) NSNumber* lineItemsTotal;
@property(nonatomic,strong) NSNumber* discountTotal;
@property(nonatomic,strong) NSNumber* cartTotal;
@property(nonatomic,strong) NSMutableArray* lineItems;
@property(nonatomic,strong) IMAddress* deliveryAddress;
@property(nonatomic,strong) IMDeliverySlot* deliverySlot;
@property(nonatomic,strong) NSString* prescriptionUploadId;
@property (nonatomic) IMCartOperationType cartOperationType;
@property(nonatomic,strong) NSNumber* maxAllowedPOD;


@property(nonatomic,strong) NSNumber* orderId;
@property(nonatomic) BOOL canShowCoupon;
@property(nonatomic) BOOL canUpdateAddress;
@property(nonatomic) BOOL canEditQuantity;
@property(nonatomic) BOOL needToCheckForProductAvailability;
@property(nonatomic) BOOL canRemoveLineItem;
@property(nonatomic) BOOL isQuantityCheckRequired;
@property(nonatomic) BOOL isNewOrder;
@property(nonatomic) NSString* screenTitle;
@property(nonatomic) NSString* placeOrderButtonTitle;
@property(nonatomic) BOOL shouldCheckLineItemsQuantity;
@property(nonatomic) BOOL shouldCheckPrescriptionPending;
@property(nonatomic) NSString* shippingDescription;
@property(nonatomic,strong) NSArray* prescriptionDetails;

@property(nonatomic) NSString* patientDetailRequired;
@property(nonatomic) NSString* patientName;
@property(nonatomic) NSString* doctorName;

@property(nonatomic,strong) NSNumber* promotionDiscountTotal;
@property(nonatomic,strong) NSMutableArray* promotionalOffers;
/**
 @brief Actual promo offers received from the server
 */
@property(nonatomic,strong) NSMutableArray* originalPromotionalOffers;
@property(nonatomic,strong) NSMutableArray* appliedCoupons;

@property(nonatomic) BOOL atTheTimeOfDeliveryAllowed;

@property (nonatomic, assign, getter=isCashBackAvailable) BOOL cashback;
@property (nonatomic, strong) NSString *cashbackDescription;

@property (nonatomic, assign, getter=isApplyWallet) BOOL applyWallet;
@property (nonatomic, strong) NSNumber *walletAmount;
@property (nonatomic, strong) NSArray *paymentMethods;
@property (nonatomic, strong) IMPaymentMethod *selectedPaymentMethod;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) IMPaymentDetails *paymentDetails;
@property (nonatomic, strong) NSNumber *netPayableAmount;
@property (nonatomic, assign) BOOL isPaymentRetryable;
@property (nonatomic, assign) BOOL isPaymentFullyDoneByWallet;
@property (nonatomic, strong) NSArray *paymentsArray;
@property (nonatomic, strong) NSNumber *fulFillmentCenterID;


-(void)updateWithCart:(IMCart*)cart;

-(BOOL)checkLineItemsQuantity;

-(NSDictionary*)dictionaryForOrderComplete;
-(NSDictionary*)dictionaryForPaymentFailure;
- (NSDictionary *)dictionaryForPaymentInitiation;
- (BOOL)checkMaxAllowedPOD;
-(NSDictionary*)dictionaryForOrderUpdate;
-(BOOL) isPrescriptionPresent;
-(NSDictionary *)dictionaryForOrderFullfillmentCenter;
-(NSDictionary*)dictionaryForOrderCheckOut;
-(NSDictionary*)dictionaryForCouponApply: (NSString*) coupon;
-(NSDictionary *)dictionaryForApplyWallet;
- (BOOL) hasAppliedCouponCode;

- (void) updateCartForApplyWalletWithCart:(IMCart *)cart;
@end
