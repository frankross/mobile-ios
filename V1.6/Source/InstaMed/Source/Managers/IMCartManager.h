//
//  IMCartManager.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

#import "IMCart.h"
#import "IMOrder.h"



//Cart Management,
@interface IMCartManager : NSObject


@property(nonatomic,strong) IMCart* currentCart;
@property(nonatomic,strong) IMOrder* currentOrder;
//for holding patient info from prescription detail and order reorder
@property (nonatomic,strong) NSString *patientName;
@property (nonatomic,strong) NSString *doctorName;

#pragma mark - Cart -


+ (IMCartManager *)sharedManager;


@property(weak,nonatomic) UIViewController* orderInitiatedViewController;


-(void)fetchCartWithCompletion:(void(^)(IMCart* cart, NSError* error))completion;
//-(void)fetchCartItemsWithCompletion:(void(^)(NSArray* cartItems,NSDictionary* ordrerCalculations, NSError* error))completion;
-(void)updateCartItems:(NSArray*)cartItems withCompletion:(void(^)(IMCart* cart, NSError* error))completion;//Update if already exists in the cart
-(void)deleteCartItemWithId:(NSNumber*)cartItemId withCompletion:(void(^)(IMCart* cart, NSError* error))completion;

-(NSInteger)quantityOfCartLineItemWithVariantId:(NSNumber*)variantId;

-(void)fetchFullfillmentCenterIDForCart:(IMCart *)cart withCompletion:(void(^)(NSNumber *fulfillemntCenterID, NSError* error))completion;

-(void)fetchDeliverySlotsForAreaId:(NSNumber*)areaId withFullfillmentCenterID:(NSNumber *)fullfillmentCenterID withPrescription:(BOOL)withPrescription withCompletion:(void(^)(NSMutableArray* deliverySlots, NSError* error))completion;

-(void)checkOutUserCart:(IMCart *)cart WithCompletion:(void(^)(NSNumber* orderId,  NSError* error))completion;
-(void)completeOrderWithId:(NSNumber*)orderId withCart:(IMCart*)cart withCompletion:(void(^)(NSError* error))completion;

-(void)reorderFromOrder:(IMOrder*)order withCompletion:(void(^)(NSError *error))completion;

-(NSArray*)updatedLineItemsFromCurrentCart:(NSArray*)lineItems;
-(void)updateOrder:(IMOrder*)order withCart:(IMCart*)cart withCompletion:(void(^)(NSError* error))completion;


/**
 @brief To apply coupon for the cart.
 @brief On success, updated cart object is returned.
 @brief On failure, error explaining the reason is returned.
 @param coupon: NSString* The coupon code to be applied to the cart
 @param cart: IMCart* The cart object
 @param completion: The completion block
 @returns void
 */
-(void)applyCoupon:(NSString*)coupon withCart:(IMCart*)cart withCompletion:(void(^)(IMCart* cart,NSError* error))completion;

/**
 @brief To remove coupon for the cart.
 @brief On success, updated cart object is returned.
 @brief On failure, error explaining the reason is returned.
 @param coupon: NSString* The coupon code to be applied to the cart
 @param cart: IMCart* The cart object
 @param completion: The completion block
 @returns void
 */
-(void)removeCoupon:(NSString*)coupon withCart:(IMCart*)cart withCompletion:(void(^)(IMCart* cart,NSError* error))completion;

-(void)updateCart:(IMCart *)cart withOrderId:(NSNumber *)orderId andInfo:(NSDictionary *) dictionary forApplyWalletWithCompletion:(void (^)(IMCart *, NSError *))completion;

-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId andCart:(IMCart *)cart withCompletion:(void(^)(NSString *transactionID, NSError* error))completion;
//-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId info:(NSDictionary*)initiatePaymentDictionary withCompletion:(void(^)(NSString *transactionID, NSError* error))completion;

-(void)getCartDetailsForOrderSummaryWithCompletion:(void(^)(IMCart* cart, NSError* error))completion;
-(void) paymentFailedForOrderWithId:(NSNumber*)orderId withCart:(IMCart*)cart withCompletion:(void(^)(NSDictionary *responseDictionary,NSError* error))completion;

@end
