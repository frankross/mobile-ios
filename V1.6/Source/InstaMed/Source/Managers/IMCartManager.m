//
//  IMCartManager.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartManager.h"
#import "IMServerManager.h"
#import "IMCart.h"
#import "IMAccountsManager.h"
#import "IMCacheManager.h"

@implementation IMCartManager


+(IMCartManager*)sharedManager
{
    static IMCartManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.currentCart = [[IMCart alloc] init];
        sharedManager.currentCart.lineItems = [sharedManager getCurrentCartItemsFromCache];
       
    });
    return sharedManager;
}

-(void)fetchCartWithCompletion:(void(^)(IMCart* cart, NSError* error))completion
{
    
    if(nil == [[IMAccountsManager sharedManager] userToken])
    {
        
        if(self.currentCart.lineItems.count)
        {
            NSMutableString* queryString = [NSMutableString string];
            [queryString appendString:@"?"];
            
            for (IMLineItem* lineItem in self.currentCart.lineItems)
            {
                [queryString appendFormat:@"line_items[][variant_id]=%@&line_items[][quantity]=%ld",lineItem.identifier,(long)lineItem.quantity];
                if(lineItem != self.currentCart.lineItems.lastObject)
                {
                    [queryString appendString:@"&"];
                }
            }
            
            [[IMServerManager sharedManager] fetchCartItemsForLineItemsQueryString:queryString withCompletion:^(NSDictionary *cartResponseDict, NSError *error)
             {
                 if(!error)
                 {
                     self.currentCart = [[IMCart alloc] initWithDictionary:cartResponseDict];
                 }
                 completion(self.currentCart,error);
             }];
        }
        else
        {
            completion(self.currentCart,nil);
        }
    }
    else
    {
        
        [[IMServerManager sharedManager] fetchCartItemsWithCompletion:^(NSDictionary *cartResponseDict, NSError *error) {
            if(!error)
            {
                self.currentCart = [[IMCart alloc] initWithDictionary:cartResponseDict];
            }
            completion(self.currentCart,error);
            
        }];
    }
    
   

}



-(NSArray*)updatedLineItemsFromCurrentCart:(NSArray*)lineItems
{
    
    NSMutableArray* updatedLineItems = [NSMutableArray array];
    
    for(IMLineItem* lineItem in lineItems)
    {
        IMLineItem* updatedLineItem = [[IMLineItem alloc] init];
        updatedLineItem.identifier = lineItem.identifier;
        updatedLineItem.quantity = lineItem.quantity;
        for (IMLineItem* cartItem in self.currentCart.lineItems)
        {
            if([cartItem.identifier isEqual:lineItem.identifier])
            {
                updatedLineItem.quantity = MIN(cartItem.maxOrderQuanitity.integerValue, cartItem.quantity + lineItem.quantity);
                break;
            }
        }
        [updatedLineItems addObject:updatedLineItem];
    }
    return updatedLineItems;
}

-(void)reorderFromOrder:(IMOrder*)order withCompletion:(void(^)(NSError *error))completion
{
    
    [self updateCartItems:[self updatedLineItemsFromCurrentCart:order.orderedItems] withCompletion:^(IMCart *cart, NSError *error)
    {
        completion(error);
    }];
}

//-(void)fetchCartItemsWithCompletion:(void(^)(NSArray* cartItems,NSDictionary* ordrerCalculations, NSError* error))completion
//{
//    if([[IMAccountsManager sharedManager] userToken])
//    {
//        
//        [[IMServerManager sharedManager] fetchCartItemsWithCompletion:^(NSDictionary *cartItems, NSError *error) {
//            if(!error)
//            {
//                NSMutableArray* cartItemArray = [NSMutableArray array];
//                
//                NSMutableDictionary* cart = [cartItems[@"cart"] mutableCopy];
//                
//                for(NSDictionary* cartItemDict  in cart[@"line_items"])
//                {
//                    IMLineItem* cartItem = [[IMLineItem alloc] initWithDictionary:cartItemDict];
//                    [cartItemArray addObject:cartItem];
//                    
//                }
//                [cart removeObjectForKey:@"line_items"];
//                completion(cartItemArray,cart,nil);
//            }
//            else
//                completion(nil,nil,error);
//        }];
//    }
//    else
//    {
//        [[IMServerManager sharedManager] fetchCartItemCalculationsForLineItemsQueryString:@"" withCompletion:^(NSDictionary *cartItems, NSError *error) {
//        }];
//    }
//    
//}


-(void)updateCartItems:(NSArray*)cartItems withCompletion:(void(^)(IMCart* cart, NSError* error))completion
{
    
    if([[IMAccountsManager sharedManager] userToken])
    {
        
        NSMutableArray* cartItemArray = [NSMutableArray array];
        
        for (IMLineItem* cartItem in cartItems)
        {
            NSDictionary *cartItemDict = [cartItem dictionaryForAddToCart];
            if (cartItemDict) {
                [cartItemArray addObject:cartItemDict];
            }
        }
        
        [[IMServerManager sharedManager] updateCartItems:@{@"line_items":cartItemArray} withCompletion:^(NSDictionary *cartResponseDict, NSError *error) {
            if(!error)
            {
                self.currentCart = [[IMCart alloc] initWithDictionary:cartResponseDict];
            }
            completion(self.currentCart,error);
        }];
    }
    else
    {
        IMLineItem* lineItemToBeAdded = cartItems[0];
        BOOL lineAlreadyPresent = NO;
        
        for(IMLineItem* lineItem in self.currentCart.lineItems)
        {
            if([lineItem.identifier isEqual:lineItemToBeAdded.identifier])
            {
                lineItem.quantity = lineItemToBeAdded.quantity;
                lineAlreadyPresent = YES;
                break;
            }
        }
        
        if(!lineAlreadyPresent)
        {
            [self.currentCart.lineItems addObject:lineItemToBeAdded];
        }
        
        [self fetchCartWithCompletion:^(IMCart *cart, NSError *error) {
            
            if(!error)
            {
                [self saveCurrentCartItems];
            }
            else
            {
                self.currentCart.lineItems = [self getCurrentCartItemsFromCache];
            }
            completion(self.currentCart,error);
            
        }];
    }
}//Update if already exists in the cart

-(void)deleteCartItemWithId:(NSNumber*)cartItemId withCompletion:(void(^)(IMCart* cart, NSError* error))completion

{
    if([[IMAccountsManager sharedManager] userToken])
    {
        
        [[IMServerManager sharedManager] deleteCartItem:cartItemId withCompletion:^(NSDictionary *cartResponseDict, NSError *error)
         {
             if(!error)
             {
                 self.currentCart = [[IMCart alloc] initWithDictionary:cartResponseDict];
             }
             completion(self.currentCart,error);
         }];
    }
    else
    {
        IMLineItem* lineItemToBeDeleted;
        for(IMLineItem* lineItem in self.currentCart.lineItems)
        {
            if([lineItem.identifier isEqual:cartItemId])
            {
                lineItemToBeDeleted = lineItem;
                break;
            }
        }
        [self.currentCart.lineItems removeObjectIdenticalTo:lineItemToBeDeleted];
        
        
        [self fetchCartWithCompletion:^(IMCart *cart, NSError *error) {
            
            if(!error)
            {
                [self saveCurrentCartItems];
                
            }
            else
            {
                self.currentCart.lineItems = [self getCurrentCartItemsFromCache];
            }
             completion(self.currentCart,error);
            
        }];
        
    }

}

-(void)saveCurrentCartItems
{
    NSMutableArray* lineItemArray =   [NSMutableArray array];
    
    for(IMLineItem* lineItem in self.currentCart.lineItems)
    {
        NSDictionary *lineItemDict = [lineItem dictionaryForAddToCart];
        if (lineItemDict) {
            [lineItemArray addObject:lineItemDict];
        }
    }
    
    [[IMCacheManager sharedManager] saveCartItems:lineItemArray];
}

-(NSMutableArray*)getCurrentCartItemsFromCache
{
    NSArray* cartItemArray =  [[IMCacheManager sharedManager] getCartItems];
    NSMutableArray* cartItems = [NSMutableArray array];
    
    for(NSDictionary* cartItemDict in cartItemArray)
    {
        IMLineItem* lineItem = [[IMLineItem alloc] initWithDictionary:cartItemDict];
        [cartItems addObject:lineItem];
    }
    return cartItems;
    
}

-(void)fetchFullfillmentCenterIDForCart:(IMCart *)cart withCompletion:(void(^)(NSNumber *fulfillemntCenterID, NSError* error))completion
{
    
    [[IMServerManager sharedManager] fetchFullfillmentCenterIDForCartDetail:[cart dictionaryForOrderFullfillmentCenter] withCompletion:^(NSNumber *fulfillemntCenterID, NSError *error) {
        completion(fulfillemntCenterID,error);
    }];
}

-(void)fetchDeliverySlotsForAreaId:(NSNumber*)areaId withFullfillmentCenterID:(NSNumber *)fullfillmentCenterID withPrescription:(BOOL)withPrescription withCompletion:(void(^)(NSMutableArray* deliverySlots, NSError* error))completion
{
    [[IMServerManager sharedManager] fetchDeliverySlotsForAreaId:areaId withFullfillmentCenterID:fullfillmentCenterID withPrescription:withPrescription withCompletion:^(NSMutableDictionary *deliverySlotArray, NSError *error)
    {
        NSMutableArray* deliverySlots = [NSMutableArray array];
        if(!error)
        {
            
            for (NSDictionary* deliverySlotDict in deliverySlotArray[@"delivery_slots"])
            {
                IMDeliverySlot* deliverySlot = [[IMDeliverySlot alloc] initWithDictionary:deliverySlotDict];
                [deliverySlots addObject:deliverySlot];
            }
        }
        completion(deliverySlots,error);
    }];
}


-(NSInteger)quantityOfCartLineItemWithVariantId:(NSNumber*)variantId
{
    NSInteger quantity = 0;
    
    for(IMLineItem* cartItem in self.currentCart.lineItems)
    {
        if([cartItem.identifier isEqual:variantId])
        {
            quantity = cartItem.quantity;
            break;
        }
    }
    return quantity;
}

-(void)checkOutUserCart:(IMCart *)cart WithCompletion:(void(^)(NSNumber* orderId,  NSError* error))completion
{
    [[IMServerManager sharedManager] checkOutUserCartWithDictionary:[cart dictionaryForOrderCheckOut] Completion:^(NSDictionary *orderIdDict, NSError *error) {
        completion(orderIdDict[@"order"][@"id"],error);
    }];
}



-(void)completeOrderWithId:(NSNumber*)orderId withCart:(IMCart*)cart withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] completeOrderWithId:orderId withCart:[cart dictionaryForOrderComplete] withCompletion:^(NSError *error)
    {
        if(!error)
        {
            [IMAccountsManager sharedManager].currentOrderPrescriptionUploadId = nil;
        }
        completion(error);
    }];
}

-(void) paymentFailedForOrderWithId:(NSNumber*)orderId withCart:(IMCart*)cart withCompletion:(void(^)(NSDictionary *responseDictionary,NSError* error))completion
{
    [[IMServerManager sharedManager] paymentFailedForOrderWithId:orderId withCart:[cart dictionaryForPaymentFailure] withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        
        completion(responseDictionary,error);
        
    }];
}


-(void)updateOrder:(IMOrder*)order withCart:(IMCart*)cart withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] updateOrderWithId:order.identifier info:[cart dictionaryForOrderUpdate] withCompletion:^(NSError *error)
     {
         if(!error)
         {
             [IMAccountsManager sharedManager].currentOrderRevisePrescriptionUploadId = nil;
         }
         completion(error);
     }];
}

-(void)applyCoupon:(NSString*)coupon withCart:(IMCart*)cart withCompletion:(void(^)(IMCart* cart,NSError* error))completion
{
    [[IMServerManager sharedManager] applyCartCouponWithDetails:[cart dictionaryForCouponApply:coupon] andCompletion:^(NSDictionary *cartDict, NSError *error) {
        if(!error)
        {
            self.currentCart = [[IMCart alloc] initWithDictionary:cartDict];
        }
        completion(self.currentCart,error);
    }];
}

-(void)removeCoupon:(NSString*)coupon withCart:(IMCart*)cart withCompletion:(void(^)(IMCart* cart,NSError* error))completion
{
    [[IMServerManager sharedManager] removeCartCouponWithDetails:[cart dictionaryForCouponApply:coupon] andCompletion:^(NSDictionary *cartDict, NSError *error) {
        if(!error)
        {
            self.currentCart = [[IMCart alloc] initWithDictionary:cartDict];
        }
        completion(self.currentCart,error);
    }];
}

-(void)updateCart:(IMCart *)cart withOrderId:(NSNumber *)orderId andInfo:(NSDictionary *) dictionary forApplyWalletWithCompletion:(void (^)(IMCart *, NSError *))completion
{
    [[IMServerManager sharedManager] updateUserCartWithOrderID:orderId forApplyWalletWithDictionary:dictionary Completion:^(NSDictionary *cartResponseDict, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            if(!error)
            {   IMCart *cart = [[IMCart alloc] initWithDictionary:cartResponseDict];
                [self.currentCart updateCartForApplyWalletWithCart:cart];
            }
            completion(self.currentCart,error);
        });
     }];
    
}

//-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId info:(NSDictionary*)initiatePaymentDictionary withCompletion:(void(^)(NSString *transactionID, NSError* error))completion
//{
//    [[IMServerManager sharedManager] initiatePrepaidPaymentWithOrderId:orderId info:initiatePaymentDictionary withCompletion:^(NSDictionary *responseDict, NSError *error) {
//        if(!error)
//        {
//            NSString *transactionID = responseDict[@"transaction_id"];
//            completion(transactionID,nil);
//        }
//        else
//        {
//            completion(nil,error);
//        }
//    }];
//}


-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId andCart:(IMCart *)cart withCompletion:(void(^)(NSString *transactionID, NSError* error))completion
{
    [[IMServerManager sharedManager] initiatePrepaidPaymentWithOrderId:orderId info:[cart dictionaryForPaymentInitiation] withCompletion:^(NSDictionary *responseDict, NSError *error) {
        if(!error)
        {
            NSString *transactionID = responseDict[@"transaction_id"];
            completion(transactionID,nil);
        }
        else
        {
            completion(nil,error);
        }
    }];
}

-(void)getCartDetailsForOrderSummaryWithCompletion:(void(^)(IMCart* cart, NSError* error))completion
{
    
    [[IMServerManager sharedManager] fetchCartItemsWithCompletion:^(NSDictionary *cartResponseDict, NSError *error) {
        IMCart *cart;
        if(!error)
        {
            cart = [[IMCart alloc] initWithDictionary:cartResponseDict];
            [self.currentCart updateWithCart:cart];
        }
        completion(self.currentCart,error);
        
    }];
}






@end
