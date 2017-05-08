//
//  IMUser.m
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMUser.h"
#import "IMDeviceManager.h"

#define DEVICE_TYPE @"ios"

NSString* const IMMobileNumberKey = @"primary_phone";
NSString* const IMEmailAdressKey = @"email";
NSString* const IMPasswordKey = @"password";
NSString* const IMNameKey = @"name";
NSString *const IMSocialLoginProviderKey = @"social_login_provider";
NSString *const IMSocialLoginUIDKey= @"social_login_uid";
NSString *const IMSocialLoginAuthTokenKey = @"social_auth_token";
NSString* IMAuthTokenHeaderKey = @"X-Auth-Token";
NSString *IMUserIDKey = @"USER_ID";
NSString* IMUserNameKey = @"User_Name";
NSString *IMIsRegisteredPreferenceKey = @"isRegistered";
NSString* IMRewardPointKey = @"reward_points";
NSString* IMDeviceTokenKey = @"Device_Token";
NSString* IMTokenKey = @"token";
NSString* IMDeviceTypeKey = @"device_type";
NSString* IMAppVersionKey = @"app_version";
NSString* const IMMobileKey = @"phone_number";
NSString* const IMPrimaryPhoneType = @"primary_phone_type";
NSString* const isThroughMail = @"through_mail";


@implementation IMUser



-(id)initWithDictionary:(NSDictionary *)dictionary
{
    dictionary = dictionary[@"user"];
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.name = dictionary[IMNameKey];
        self.emailAddress = dictionary[IMEmailAdressKey];
        self.mobileNumber = dictionary[IMMobileNumberKey];
        self.rewardPoints = dictionary[IMRewardPointKey];
    }
    return self;
}

-(NSDictionary*)dictionaryForLogin
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:self.password forKey:IMPasswordKey];
    
    if (self.emailAddress)
    {
        [dictionary addEntriesFromDictionary:@{IMEmailAdressKey : self.emailAddress}];
    }
    
    if (self.mobileNumber)
    {
        [dictionary addEntriesFromDictionary:@{IMMobileKey : self.mobileNumber}];
    }
    NSString *token = [[IMDeviceManager sharedManager] deviceToken];

    if(!token)
    {
        token = @"abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70";
    }
    [dictionary addEntriesFromDictionary:@{IMTokenKey : token}];

    [dictionary addEntriesFromDictionary:@{IMDeviceTypeKey : @"ios"}];

    return [NSDictionary dictionaryWithObject:dictionary forKey:@"user"];
}

-(NSDictionary*)dictionaryForSocialLogin
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if(self.loginType == IMLoginTypeFacebook)
    {
        dictionary[IMSocialLoginProviderKey] = @"facebook";
    }
    else if(self.loginType == IMLoginTypeGoogle)
    {
        dictionary[IMSocialLoginProviderKey] = @"google";
    }
    
    dictionary[IMSocialLoginUIDKey] = self.SocialLoginUserID;
    dictionary[IMSocialLoginAuthTokenKey] = self.SocialAuthToken;
    
    NSString *token = [[IMDeviceManager sharedManager] deviceToken];
    
    if(!token)
    {
        token = @"abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70";
    }
    [dictionary addEntriesFromDictionary:@{IMTokenKey : token}];
    
    [dictionary addEntriesFromDictionary:@{IMDeviceTypeKey : @"ios"}];
    
    return [NSDictionary dictionaryWithObject:dictionary forKey:@"user"];
}

-(NSDictionary*)dictionaryForLogOut
{
    NSString *token = @"";
    token = [[IMDeviceManager sharedManager] deviceToken];
    if(!token)
    {
        token = @"abce89f446071d1d707187b3ad6353b777717ec65f3fe4f775c20108e4ab7c70";
    }
    
    
    return  @{@"user" : @{ IMTokenKey:token,
                           IMDeviceTypeKey:@"ios"}};
    
}


-(NSDictionary*)dictionaryForRegistration
{
    
    return  @{@"user" : @{ IMEmailAdressKey : self.emailAddress, IMPasswordKey:self.password , IMNameKey:self.name ,
                           IMMobileNumberKey:self.mobileNumber ,IMPrimaryPhoneType : @"Mobile"}};
}

-(NSDictionary*)dictionaryForRegistrationUsingSocialLogin
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[IMEmailAdressKey] = self.emailAddress;
    dictionary[IMNameKey] = self.name;
    dictionary[IMMobileNumberKey] = self.mobileNumber;
    dictionary[IMPrimaryPhoneType] =  @"Mobile";
    if(self.loginType == IMLoginTypeFacebook)
    {
        dictionary[IMSocialLoginProviderKey] = @"facebook";
    }
    else if(self.loginType == IMLoginTypeGoogle)
    {
        dictionary[IMSocialLoginProviderKey] = @"google";
    }
    
    dictionary[IMSocialLoginUIDKey] = self.SocialLoginUserID;
    dictionary[IMSocialLoginAuthTokenKey] = self.SocialAuthToken;
    return [NSDictionary dictionaryWithObject:dictionary forKey:@"user"];
}

- (NSDictionary*)dictionaryForUpdatePhoneForSocialUserWithPhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"user"] = @{ IMMobileNumberKey : phoneNumber};
    dictionary[IMSocialLoginUIDKey] = self.SocialLoginUserID;
    dictionary[IMSocialLoginAuthTokenKey] = self.SocialAuthToken;
    if(self.loginType == IMLoginTypeFacebook)
    {
        dictionary[IMSocialLoginProviderKey] = @"facebook";
    }
    else if(self.loginType == IMLoginTypeGoogle)
    {
        dictionary[IMSocialLoginProviderKey] = @"google";
    }
    return dictionary;
}

-(NSDictionary*)dictionaryForUpdate
{
    return  @{@"user" : @{ IMNameKey:self.name ,
                           IMMobileNumberKey:[@"" stringByAppendingString:self.mobileNumber]}};
}


@end
