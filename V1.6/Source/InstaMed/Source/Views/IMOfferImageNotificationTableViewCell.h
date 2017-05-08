//
//  IMOfferImageNotificationTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 19/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMOfferImageNotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *notificationImageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstaint;

@end
