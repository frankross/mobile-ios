//
//  IMNotifyMePhoneNumberViewController.h
//  InstaMed
//
//  Created by Yusuf Ansar on 09/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#import "IMBaseViewController.h"

@class IMNotifyMePhoneNumberViewController;
/**
 *  NotifyMePhoneNumberViewController protcol
 */
@protocol IMNotifyMePhoneNumberViewControllerDelegate <NSObject>
/**
 *  Fuction to call when user enters phone number for notify prouct arrival
 *
 *  @param phoneNumber phone number used for notify
 */
- (void) notifyTheUserWithPhoneNumber:(NSString*) phoneNumber;

@end

/**
 *  Class responsible for getting phone number from non loggedin user for Notify product arrival
 */
@interface IMNotifyMePhoneNumberViewController : IMBaseViewController

@property(nonatomic,weak) id<IMNotifyMePhoneNumberViewControllerDelegate> delgate;

@end
