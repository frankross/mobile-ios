//
//  IMNotificationsListingViewController.h
//  InstaMed
//
//  Created by Yusuf Ansar on 18/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"

/**
 *  Protocol to update the unread notification count after calling update notification count API 
 */

@protocol IMNotificationsListingViewControllerDelegate <NSObject>

- (void)didUpdateNotificationUnreadCount;

@end


/**
 *  Class responsible for listing notiifcations
 */
@interface IMNotificationsListingViewController : IMBaseViewController


@property (nonatomic, weak) id<IMNotificationsListingViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger unreadNotificationCount;

@end
