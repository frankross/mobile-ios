//
//  IMPasswordViewController.h
//  InstaMed
//
//  Created by Sahana Kini on 17/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//Class for managing user's password entering screen.


#import "IMBaseViewController.h"
#import "IMMobileNumberViewController.h"

@interface IMPasswordViewController : IMBaseViewController

@property (nonatomic, strong) NSString *otp;
@property (nonatomic, strong) NSString *phoneNumber;
@property(nonatomic,copy) void(^loginCompletionBlock)(NSError*) ;
@property(nonatomic,assign) IMScreenType screenType;

@end
