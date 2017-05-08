//
//  IMRegistrationViewController.h
//  InstaMed
//
//  Created by Arjuna on 28/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


// class for managing new user registration.

#import "IMBaseViewController.h"
#import "IMUser.h"




@interface IMRegistrationViewController : IMBaseViewController

@property(nonatomic,copy) void(^completionBlock)(NSError*) ;

@property (nonatomic, strong) IMUser *user;
@property(nonatomic,assign) IMRegistrationType registrationType;

@end
