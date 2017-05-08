//
//  IMOTPVerificationControllerViewController.h
//  InstaMed
//
//  Created by Arjuna on 30/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing otp verification screen.

#import "IMBaseViewController.h"
#import "IMMobileNumberViewController.h"
#import "IMUser.h"


@interface IMOTPVerificationControllerViewController : IMBaseViewController


@property(nonatomic,copy) void(^completionBlock)(NSError*) ;
@property (nonatomic, assign) BOOL isPhoneNumberProvided;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSString *phoneNumberToUpdate;
@property(nonatomic, strong) NSString *nameToUpdate;
@property(nonatomic,strong) NSString* emailId;
@property(nonatomic,strong) NSString* password;
@property (nonatomic, assign) BOOL isPhoneNumberUpdated;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property(nonatomic,assign) IMScreenType screenType;
@property (nonatomic, assign) IMRegistrationType registrationType;
@property (nonatomic, strong) IMUser *user;



@end