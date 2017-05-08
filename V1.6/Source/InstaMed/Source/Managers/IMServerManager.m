//
//  IMServerManager.m
//  InstaMed
//
//  Created by Arjuna on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//




#import "IMServerManager.h"
#import "AFNetworking.h"
#import "IMLocationManager.h"
#import "IMDeviceManager.h"
#import "IMStore.h"
#import "IMSettingsUtility.h"


NSString* const IMAPIVersion1 = @"v1/";
NSString* const IMAPIVersion2 = @"v2/";
NSString* const IMAPIVersion3 = @"v3/";
NSString* const IMAPIVersion4 = @"v4/";
NSString* const IMAPIVersion5 = @"v5/";
NSString* const IMAPIVersion6 = @"v6/";
NSString* const IMAPIVersion7 = @"v7/";
NSString* const IMAPIVersion8 = @"v8/";
NSString *const IMCurrentAPIVersion = @"V8"; // current using  API version


@interface IMServerManager()

@property (nonatomic,strong)  AFHTTPSessionManager* sessionManager;

@end

@implementation IMServerManager

+(IMServerManager*)sharedManager
{
    static IMServerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    
        // Initialize Session Configuration
        sharedManager.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[IMSettingsUtility baseUrl]]];
        sharedManager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedManager.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];        
        ((AFJSONResponseSerializer*)sharedManager.sessionManager.responseSerializer).removesKeysWithNullValues = YES;
        

        
    });
        
    return sharedManager;
}


-(NSDictionary*)userInfoFromAFNetworkError:(NSError*)error
{
    NSDictionary* userInfo = nil;
    
    if(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey])
    {
        userInfo =  [NSJSONSerialization JSONObjectWithData:(NSData*)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
    }

        
    return userInfo;
}


-(void)setHeaderValue:(NSString*)value forKey:(NSString*)key
{
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (BOOL)isNetworkAvailable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (NSString *)currentAPIVersion
{
    return IMCurrentAPIVersion;
}

- (void)fetchUnreadNotificationCountWithCompletion:(void (^)(NSDictionary *responseDictionary,
                                                              NSError *error))completion
{

    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/in_app_notifications/%@/count",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,[[IMDeviceManager sharedManager] deviceToken]];
    [self.sessionManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        NSError* respnseError = nil;
        
        if(response)
        {
            respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
        }
        else
        {
            respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
        }
        completion(nil,respnseError);
    }];
}

-(void)fetchNotificationsWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/in_app_notifications/",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];
    [self.sessionManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        NSError* respnseError = nil;
        
        if(response)
        {
            respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
        }
        else
        {
            respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
        }
        completion(nil,respnseError);
        
    }];
}

-(void)updateNotificationsCountWithCompletion:(void (^)(NSError *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/in_app_notifications/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,[[IMDeviceManager sharedManager] deviceToken]];
    [self.sessionManager PUT:url parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(error);
    }];
}

-(void)logInWithUser:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion
{
    NSString *loginUrl = [NSString stringWithFormat:@"%@login",IMAPIVersion8];
    [self.sessionManager POST:loginUrl parameters:user success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        NSLog(@"token = %@",responseObject);
        completion(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];

        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;

        NSError* respnseError = nil;
        
        if(response)
        {
            respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
        }
        else
        {
            respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
        }
        
        NSLog(@"%@", userInfo);
        
               NSLog(@"%ld",(long)response.statusCode);
        
        NSLog(@"response = %@",response);
        
        
        completion(nil,respnseError);
    }];
}



-(void)logInSocialUserWithUserDetails:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion
{
    NSString *loginUrl = [NSString stringWithFormat:@"%@login/social",IMAPIVersion8];
    [self.sessionManager POST:loginUrl parameters:user success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         NSLog(@"%ld",(long)response.statusCode);
         
         NSLog(@"response = %@",response);
         
         
         completion(nil,respnseError);
     }];
}

-(void)logOutWithUser:(NSDictionary*)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion
{
//    http://staging.frankross.in/api/v3/customer/devices/abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70/unlink

    NSString *logOutUrl = [NSString stringWithFormat:@"%@customer/devices/%@/unlink",IMAPIVersion8,user[@"user"][@"token"]];

    [self.sessionManager PUT:logOutUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         NSLog(@"%ld",(long)response.statusCode);
         
         NSLog(@"response = %@",response);
         
         
         completion(nil,respnseError);
     }];

}


-(void)registerUser:(NSDictionary *)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion
{
    NSString *userUrl = [NSString stringWithFormat:@"%@user",IMAPIVersion8];

    [self.sessionManager POST:userUrl parameters:user success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);

         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         NSError* respnseError = nil;
         
         if (response.statusCode == 422)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
              respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         }
        
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)registerSocialLoggedInUser:(NSDictionary *)user withCompletion:(void(^)(NSDictionary* userDictionary,NSError* error))completion
{
    NSString *userUrl = [NSString stringWithFormat:@"%@user/social_signup",IMAPIVersion8];
    
    [self.sessionManager POST:userUrl parameters:user success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         NSError* respnseError = nil;
         
         if (response.statusCode == 422)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}

-(void)verifyOTP:(NSString*)otp withUserInfo:(NSDictionary*)userInfo withCompletion:(void(^)(NSError* error))completion
{
    [self.sessionManager PUT: [NSString stringWithFormat:@"%@customer/otps/%@/verify",IMAPIVersion8,otp]  parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"response = %@",responseObject);

        completion(nil);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        
        
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        
        NSLog(@"%@", userInfo);
        
        completion(respnseError);

    }];
}


- (void)updatePasswordUsingOTP:(NSString *)otp newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(NSError* error))completion
{
    NSDictionary *userInfo = @{ @"user" : @{@"new_password" : password}, @"otp" : otp, @"phone_number" : phoneNumber};
    
    NSString *updatePasswordUrl = [NSString stringWithFormat:@"%@user/password_using_otp",IMAPIVersion8];

    [self.sessionManager PUT:updatePasswordUrl  parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"response = %@",responseObject);
         
         completion(nil);
     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
                         NSLog(@"%ld",(long)response.statusCode);
                         
                         
                         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
                         
                         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                         
                         NSLog(@"%@", userInfo);
                         
                         completion(respnseError);
                         
                     }];

}

- (void)generateOTPForPhoneNumber:(NSString *)phoneNumber withCompletion:(void (^)(BOOL success, NSString *message))completion
{
    
    NSString *otpUrl = [NSString stringWithFormat:@"%@customer/otps",IMAPIVersion8];

    [self.sessionManager POST:otpUrl parameters:@{@"phone_number" : phoneNumber} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = responseObject;
        completion(YES,response[IMMessage]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        completion(NO,userInfo[@"message"]);
    }];
}

-(void)resendOTPForUserInfo:(NSDictionary*)userInfo withCompletion:(void(^)(NSDictionary* messageDictionary, NSError* error))completion
{
    [self.sessionManager POST: [NSString stringWithFormat:@"%@customer/otps",IMAPIVersion8]  parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"response = %@",responseObject);
         
         completion(responseObject,nil);
     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
                         NSLog(@"%ld",(long)response.statusCode);
                         
                         
                         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
                         
                         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                         
                         NSLog(@"%@", userInfo);
                         
                         completion(nil,respnseError);
                         
                     }];
}

-(void)fetchUserWithCompletion:(void (^)(NSDictionary * userDictionary, NSError *error))completion
{
    NSString *getUserUrl = [NSString stringWithFormat:@"%@user",IMAPIVersion8];

    [self.sessionManager GET:getUserUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)updateUser:(NSDictionary *)user withCompletion:(void(^)(NSError* error))completion
{
    NSString *updateUserUrl = [NSString stringWithFormat:@"%@user",IMAPIVersion8];

    [self.sessionManager PUT:updateUserUrl parameters:user success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];
    
}

-(void)updatePasswordFromPasswordDictionary:(NSDictionary*)passwordDictionary withCompletion:(void (^)(NSError *error))completion
{
    
    NSString *updatePasswordUrl = [NSString stringWithFormat:@"%@user/password",IMAPIVersion8];

    [self.sessionManager PUT:updatePasswordUrl parameters:passwordDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}


-(void)fetchAddressesWithCompletion:(void (^)(NSDictionary * addressDictionary, NSError * error))completion;
{
    
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/addresses",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)fetchDeliverySupportedLocationsWithParameters:(NSDictionary*)parmaters withCompletion:(void(^)(NSDictionary* locationDictionary,NSError* error))completion
{
    NSString *getCitiesUrl = [NSString stringWithFormat:@"%@customer/cities/",IMAPIVersion8];

    [self.sessionManager GET:getCitiesUrl parameters:parmaters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)addAddress:(NSDictionary *)address withCompletion:(void (^)(NSError *))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@customer/cities/%@/addresses",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier] parameters:address success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}

-(void)updateAddress:(NSMutableDictionary*)addressDictionary withCompletion:(void (^)(NSError *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/addresses/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,addressDictionary[@"address"][IMIdentifierKey]];
    [self.sessionManager PUT:url parameters:addressDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}


-(void)deleteAddressWithId:(NSNumber*)addressId withCompletion:(void (^)(NSError *))completion
{
    [self.sessionManager DELETE: [NSString stringWithFormat:@"%@customer/cities/%@/addresses/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,addressId]
                     parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"delete address  = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
         
         
     }];

}


-(void)fetchFeaturedCategoriesWithCompletion:(void(^)(NSDictionary* dictionary,NSError* error))completion
{
    NSString *getCategoriesUrl = [NSString stringWithFormat:@"%@customer/cities/%@/categories/featured",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];
    
    [self.sessionManager GET:getCategoriesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}

-(void)fetchCategoriesWithCompletion:(void(^)(NSDictionary* categoriesDictionary,NSError* error))completion
{
    
    NSString *getCategoriesUrl = [NSString stringWithFormat:@"%@customer/cities/%@/categories",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];

    [self.sessionManager GET:getCategoriesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)fetchCategoriesWithId:(NSNumber *)catId Completion:(void(^)(NSDictionary* categoriesDictionary,NSError* error))completion
{
    NSString *getCategoriesUrl = [NSString stringWithFormat:@"%@customer/cities/%@/categories/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier, catId];
    
    [self.sessionManager GET:getCategoriesUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}


-(void)fetchProductDetailWithId:(NSNumber*)productId withCompletion:(void(^)(NSDictionary* productDict,NSError* error))completion
{
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/variants/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,productId ] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

- (void)notifyUserForProductWithID:(NSNumber *)productId andUserDictionary:(NSDictionary *)userDictionary withCompletion:(void (^)(NSError *))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/variants/%@/notify_me",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,productId];
    [self.sessionManager POST:url parameters:userDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completion(nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        
        NSError* respnseError = nil;
        
        if(response)
        {
            respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
        }
        else
        {
            respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
        }
        
        completion(respnseError);
    
    }];
}


-(void)fetchCartItemsWithCompletion:(void(^)(NSDictionary* cartItems,NSError* error))completion
{
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/cart",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];


}

-(void)fetchCartItemsForLineItemsQueryString:(NSString*)lineItemsQureryString withCompletion:(void(^)(NSDictionary* cartItems,NSError* error))completion
{
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/cart_calculations%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,lineItemsQureryString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
        
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
    
}

-(void)fetchOrderDetailWithOrderId:(NSNumber*)orderId  completion:(void(^)(NSDictionary* response,NSError* error))completion
{

    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/orders/%@",IMAPIVersion8,orderId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}



-(void)updateCartItems:(NSDictionary*)cartItemDictionary withCompletion:(void(^)(NSDictionary* cartResponseDict,NSError* error))completion;
{
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/cities/%@/cart",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier]
                  parameters:cartItemDictionary success:^(NSURLSessionDataTask *task, id responseObject)
    {
         NSLog(@"update cart  = %@",responseObject);
         completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        
        
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
        
        NSLog(@"%@", userInfo);
        
        completion(nil,respnseError);

        
    }];
}

-(void)deleteCartItem:(NSNumber*)cartItemId withCompletion:(void(^)(NSDictionary* cartResponseDict,NSError* error))completion
{
    [self.sessionManager DELETE: [NSString stringWithFormat:@"%@customer/cities/%@/cart/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,cartItemId]
                  parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"delete cart  = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
         
         
     }];
}

-(void)fetchPrescriptionsWithCompletion:(void(^)(NSDictionary* prescriptionsResponseDict,NSError* error))completion
{

    NSString *prescrptionDetailUrl = [NSString stringWithFormat:@"%@customer/prescriptions",IMAPIVersion8];
    [self.sessionManager GET:prescrptionDetailUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)fetchPrescriptionDetailWithId:(NSNumber*)prescriptionId withCompletion:(void(^)(NSDictionary* precriptionDict,NSError* error))completion
{
    
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/prescriptions/%@",IMAPIVersion8, prescriptionId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

    
}


-(void)fetchOrdersForPage:(NSInteger )currentPage withProductsPerPage:(NSInteger ) productsPerPage withCompletion:(void(^)(NSDictionary* ordersDict,NSError* error))completion
{
    
    NSString *orderUrl = [NSString stringWithFormat:@"%@customer/orders?page=%ld&per_page=%ld",IMAPIVersion8,(long)currentPage,(long)productsPerPage];

    [self.sessionManager GET:orderUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)createPrescriptionWithDictionary:(NSDictionary*)prescriptionDictionary withCompletion:(void(^)(NSDictionary* precriptionResponseDict,NSError* error))completion
{

    NSString *creatPrescrptionUrl = [NSString stringWithFormat:@"%@customer/cities/%@/prescription_uploads",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];

    [self.sessionManager POST:creatPrescrptionUrl parameters:prescriptionDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}

-(void)updatePrescriptionWithId:(NSNumber*)prescriptionId andPrescriptionDictionary:(NSDictionary*)prescriptionDictionary withCompletion:(void(^)(NSError* error))completion
{

    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/cities/%@/prescription_uploads/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier, prescriptionId] parameters:prescriptionDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}

-(void)completePrescriptionUploadWithId:(NSNumber*)prescriptionId withCompletion:(void(^)(NSError* error))completion
{

    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/cities/%@/prescription_uploads/%@/complete",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier, prescriptionId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}

-(void)fetchFullfillmentCenterIDForCartDetail:(NSDictionary *)cartDictionary withCompletion:(void (^)(NSNumber *id, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/cart/update_address_and_fullfillment_center",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];
    [self.sessionManager PUT:url parameters:cartDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSNumber *id = responseDictionary[@"fulfillment_center_id"];
        completion(id,nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        completion(nil,error);
    }];
}

-(void)fetchDeliverySlotsForAreaId:(NSNumber*)areaId withFullfillmentCenterID:(NSNumber *)fullfillmentCenterID withPrescription:(BOOL)withPrescription withCompletion:(void(^)(NSMutableDictionary* deliverySlots, NSError* error))completion
{
    //ka pass with_prescription along with area id
    NSString *withPrescriptionParameter = @"";
    if (withPrescription) {
        withPrescriptionParameter = @"with_prescription=true";
    }
    else{
        withPrescriptionParameter = @"with_prescription=false";
    }
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/delivery_slots?area_id=%@&fulfillment_center_id=%@&%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,areaId,fullfillmentCenterID,withPrescriptionParameter] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)completeOrderWithId:(NSNumber*)orderId withCart:(NSDictionary*)cartDictionary withCompletion:(void(^)(NSError* error))completion
{
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/orders/%@/complete",IMAPIVersion8, orderId] parameters:cartDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}


-(void)paymentFailedForOrderWithId:(NSNumber*)orderId withCart:(NSDictionary*)cartDictionary withCompletion:(void(^)(NSDictionary *responseDictionary,NSError* error))completion
{
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/orders/%@/payment_failed",IMAPIVersion8, orderId] parameters:cartDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
}

-(void)updateOrderWithId:(NSNumber*)orderId info:(NSDictionary*)orderDictionary withCompletion:(void(^)(NSError* error))completion
{
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/orders/%@/revise",IMAPIVersion8,orderId] parameters:orderDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];
    
}

-(void)setReorderReminderForOrderWithId:(NSNumber*)orderId reminderInfo:(NSDictionary*)reminderInfo completion:(void(^)(NSDictionary* messageDict, NSError* error))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@customer/orders/%@/reminder",IMAPIVersion8,orderId] parameters:reminderInfo success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)resetReminderWithOrderId:(NSNumber*)orderId withCompletion:(void(^)(NSError* error))completion
{
    [self.sessionManager DELETE: [NSString stringWithFormat:@"%@customer/orders/%@/reminder",IMAPIVersion8,orderId]
                     parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"reset reminder = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
         
         
     }];

}


-(void)cancelOrderWithId:(NSNumber*)orderId withOrderInfoDict:(NSDictionary*)cancelInfoDict withCompletion:(void(^)(NSDictionary* messageDict, NSError* error))completion
{
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/orders/%@/cancel",IMAPIVersion8,orderId] parameters:cancelInfoDict success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)fetchOrderCancellationReasonsWithCompletion:(void(^)(NSMutableArray* cancellationReasons, NSError* error))completion
{
    NSString *cancelReasonurl = [NSString stringWithFormat:@"%@customer/orders/cancellation_reasons",IMAPIVersion8];
    [self.sessionManager GET:cancelReasonurl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"cancellation reasons = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}


-(void)checkOutUserCartWithDictionary:(NSDictionary *)dictionary Completion:(void(^)(NSDictionary* orderIdDict,  NSError* error))completion
{
    
    [self.sessionManager PUT:[NSString stringWithFormat:@"%@customer/cities/%@/cart/checkout",IMAPIVersion8, [IMLocationManager sharedManager].currentLocation.identifier] parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"token = %@",responseObject);
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        NSLog(@"%ld",(long)response.statusCode);
        
        
        NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
        
        NSError* respnseError = nil;
        
        if(response)
        {
            respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
        }
        else
        {
            respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
        }

        
        NSLog(@"%@", userInfo);
        
        completion(nil,respnseError);
    }];

}



-(void)fetchRecentlyOrderedPharmaProductsWithQueryString:(NSString*)queryString withCompletion:(void(^)(NSDictionary* messageDict, NSError* error))completion
{
    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@/recent_pharma_orders%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier,queryString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

- (void)getCurrentCityDetailsWithCompletion:(void(^)(NSMutableDictionary* cityDictioary, NSError *error))completion;
{
//    GET /api/v1/customer/cities/1055861728

    [self.sessionManager GET:[NSString stringWithFormat:@"%@customer/cities/%@",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}


- (void)updatePhoneNumber:(NSDictionary *)phoneInfo withCompletion:(void (^)(NSError *))completion
{
    
    NSString *updatePhoneurl = [NSString stringWithFormat:@"%@user/primary_phone",IMAPIVersion8];

    [self.sessionManager PUT:updatePhoneurl parameters:phoneInfo success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];

}


- (void)updatePhoneNumberForSocialUserWithUserInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *))completion
{
    
    NSString *updatePhoneurl = [NSString stringWithFormat:@"%@user/social_user_primary_phone",IMAPIVersion8];
    
    [self.sessionManager PUT:updatePhoneurl parameters:userInfo success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
     }];
}



- (void)checkAPIValiditywithCompletion:(void(^)(NSDictionary* infoDictionary, NSError* error))completion
{
    
    NSString *statusurl = [NSString stringWithFormat:@"%@status",IMAPIVersion8];

    [self.sessionManager GET:statusurl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)fetchNearbyStoresWithParameters:(NSDictionary*)parameters withCompletion:(void(^)(NSArray* stores, NSError* error))completion
{
    //NSDictionary *parameters = @{@"lat":@(location.coordinate.latitude), @"long":@(location.coordinate.longitude)};
    
    NSString *storeurl = [NSString stringWithFormat:@"%@customer/stores",IMAPIVersion8];

    [self.sessionManager GET:storeurl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSMutableArray *storesReceived = [NSMutableArray array];
         NSArray *stores = [((NSDictionary*)responseObject)objectForKey:@"stores"];
         if (stores && [stores isKindOfClass:[NSArray class]]) {
             for (NSDictionary *str in stores) {
                 [storesReceived addObject:[[IMStore alloc]initWithDictionary:str]];
             }
         }
         completion(storesReceived,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
}

-(void)fetchOffersWithCompletion:(void(^)(NSDictionary* offers,NSError* error))completion
{
    
    NSString *bannerurl = [NSString stringWithFormat:@"%@customer/cities/%@/banners",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];

    [self.sessionManager GET:bannerurl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}

-(void) fetchOffersForListingPageWithCompletion:(void (^)(NSDictionary *offers,NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"%@customer/cities/%@/offers",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier];
    [self.sessionManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}


-(void)registerDeviceWithDictionary:(NSDictionary *)dictionary andCompletion:(void(^)(NSError* error))completion
{
    NSString *Url = [NSString stringWithFormat:@"%@customer/devices",IMAPIVersion8];
    [self.sessionManager POST:Url parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         NSLog(@"Response = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         NSLog(@"%ld",(long)response.statusCode);
         
         NSLog(@"response = %@",response);
         
         
         completion(respnseError);
     }];

}

-(void)unRegisterDeviceWithDictionary:(NSString *)tocken andCompletion:(void(^)(NSError* error))completion
{
    [self.sessionManager DELETE: [NSString stringWithFormat:@"%@customer/devices/%@",IMAPIVersion8,tocken]
                     parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"reset reminder = %@",responseObject);
         completion(nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(respnseError);
    }];
}

-(void)applyCartCouponWithDetails:(NSDictionary *)couponDetail andCompletion:(void(^)(NSDictionary* cartDict, NSError* error))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@customer/cities/%@/cart/coupon",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier]
                     parameters:couponDetail success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"apply cart coupon = %@",responseObject);
         completion(responseObject, nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil, respnseError);
     }];
}

-(void)removeCartCouponWithDetails:(NSDictionary *)couponDetail andCompletion:(void(^)(NSDictionary* cartDict, NSError* error))completion
{
    [self.sessionManager DELETE: [NSString stringWithFormat:@"%@customer/cities/%@/cart/coupon",IMAPIVersion8,[IMLocationManager sharedManager].currentLocation.identifier]
                     parameters:couponDetail success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"remove cart coupon = %@",responseObject);
         completion(responseObject, nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil, respnseError);
     }];
}



-(void)fetchFAQCategoriesWithCompletion:(void(^)(NSDictionary* FAQDictionary,NSError* error))completion
{
    NSString *FAQCategoryUrl = [NSString stringWithFormat:@"%@customer/faq_topics",IMAPIVersion8];
    [self.sessionManager GET:FAQCategoryUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
}

-(void)fetchFAQListForID:(NSNumber  *)ID WithCompletion:(void(^)(NSDictionary* FAQDictionary,NSError* error))completion
{
    NSString *FAQUrl = [NSString stringWithFormat:@"%@customer/faq_topics/%@",IMAPIVersion8,ID];
    
    [self.sessionManager GET:FAQUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];

}

-(void)getHealthWalletDetailsWithCompletion:(void (^)(NSNumber *earnedAmount, NSNumber *spendAmount , NSNumber *availableAmount, NSArray *transactions,NSString *message, NSError *))completion
{
    NSString *healthWalletUrl = [NSString stringWithFormat:@"%@customer/health_wallet",IMAPIVersion8];
    
    [self.sessionManager GET:healthWalletUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         NSNumber *earnedAmount = responseObject[@"earned"];
         NSNumber *spendAmount = responseObject[@"spend"];
         NSNumber *availableAmount = responseObject[@"available"];
         NSArray *transactions = responseObject[@"transactions"];
         NSString *message = responseObject[@"message"];
         
         completion(earnedAmount,spendAmount,availableAmount,transactions,message,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError =  [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
         
         NSLog(@"%@", userInfo);
         
         completion(nil,nil,nil,nil,nil,respnseError);
     }];
}

-(void)updateUserCartWithOrderID:(NSNumber *)orderID forApplyWalletWithDictionary:(NSDictionary *)dictionary Completion:(void (^)(NSDictionary *, NSError *))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@customer/orders/%@/update_wallet",IMAPIVersion8,orderID] parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
}

-(void) initiatePrepaidPaymentWithOrderId:(NSNumber*)orderId info:(NSDictionary*)initiatePaymentDictionary withCompletion:(void(^)(NSDictionary *responseDict, NSError* error))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@customer/orders/%@/initiate_payment",IMAPIVersion8,orderId] parameters:initiatePaymentDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
}

-(void) fetchAppSettingsDetailsWithCompletion:(void(^)(NSDictionary* appSettingsDictionary,NSError* error))completion
{
    NSString *appSettingsUrl = [NSString stringWithFormat:@"%@application_settings",IMAPIVersion8];
    [self.sessionManager GET:appSettingsUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         NSLog(@"%ld",(long)response.statusCode);
         
         NSLog(@"response = %@",response);
         
         
         completion(nil,respnseError);
     }];
}

-(void)  fetchFeaturedTagsWithFeaturesDictionary:(NSDictionary*)featuresDictionary withCompletion:(void(^)(NSDictionary *responseDict, NSError* error))completion
{
    [self.sessionManager POST:[NSString stringWithFormat:@"%@feature_tags/fetch",IMAPIVersion8] parameters:featuresDictionary success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         
         NSLog(@"%@", userInfo);
         
         completion(nil,respnseError);
     }];
    
}

-(void) fetchUserReferralDetailsWithCompletion:(void(^)(NSDictionary* referralDictionary,NSError* error))completion
{
    NSString *userReferralURL = [NSString stringWithFormat:@"%@customer/referral_codes",IMAPIVersion8];
    [self.sessionManager GET:userReferralURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         NSLog(@"%ld",(long)response.statusCode);
         NSLog(@"token = %@",responseObject);
         completion(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         NSDictionary* userInfo = [self userInfoFromAFNetworkError:error];
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         NSError* respnseError = nil;
         
         if(response)
         {
             respnseError =  [NSError errorWithDomain:error.domain code:response.statusCode userInfo:userInfo];
         }
         else
         {
             respnseError =  [NSError errorWithDomain:error.domain code:error.code  userInfo:userInfo];
         }
         
         NSLog(@"%@", userInfo);
         
         NSLog(@"%ld",(long)response.statusCode);
         
         NSLog(@"response = %@",response);
         
         
         completion(nil,respnseError);
     }];
}

@end
