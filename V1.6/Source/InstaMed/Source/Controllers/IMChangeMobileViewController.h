//
//  IMChangeMobileViewController.h
//  InstaMed
//
//  Created by Suhail K on 04/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing user's phone number change screen.

#import "IMBaseViewController.h"
#import "IMUser.h"


@protocol IMChangeNumberViewControllerDelgate <NSObject>

-(void)didFinishChangeNumberWithphoneNumber:(NSString *)mobile;

@end

@interface IMChangeMobileViewController : IMBaseViewController

@property (nonatomic,weak) id delegate;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) IMUser *user;
@property (nonatomic, assign) IMRegistrationType registrationType;



@end
