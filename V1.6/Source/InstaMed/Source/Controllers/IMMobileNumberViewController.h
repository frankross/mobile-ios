//
//  IMMobileNumberViewController.h
//  InstaMed
//
//  Created by Sahana Kini on 17/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//Class for managing change number from otp screen.

#import <UIKit/UIKit.h>
#import "IMBaseViewController.h"

typedef enum
{
    IMForDirectRegistraion,
    IMForInDirectRegistraion,
    IMForForgotPassword,
    IMForChangeNumber,
    IMForLogin,
    IMForVerifyOldPhoneNumber
}
IMScreenType;

@interface IMMobileNumberViewController : IMBaseViewController

@property(nonatomic,copy) void(^loginCompletionBlock)(NSError*) ;
@property(nonatomic,assign) IMScreenType screenType;

@end
