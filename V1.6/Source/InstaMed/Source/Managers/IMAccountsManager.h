//
//  IMAccountsManager.h
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "IMUser.h"
#import "IMAddress.h"
#import "IMOrder.h"
#import "IMPlaceOrder.h"
#import "IMPrescription.h"
#import "IMCancelReason.h"




//Dynamic notifications, Orders(Viewing and placing), Prescriptions,Address Management


@interface IMAccountsManager : NSObject


+ (IMAccountsManager *)sharedManager;

//- (void)setUserID:(NSString *)uID;
//- (void)setUserName:(NSString *)userName;
//- (void)setUserEmailAddess:(NSString *)emailAddess;
//- (void)setUserMobileNumber:(NSString *)mobileNumber;
//- (void)setUserPassword:(NSString *)password;
//- (void)setLoginChannel:(IMLoginType)loginChannel;
//- (void)setLoggedIn:(BOOL)loggedIn;
//
//- (NSString *)userID;
//- (NSString *)userName;
//- (NSString *)userEmailAddess;
//- (NSString *)userMobileNumber;
//- (NSString *)userPassword;

@property (strong,nonatomic) IMUser* currentLoggedInUser;

-(NSString*)userToken;
-(void)setUserToken:(NSString*)userToken;

-(NSString*)userName;
-(void)setUserName:(NSString*)userName;

- (NSString *) userID;
- (void) setUserID:(NSString*)userID;

- (BOOL) isRegistered;
- (void) setIsRegistered:(BOOL) isRegistered;

- (void) setIsReferredUser:(BOOL) isReferredUser;
- (BOOL) isReferredUser;

//-(NSString*)deviceToken;
//-(void)setDeviceToken:(NSString*)token;


@property(nonatomic,strong)NSNumber* currentPrescriptionUploadId;
@property(nonatomic,strong)NSNumber* currentOrderPrescriptionUploadId;

@property(nonatomic,strong)NSNumber* currentRevisePrescriptionUploadId;
@property(nonatomic,strong)NSNumber* currentOrderRevisePrescriptionUploadId;

@property(nonatomic,assign) BOOL needToReload;


#pragma mark - Login/Registration -


-(void)logInWithUser:(IMUser*)user withCompletion:(void(^)(NSError* error))completion;
-(void)registerUser:(IMUser*)user withCompletion:(void(^)( NSDictionary *responseDict,NSError* error))completion;
-(void)registerSocialChannelLoggedUser:(IMUser*)user withCompletion:(void(^)( NSDictionary *responseDict,NSError* error))completion;
-(void)forgotPassword:(IMUser*)user withCompletion:(void(^)(NSError* error))completion;
-(void)verifyOTP:(NSString*)otp forEmailId:(NSString*)emailId withCompletion:(void(^)(NSError* error))completion;
-(void)verifyOTP:(NSString*)otp forPhoneNumber:(NSString*)phoneNumber withCompletion:(void(^)(NSError* error))completion;
- (void)updatePasswordUsingOTP:(NSString *)otp newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(NSError* error))completion;

-(void)resendOTPForEmailId:(NSString*)emailId withCompletion:(void(^)(NSDictionary* messageDIctionary, NSError* error))completion;
- (void)generateOTPForPhoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(BOOL success, NSString *message))completion;

-(void)logOutWithCompletion:(void(^)(NSError* error))completion;

#pragma mark - User Info -

-(void)fetchUserWithCompletion:(void(^)(IMUser* user,NSError* error))completion;
-(void)updateUser:(IMUser*)user withCompletion:(void (^)(NSError *error))completion;
-(void)updatePasswordWithOldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword withCompletion:(void (^)(NSError *error))completion;
- (void)updatePhoneNumber:(NSString *)mobileNumber withEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(NSError *error))completion;
-(void) updatePhoneNumberForSocialUserWithUserInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion;

#pragma mark - Address Management -

-(void)fetchAddressesWithCompletion:(void(^)(NSMutableArray* addresses,NSError* error))completion;
-(void)addAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion;
-(void)updateAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion;
-(void)deleteAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion;
-(void)setDefaultAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion;

#pragma mark - Dynamic Notifications -

-(void)fetchDynamicNotificationsWithCompletion:(void(^)(NSArray* notifications,NSError* error))error;

#pragma mark - Orders -

-(void)fetchOrdersForPage:(NSInteger ) currentPage withProductsPerPage:(NSInteger) productsPerPage withCompletion:(void(^)(NSArray* orders, NSInteger totalPageCount,NSInteger totalOrderCount,NSError* error))completion;
-(void)fetchOrderDetailWithOrderId:(NSNumber*)orderId  completion:(void(^)(IMOrder* order,NSError* error))completion;

-(void)exportToMailOrders:(NSString*)orderId withCompletion:(void(^)(NSError* error))error;
-(void)reorderWithOrderId:(NSString*)orderId completion:(void(^)(NSError* error))error;
-(void)cancelOrderWithId:(NSNumber*)orderId orderCanecelInfo:(IMCancelReason*)cancelInfo completion:(void(^)(NSString* message, NSError* error))completion;

-(void)setReorderReminderForOrder:(NSNumber*)orderId withDuration:(NSString*)duration durationUnit:(NSString*)durationUnit completion:(void(^)(NSString* message, NSError* error))completion;

-(void)fetchOrderCancellationReasonsWithCompletion:(void(^)(NSMutableArray* cancellationReasons, NSError* error))completion;
-(void)resetReminderWithOrderId:(NSNumber*)orderId withCompletion:(void(^)(NSError* error))completion;

-(void)placeOrder:(IMPlaceOrder*)placeOrder withCompletion:(void(^)(NSError* error))error;

#pragma mark - Prescriptions -
-(void)fetchPresciptionsWithCompletion:(void(^)(NSArray* undigitisedPrescriptionImages,NSMutableArray* digitisedPrescriptions,NSError* error))completion;
-(void)fetchPrescriptionDetailWithId:(NSNumber*)prescriptionId completion:(void(^)(IMPrescription* prescription,NSError* error))completion;

-(void)uploadPrescription:(UIImage*)prescriptionImage andCartCreationStatus:(BOOL)status withCompletion:(void(^)(NSNumber* prescriptionId,NSError* error))completion;
-(void)uploadPrescriptionForOrderRevise:(UIImage*)prescriptionImage withCompletion:(void(^)(NSNumber* prescriptionId,NSError* error))completion;

-(void)completePrescriptionUploadWithCompletion:(void(^)(NSError* error))completion;
-(void)completePrescriptionUploadForOrderReviseWithCompletion:(void(^)(NSError* error))completion;

-(void)orderFromPrescription:(IMPrescription*)prescription withCompletion:(void(^)(NSError *error))completion;

- (void)logInSocialUserWithUser:(IMUser *)user withCompletion:(void (^)(NSError *error))completion;


#pragma mark - Others -

- (void)saveProfile;



@end
