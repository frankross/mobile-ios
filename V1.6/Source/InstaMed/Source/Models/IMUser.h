//
//  IMUser.h
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

extern NSString* const IMFullNameKey;
extern NSString* const IMMobileNumberKey;
extern NSString* const IMEmailAdressKey;
extern NSString* const IMPasswordKey;
extern NSString* const isThroughMail;

extern NSString* IMAuthTokenHeaderKey;
extern NSString* IMUserNameKey;
extern NSString* IMDeviceTokenKey;
extern NSString* IMUserIDKey;
extern NSString* IMIsRegisteredPreferenceKey;

extern NSString* IMTokenKey;
extern NSString* IMDeviceTypeKey;
extern NSString* IMAppVersionKey;

@interface IMUser : IMBaseModel

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* emailAddress;
@property (nonatomic,strong) NSString* password;
@property (nonatomic,strong) NSString* mobileNumber;
@property (nonatomic, strong) NSString *SocialAuthToken;
@property (nonatomic, strong) NSString *SocialLoginUserID;
@property (nonatomic, strong) NSNumber *rewardPoints;
@property (nonatomic, assign) BOOL isThroughMail;


@property  (nonatomic) IMLoginType loginType;

-(NSDictionary*)dictionaryForLogin;
-(NSDictionary*)dictionaryForLogOut;

-(NSDictionary*)dictionaryForRegistration;
-(NSDictionary*)dictionaryForUpdate;
-(NSDictionary*)dictionaryForSocialLogin;
-(NSDictionary*)dictionaryForRegistrationUsingSocialLogin;
- (NSDictionary*)dictionaryForUpdatePhoneForSocialUserWithPhoneNumber:(NSString *)phoneNumber;

@end
