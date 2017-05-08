//
//  IMAccountsManager.m
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMLoginViewController.h"
#import "IMAccountsManager.h"
#import "IMBranchServiceManager.h"
#import "IMServerManager.h"
#import "IMLocationManager.h"
#import "IMAddress.h"
#import "IMPrescription.h"
#import "IMCartManager.h"
#import "IMCacheManager.h"



const NSString* const IMResponseAuthTokenKey = @"auth_token";

@interface IMAccountsManager ()

@property (strong, nonatomic) NSMutableDictionary *profile;


@end

@implementation IMAccountsManager


+(IMAccountsManager*)sharedManager
{
    static IMAccountsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        NSString* userToken = [sharedManager userToken];
        if(userToken)
        {
            [[IMServerManager sharedManager] setHeaderValue:userToken forKey:IMAuthTokenHeaderKey];
        }
//        sharedManager.needToReload = YES;
        
    });
    return sharedManager;
}

-(NSString*)userToken
{


//   return @"Gc9D7-N6Q66jLLT7hb7i";
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:IMAuthTokenHeaderKey];


}

-(void)setUserToken:(NSString*)userToken
{
    if(userToken)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:IMAuthTokenHeaderKey];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IMAuthTokenHeaderKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) userID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:IMUserIDKey];
}

- (void) setUserID:(NSString*)userID
{
    if(userID)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:IMUserIDKey];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IMUserIDKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSString*)userName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:IMUserNameKey];
}


-(void)setUserName:(NSString*)userName
{
    if(userName)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:IMUserNameKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IMUserNameKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void) setIsRegistered:(BOOL) isRegistered
{
    if(isRegistered)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isRegistered] forKey:IMIsRegisteredPreferenceKey];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IMIsRegisteredPreferenceKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isRegistered
{
    NSNumber *isRegistered =  [[NSUserDefaults standardUserDefaults] objectForKey:IMIsRegisteredPreferenceKey];
    return [isRegistered boolValue];
}

- (BOOL) isReferredUser
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IMSuccessfulReferralPreferenceKey];
}

- (void) setIsReferredUser:(BOOL) isReferredUser
{

    [[NSUserDefaults standardUserDefaults] setBool:isReferredUser forKey:IMSuccessfulReferralPreferenceKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Login/Registration -

-(void)logInWithUser:(IMUser *)user withCompletion:(void (^)(NSError *))completion
{

        [[IMServerManager sharedManager] logInWithUser: [user dictionaryForLogin] withCompletion:^(NSDictionary *userDictionary, NSError *error) {
            
            if(userDictionary)
            {
                
                
                [[IMServerManager sharedManager] setHeaderValue:userDictionary[@"user"][IMResponseAuthTokenKey] forKey:IMAuthTokenHeaderKey];
                self.userToken = userDictionary[@"user"][IMResponseAuthTokenKey];

                [self fetchUserWithCompletion:^(IMUser *user, NSError *error) {
                    NSString *savedPhoneNumber = [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"userMobile"];
                    
                    if([savedPhoneNumber isEqualToString:user.mobileNumber])
                    {
                        self.needToReload = NO;
                    }
                    else
                    {
                        self.needToReload = YES;
                    }
                    self.userName = user.name;
                    self.userID = [user.identifier stringValue];
                    NSString *valueToSave = user.mobileNumber;
                    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userMobile"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[IMBranchServiceManager getBranchInstance] setIdentity:[user.identifier stringValue]];
                    if(self.isRegistered && self.isReferredUser)
                    {
                        [IMBranchServiceManager logBranchRegisterEvent];
                        self.isRegistered = NO;
                        self.isReferredUser = NO;
                    }
                }];
                
                NSArray* lineItems  = [IMCartManager sharedManager].currentCart.lineItems;
                if(lineItems.count)
                {
                    [[IMCartManager sharedManager] updateCartItems:lineItems withCompletion:^(IMCart *cart, NSError *error) {
                     
                        [[IMCacheManager sharedManager] clearCartItems];
                        completion(error);
                    }];
                }
                else
                {
                    [[IMCartManager sharedManager] fetchCartWithCompletion:^(IMCart *cart, NSError *error) {
                        
                    }];
                    completion(error);
                }
            }
            else
                completion(error);
      
        }];
//    }
}

-(void)registerUser:(IMUser*)user withCompletion:(void(^)( NSDictionary *responseDict,NSError* error))completion;
{
    
    [[IMServerManager sharedManager] registerUser:[user dictionaryForRegistration] withCompletion:^(NSDictionary* userDictionary, NSError *error)
    {
        if(userDictionary)
        {

            completion(userDictionary,nil);
            self.isRegistered = YES;
         
        }
        else
            completion(nil,error);
    }];
}

-(void)registerSocialChannelLoggedUser:(IMUser*)user withCompletion:(void(^)( NSDictionary *responseDict,NSError* error))completion
{
    [[IMServerManager sharedManager] registerSocialLoggedInUser:[user dictionaryForRegistrationUsingSocialLogin] withCompletion:^(NSDictionary *userDictionary, NSError *error) {
        if(userDictionary)
        {

            completion(userDictionary,nil);
            self.isRegistered = YES;
        }
        else
            completion(nil,error);
    }];
}

-(void)verifyOTP:(NSString*)otp forEmailId:(NSString*)emailId withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] verifyOTP:otp withUserInfo:@{@"email":emailId} withCompletion:^(NSError *error) {
        
        completion(error);
    }];
}

-(void)verifyOTP:(NSString*)otp forPhoneNumber:(NSString*)phoneNumber withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] verifyOTP:otp withUserInfo:@{@"phone_number":phoneNumber} withCompletion:^(NSError *error) {
        
        completion(error);
    }];

}


- (void)updatePasswordUsingOTP:(NSString *)otp newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(NSError* error))completion
{
    [[IMServerManager sharedManager] updatePasswordUsingOTP:otp newPassword:password phoneNumber:phoneNumber withCompletion:completion];
}

- (void)generateOTPForPhoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(BOOL success, NSString *message))completion
{
    [[IMServerManager sharedManager] generateOTPForPhoneNumber:phoneNumber withCompletion:completion];
}

-(void)resendOTPForEmailId:(NSString*)emailId withCompletion:(void(^)(NSDictionary* messageDIctionary, NSError* error))completion
{
    [[IMServerManager sharedManager] resendOTPForUserInfo:@{@"email":emailId}withCompletion:^(NSDictionary* messageDictionary, NSError *error) {
        
        completion(messageDictionary, error);
        
    }];
}

-(void)logOutWithCompletion:(void (^)(NSError *))completion
{
    
    
//    self.userToken = nil;
//    self.userName = nil;
//    
//    //    [[IMSocialManager sharedManager]clearSocialTokens];
//    [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
//    self.currentLoggedInUser = nil;
//    [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];
//    completion(nil);

    IMUser *user = [[IMUser alloc] init];
    [[IMServerManager sharedManager] logOutWithUser: [user dictionaryForLogOut] withCompletion:^(NSDictionary *userDictionary, NSError *error)
    {
        if(error == nil)
        {
            self.userToken = nil;
            self.userName = nil;
            self.userID = nil;
            
            //    [[IMSocialManager sharedManager]clearSocialTokens];
            [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
            [[IMBranchServiceManager getBranchInstance] logout];
            self.currentLoggedInUser = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];
            completion(nil);
        }
        else
        {
//            self.userToken = nil;
//            self.userName = nil;
//            
//            //    [[IMSocialManager sharedManager]clearSocialTokens];
//            [[IMCartManager sharedManager].currentCart.lineItems removeAllObjects];
//            self.currentLoggedInUser = nil;
//            [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];
//            completion(nil);
            completion(error);
        }
    }];
    
   
}

-(void)fetchUserWithCompletion:(void (^)(IMUser *user, NSError *error))completion
{
    [[IMServerManager sharedManager] fetchUserWithCompletion:^(NSDictionary *userDictionary, NSError * error)
    {
        IMUser* user = nil;
        if(userDictionary)
        {
            user  = [[IMUser alloc] initWithDictionary:userDictionary];
            self.currentLoggedInUser = user;
            self.userName = user.name;
            self.userID = [user.identifier stringValue];
        }
        completion(user,error);
    }];
}

-(void)updateUser:(IMUser*)user withCompletion:(void (^)(NSError *error))completion
{
    [[IMServerManager sharedManager] updateUser:[user dictionaryForUpdate] withCompletion:^(NSError *error) {
        completion(error);
    }];
}

-(void)updatePasswordWithOldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword withCompletion:(void (^)(NSError *error))completion
{
    [[IMServerManager sharedManager] updatePasswordFromPasswordDictionary:@{@"user" : @{@"old_password":oldPassword,@"new_password":newPassword} } withCompletion:^(NSError *error)
    {
                                                               completion(error);
                                                           }];
}

#pragma mark - Address Management -

-(void)fetchAddressesWithCompletion:(void(^)(NSMutableArray* addresses,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchAddressesWithCompletion:^(NSDictionary *addressDictionary, NSError *error) {
        NSMutableArray* addresses = [NSMutableArray array];
        for(NSDictionary* addressDict in addressDictionary[@"addresses"])
        {
            IMAddress* address = [[IMAddress alloc] initWithDictionary:addressDict];
            [addresses addObject:address];
        }
        completion(addresses,error);
    }];
}




-(void)addAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] addAddress:[address dictinaryRepresentation] withCompletion:^(NSError * error) {
        
        completion(error);
    }];
}

- (void)updateAddress:(IMAddress *)address withCompletion:(void (^)(NSError *))completion
{
    [[IMServerManager sharedManager] updateAddress:[address dictinaryRepresentation].mutableCopy  withCompletion:^(NSError *error) {
        completion(error);
    }];
}

-(void)setDefaultAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] updateAddress:[address dictionaryForDefaultAddress].mutableCopy  withCompletion:^(NSError *error) {
        completion(error);
    }];
}


-(void)deleteAddress:(IMAddress*)address withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] deleteAddressWithId:address.identifier withCompletion:^(NSError * error) {
        completion(error);
    }];
}

-(void)fetchOrderDetailWithOrderId:(NSNumber*)orderId  completion:(void(^)(IMOrder* order,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchOrderDetailWithOrderId:orderId completion:^(NSDictionary *response, NSError *error) {
        if(!error)
        {
            IMOrder *orderModel = [[IMOrder alloc] initWithDictionary:response[@"order"]];
            completion(orderModel,nil);
        }
        else
        {
            completion(nil,error);

        }
    }];
}

-(void)fetchOrdersForPage:(NSInteger ) currentPage withProductsPerPage:(NSInteger) productsPerPage withCompletion:(void(^)(NSArray* orders, NSInteger totalPageCount,NSInteger totalOrderCount,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchOrdersForPage:currentPage withProductsPerPage:productsPerPage withCompletion:^(NSDictionary *ordersDict, NSError *error)
     {
          NSMutableArray* orders = [NSMutableArray array];
         NSInteger totalPages;
         NSInteger totalRecords;
        
         if(!error)
         {
             for(NSDictionary* orderDict in ordersDict[@"orders"])
             {
                 IMOrder* order = [[IMOrder alloc] initWithDictionary:orderDict];
                 [orders addObject:order];
             }
            totalPages = [ordersDict[@"page_info"][@"total_pages"] integerValue];
            totalRecords = [ordersDict[@"page_info"][@"total_records"] integerValue];
         }
         completion(orders,totalPages,totalRecords,error);
     }];

}

-(void)fetchOrderCancellationReasonsWithCompletion:(void(^)(NSMutableArray* cancellationReasons, NSError* error))completion
{
    [[IMServerManager sharedManager] fetchOrderCancellationReasonsWithCompletion:^(NSMutableArray *cancellationReasons, NSError *error) {
        NSMutableArray* reasons = [NSMutableArray array];
        if(!error)
        {
           for(NSString* reasonString in cancellationReasons)
           {
               IMCancelReason* cancelReason = [[IMCancelReason alloc] init];
               cancelReason.reason = reasonString;
               cancelReason.remarks = @"";
               [reasons addObject:cancelReason];
           }
        }
        completion(reasons,error);
    }];
}


-(void)fetchPresciptionsWithCompletion:(void(^)(NSArray* undigitisedPrescriptionImages,NSMutableArray* digitisedPrescriptions,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchPrescriptionsWithCompletion:^(NSDictionary *prescriptionsResponseDict, NSError *error) {
        
        NSArray* undigitisedPrescriptionImageURLs = nil;
        NSMutableArray* digistisedPrescriptions = nil;
        
        if(!error)
        {
            undigitisedPrescriptionImageURLs = prescriptionsResponseDict[@"undigitisedImageURLs"];
            
            digistisedPrescriptions = [NSMutableArray array];
            
            for(NSDictionary* prescriptionDict in prescriptionsResponseDict[@"digitisedPrescriptions"])
            {
                IMPrescription* prescription = [[IMPrescription alloc] initWithDictionary:prescriptionDict];
                prescription.patient.name =  prescriptionDict[@"patientName"];
                prescription.doctor.name = prescriptionDict[@"doctorName"];
                prescription.dosageList = prescriptionDict[@"dosage"];
                [digistisedPrescriptions addObject:prescription];
            }
            
        }
        completion(undigitisedPrescriptionImageURLs,digistisedPrescriptions,error);
    }];
}

-(void)fetchPrescriptionDetailWithId:(NSNumber*)prescriptionId completion:(void(^)(IMPrescription* prescription,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchPrescriptionDetailWithId:prescriptionId withCompletion:^(NSDictionary *precriptionDict, NSError *error) {
        
        IMPrescription* prescription = nil;
        
        if(!error)
        {
            prescription = [[IMPrescription alloc] initWithDictionary:precriptionDict];
        }
        completion(prescription,error);
        
    }];
}

-(void)uploadPrescriptionForOrderRevise:(UIImage*)prescriptionImage withCompletion:(void(^)(NSNumber* prescriptionId,NSError* error))completion
{
    
    NSData *imageData =  UIImageJPEGRepresentation(prescriptionImage,0.5);
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    
    base64String = [@"data:image/jpeg;base64," stringByAppendingString:base64String];
    
    NSDictionary* prescriptionDictionary = @{@"prescription_upload":
                                                 @{@"image_upload":base64String}
                                             };
    
    if(self.currentRevisePrescriptionUploadId)
    {
        
        [[IMServerManager sharedManager] updatePrescriptionWithId:self.currentRevisePrescriptionUploadId  andPrescriptionDictionary:prescriptionDictionary withCompletion:^(NSError *error)
         {
             completion(self.currentRevisePrescriptionUploadId,error);
         }];
    }
    else
    {
        [[IMServerManager sharedManager] createPrescriptionWithDictionary:prescriptionDictionary withCompletion:^(NSDictionary *precriptionResponseDict, NSError *error) {
            if(!error)
            {
                self.currentRevisePrescriptionUploadId = precriptionResponseDict[@"prescription_upload"][@"id"];
                self.currentOrderRevisePrescriptionUploadId = self.currentRevisePrescriptionUploadId;
            }
            completion(self.currentRevisePrescriptionUploadId,error);
        }];
        
    }
}

-(void)uploadPrescription:(UIImage*)prescriptionImage andCartCreationStatus:(BOOL)status withCompletion:(void(^)(NSNumber* prescriptionId,NSError* error))completion
{
    
    NSData *imageData =  UIImageJPEGRepresentation(prescriptionImage,0.5);
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];

    base64String = [@"data:image/jpeg;base64," stringByAppendingString:base64String];
    
  
    
    if(self.currentPrescriptionUploadId)
    {

        NSDictionary* prescriptionDictionary = @{@"prescription_upload":
                                                     @{@"image_upload":base64String
                                                      }
                                                 };
        [[IMServerManager sharedManager] updatePrescriptionWithId:self.currentPrescriptionUploadId  andPrescriptionDictionary:prescriptionDictionary withCompletion:^(NSError *error)
        {
            completion(self.currentPrescriptionUploadId,error);
        }];
    }
    else
    {
        NSDictionary* prescriptionDictionary = @{@"prescription_upload":
                                                     @{@"image_upload":base64String,
                                                       @"prepare_cart":[NSNumber numberWithBool:status]}
                                                 };
        [[IMServerManager sharedManager] createPrescriptionWithDictionary:prescriptionDictionary withCompletion:^(NSDictionary *precriptionResponseDict, NSError *error) {
            if(!error)
            {
                self.currentPrescriptionUploadId = precriptionResponseDict[@"prescription_upload"][@"id"];
                self.currentOrderPrescriptionUploadId = self.currentPrescriptionUploadId;
            }
            completion(self.currentPrescriptionUploadId,error);
        }];
        
    }
}

-(void)completePrescriptionUploadForOrderReviseWithCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] completePrescriptionUploadWithId:self.currentRevisePrescriptionUploadId withCompletion:^(NSError *error) {
        if(!error)
        {
            self.currentRevisePrescriptionUploadId = nil;
        }
        
        completion(error);
    }];
}

-(void)completePrescriptionUploadWithCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] completePrescriptionUploadWithId:self.currentPrescriptionUploadId withCompletion:^(NSError *error) {
        if(!error)
        {
            self.currentPrescriptionUploadId = nil;
        }
        
        completion(error);
    }];
}


-(void)setReorderReminderForOrder:(NSNumber*)orderId withDuration:(NSString*)duration durationUnit:(NSString*)durationUnit completion:(void(^)(NSString* message, NSError* error))completion
{
    [[IMServerManager sharedManager] setReorderReminderForOrderWithId:orderId reminderInfo:@{@"duration":duration,@"duration_unit":durationUnit} completion:^(NSDictionary *messageDict, NSError *error)
    {
        completion(messageDict[IMMessage],error);
    }];
}

-(void)resetReminderWithOrderId:(NSNumber*)orderId withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] resetReminderWithOrderId:orderId withCompletion:^(NSError *error) {
        completion(error);
    }];
}

-(void)cancelOrderWithId:(NSNumber*)orderId orderCanecelInfo:(IMCancelReason*)cancelInfo completion:(void(^)(NSString* message, NSError* error))completion
{
    

    [[IMServerManager sharedManager] cancelOrderWithId:orderId withOrderInfoDict:[cancelInfo dictionaryForCancelling] withCompletion:^(NSDictionary* messageDict, NSError* error) {
        completion(messageDict[IMMessage],error);
    }];
}

- (void)forgotPassword:(IMUser *)user withCompletion:(void (^)(NSError *))completion
{
    
}

- (void)fetchDynamicNotificationsWithCompletion:(void (^)(NSArray *, NSError *))error
{
    
}

- (void)exportToMailOrders:(NSString *)orderId withCompletion:(void (^)(NSError *))error
{
    
}

- (void)placeOrder:(IMPlaceOrder *)placeOrder withCompletion:(void (^)(NSError *))error
{
    
}

- (void)reorderWithOrderId:(NSString *)orderId completion:(void (^)(NSError *))error
{
    
}

- (void)saveProfile
{
    
}

-(void)orderFromPrescription:(IMPrescription*)prescription withCompletion:(void(^)(NSError *error))completion
{
    NSMutableArray* lineItems = [NSMutableArray array];
    
    for(IMProductDosage* medicine in prescription.dosageList
        )
    {
        IMLineItem* lineItem = [[IMLineItem alloc] init];
        lineItem.identifier = medicine.identifier;
        lineItem.quantity = 1;
        [lineItems addObject:lineItem];
    }
    
    
    [[IMCartManager sharedManager] updateCartItems:[[IMCartManager sharedManager] updatedLineItemsFromCurrentCart:lineItems ] withCompletion:^(IMCart *cart, NSError *error) {
        completion(error);
    }];

}

- (void)updatePhoneNumber:(NSString *)mobileNumber withEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(NSError *error))completion{
    [[IMServerManager sharedManager] updatePhoneNumber:@{@"user": @{@"primary_phone":mobileNumber},
                                                         @"password":password,@"email":email} withCompletion:^(NSError * error) {
                                                            
                                                             completion(error);
    }];
}

-(void)updatePhoneNumberForSocialUserWithUserInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion
{
    [[IMServerManager sharedManager] updatePhoneNumberForSocialUserWithUserInfo:userInfo withCompletion:^(NSError *error) {
        completion(error);
    }];
}


- (void)logInSocialUserWithUser:(IMUser *)user withCompletion:(void (^)(NSError *error))completion
{
    [[IMServerManager sharedManager] logInSocialUserWithUserDetails:[user dictionaryForSocialLogin] withCompletion:^(NSDictionary *userDictionary, NSError *error) {
        
        if(userDictionary)
        {
            
            
            [[IMServerManager sharedManager] setHeaderValue:userDictionary[@"user"][IMResponseAuthTokenKey] forKey:IMAuthTokenHeaderKey];
            self.userToken = userDictionary[@"user"][IMResponseAuthTokenKey];
           
            [self fetchUserWithCompletion:^(IMUser *user, NSError *error) {
                NSString *savedPhoneNumber = [[NSUserDefaults standardUserDefaults]
                                              stringForKey:@"userMobile"];
                
                if([savedPhoneNumber isEqualToString:user.mobileNumber])
                {
                    self.needToReload = NO;
                }
                else
                {
                    self.needToReload = YES;
                }
                [IMFlurry setUserID:user.emailAddress];
                
                NSString *valueToSave = user.mobileNumber;
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userMobile"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.userID = [user.identifier stringValue];
                [[IMBranchServiceManager getBranchInstance] setIdentity:[user.identifier stringValue]];
                if(self.isRegistered && self.isReferredUser)
                {
                    [IMBranchServiceManager logBranchRegisterEvent];
                    self.isRegistered = NO;
                    self.isReferredUser = NO;
                }
                
            }];
            
            NSArray* lineItems  = [IMCartManager sharedManager].currentCart.lineItems;
            if(lineItems.count)
            {
                [[IMCartManager sharedManager] updateCartItems:lineItems withCompletion:^(IMCart *cart, NSError *error) {
                    
                    [[IMCacheManager sharedManager] clearCartItems];
                    completion(error);
                }];
            }
            else
            {
                [[IMCartManager sharedManager] fetchCartWithCompletion:^(IMCart *cart, NSError *error) {
                    
                }];
                completion(error);
            }
        }
        else
            completion(error);
        
    }];
}
@end
