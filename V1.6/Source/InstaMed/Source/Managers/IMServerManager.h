//
//  IMServerManager.h
//  InstaMed
//
//  Created by Arjuna on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

//For all server interations
@interface IMServerManager : NSObject

+(IMServerManager*)sharedManager;

-(void)setHeaderValue:(NSString*)value forKey:(NSString*)key;

-(BOOL)isNetworkAvailable;

- (NSString *)currentAPIVersion;

-(void)fetchUnreadNotificationCountWithCompletion:(void (^)(NSDictionary *responseDictionary, NSError *error))completion;

-(void)fetchNotificationsWithCompletion:(void (^)(NSDictionary *responseDictionary, NSError *error))completion;

-(void)updateNotificationsCountWithCompletion:(void (^)(NSError *error))completion;

-(void)logInWithUser:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion;

-(void)logInSocialUserWithUserDetails:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion;

-(void)logOutWithUser:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion;

-(void)registerUser:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion;

-(void)registerSocialLoggedInUser:(NSDictionary *)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion;

-(void)verifyOTP:(NSString*)otp withUserInfo:(NSDictionary*)userInfo withCompletion:(void(^)(NSError* error))completion;
- (void)updatePasswordUsingOTP:(NSString *)otp newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(NSError* error))completion;

- (void)generateOTPForPhoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(BOOL success, NSString *message))completion;


-(void)resendOTPForUserInfo:(NSDictionary*)userInfo withCompletion:(void(^)(NSDictionary* messageDictionary, NSError* error))completion;


-(void)fetchUserWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

-(void)updateUser:(NSDictionary *)user withCompletion:(void(^)(NSError* error))completion;

-(void)updatePasswordFromPasswordDictionary:(NSDictionary*)passwordDictionary withCompletion:(void (^)(NSError *error))completion;

-(void)fetchAddressesWithCompletion:(void (^)(NSDictionary * addressDictionary, NSError * error))completion;

-(void)addAddress:(NSDictionary *)address withCompletion:(void (^)(NSError *))completion;

-(void)updateAddress:(NSMutableDictionary*)addressDictionary withCompletion:(void (^)(NSError *))completion;

-(void)deleteAddressWithId:(NSNumber*)addressId withCompletion:(void (^)(NSError *))completion;


-(void)fetchDeliverySupportedLocationsWithParameters:(NSDictionary*)parmaters withCompletion:(void(^)(NSDictionary* locationDictionary,NSError* error))completion;


-(void)fetchFeaturedCategoriesWithCompletion:(void(^)(NSDictionary* dictionary,NSError* error))completion;

-(void)fetchCategoriesWithCompletion:(void(^)(NSDictionary* categoriesDictionary,NSError* error))completion;
-(void)fetchCategoriesWithId:(NSNumber *)catId Completion:(void(^)(NSDictionary* categoriesDictionary,NSError* error))completion;


-(void)fetchProductDetailWithId:(NSNumber*)productId withCompletion:(void(^)(NSDictionary* productDict,NSError* error))completion;

-(void)notifyUserForProductWithID:(NSNumber*)productId andUserDictionary:(NSDictionary*)userDictionary withCompletion:(void(^)(NSError* error))completion;

//-(void)fetchCartItemsWithCompletion:(void(^)(NSArray* cartItems,NSError* error))completion;
-(void)fetchCartItemsWithCompletion:(void(^)(NSDictionary* cartResponseDict,NSError* error))completion;

-(void)fetchCartItemsForLineItemsQueryString:(NSString*)lineItemsQureryString withCompletion:(void(^)(NSDictionary* cartItems,NSError* error))completion;

-(void)fetchOrderDetailWithOrderId:(NSNumber*)orderId  completion:(void(^)(NSDictionary* response,NSError* error))completion;

-(void)fetchOrdersForPage:(NSInteger )currentPage withProductsPerPage:(NSInteger ) productsPerPage withCompletion:(void(^)(NSDictionary* ordersDict,NSError* error))completion;

-(void)resetReminderWithOrderId:(NSNumber*)orderId withCompletion:(void(^)(NSError* error))completion;

-(void)fetchOrderCancellationReasonsWithCompletion:(void(^)(NSMutableArray* cancellationReasons, NSError* error))completion;


-(void)updateCartItems:(NSDictionary*)cartItemDictionary withCompletion:(void(^)(NSDictionary* cartResponseDict,NSError* error))completion;

-(void)deleteCartItem:(NSNumber*)cartItemId withCompletion:(void(^)(NSDictionary* cartResponseDict,NSError* error))completion;


-(void)fetchPrescriptionsWithCompletion:(void(^)(NSDictionary* prescriptionsResponseDict,NSError* error))completion;

-(void)fetchPrescriptionDetailWithId:(NSNumber*)prescriptionId withCompletion:(void(^)(NSDictionary* precriptionDict,NSError* error))completion;

-(void)createPrescriptionWithDictionary:(NSDictionary*)prescriptionDictionary withCompletion:(void(^)(NSDictionary* precriptionResponseDict,NSError* error))completion;

-(void)updatePrescriptionWithId:(NSNumber*)prescriptionId andPrescriptionDictionary:(NSDictionary*)prescriptionDictionary withCompletion:(void(^)(NSError* error))completion;

-(void)completePrescriptionUploadWithId:(NSNumber*)prescriptionId withCompletion:(void(^)(NSError* error))completion;

-(void)checkOutUserCartWithDictionary:(NSDictionary *)dictionary Completion:(void(^)(NSDictionary* orderIdDict,  NSError* error))completion;

-(void)completeOrderWithId:(NSNumber*)orderId withCart:(NSDictionary*)cartDictionary withCompletion:(void(^)(NSError* error))completion;

-(void)paymentFailedForOrderWithId:(NSNumber*)orderId withCart:(NSDictionary*)cartDictionary withCompletion:(void(^)(NSDictionary *responseDictionary,NSError* error))completion;

-(void)updateOrderWithId:(NSNumber*)orderId info:(NSDictionary*)orderDictionary withCompletion:(void(^)(NSError* error))completion;

-(void)setReorderReminderForOrderWithId:(NSNumber*)orderId reminderInfo:(NSDictionary*)reminderInfo completion:(void(^)(NSDictionary* messageDict, NSError* error))completion;

-(void)cancelOrderWithId:(NSNumber*)orderId withOrderInfoDict:(NSDictionary*)cancelInfoDict withCompletion:(void(^)(NSDictionary* messageDict, NSError* error))completion;

-(void)fetchRecentlyOrderedPharmaProductsWithQueryString:(NSString*)queryString withCompletion:(void(^)(NSDictionary* messageDict, NSError* error))completion;

-(void)fetchFullfillmentCenterIDForCartDetail:(NSDictionary *)cartDictionary withCompletion:(void(^)(NSNumber *fulfillemntCenterID, NSError* error))completion;

-(void)fetchDeliverySlotsForAreaId:(NSNumber*)areaId withFullfillmentCenterID:(NSNumber *)fullfillmentCenterID withPrescription:(BOOL)withPrescription withCompletion:(void(^)(NSMutableDictionary* deliverySlots, NSError* error))completion;

- (void)getCurrentCityDetailsWithCompletion:(void(^)(NSMutableDictionary* cityDictioary, NSError *error))completion;

- (void)updatePhoneNumber:(NSDictionary *)phoneInfo withCompletion:(void (^)(NSError *))completion;

- (void)updatePhoneNumberForSocialUserWithUserInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *))completion;

- (void)checkAPIValiditywithCompletion:(void(^)(NSDictionary* infoDictionary, NSError* error))completion;

-(void)fetchNearbyStoresWithParameters:(NSDictionary*)parameters withCompletion:(void(^)(NSArray* stores, NSError* error))completion;

-(void)fetchOffersWithCompletion:(void(^)(NSDictionary* offers,NSError* error))completion;

-(void) fetchOffersForListingPageWithCompletion:(void (^)(NSDictionary *offers,NSError *error))completion;

-(void)registerDeviceWithDictionary:(NSDictionary *)dictionary andCompletion:(void(^)(NSError* error))completion;

-(void)unRegisterDeviceWithDictionary:(NSString *)tocken andCompletion:(void(^)(NSError* error))completion;

/**
 @brief To apply coupon for the cart.
 @brief On success, updated cart details is returned.
 @brief On failure, error explaining the reason is returned.
 @param couponDetail: NSDictionary* The dictionary containing the coupon code
 @param completion: The completion block
 @returns void
 */
-(void)applyCartCouponWithDetails:(NSDictionary *)couponDetail andCompletion:(void(^)(NSDictionary* cartDict, NSError* error))completion;
/**
 @brief To remove coupon for the cart.
 @brief On success, updated cart details is returned.
 @brief On failure, error explaining the reason is returned.
 @param couponDetail: NSDictionary* The dictionary containing the coupon code
 @param completion: The completion block
 @returns void
 */
-(void)removeCartCouponWithDetails:(NSDictionary *)couponDetail andCompletion:(void(^)(NSDictionary* cartDict, NSError* error))completion;

-(void)fetchFAQCategoriesWithCompletion:(void(^)(NSDictionary* FAQDictionary,NSError* error))completion;
-(void)fetchFAQListForID:(NSNumber  *)ID WithCompletion:(void(^)(NSDictionary* FAQDictionary,NSError* error))completion;

-(void)getHealthWalletDetailsWithCompletion:(void(^)(NSNumber *earnedAmount,NSNumber *spendAmount,NSNumber *availableAmount,NSArray* transactions,NSString *message,NSError* error))completion;

-(void)updateUserCartWithOrderID:(NSNumber *) orderID forApplyWalletWithDictionary:(NSDictionary *)dictionary Completion:(void(^)(NSDictionary* cartResponseDict,  NSError* error))completion;


-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId info:(NSDictionary*)initiatePaymentDictionary withCompletion:(void(^)(NSDictionary *responseDict, NSError* error))completion;

-(void) fetchAppSettingsDetailsWithCompletion:(void(^)(NSDictionary* appSettingsDictionary,NSError* error))completion;
-(void) fetchFeaturedTagsWithFeaturesDictionary:(NSDictionary*)featuresDictionary withCompletion:(void(^)(NSDictionary *responseDict, NSError* error))completion;
-(void) fetchUserReferralDetailsWithCompletion:(void(^)(NSDictionary* referralDictionary,NSError* error))completion;
@end
