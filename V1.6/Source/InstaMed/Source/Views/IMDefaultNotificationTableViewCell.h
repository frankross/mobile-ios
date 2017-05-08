//
//  IMDefaultNotificationTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 20/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMLabel.h"

@interface IMDefaultNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IMLabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet IMLabel *notificationDescriptionLabel;
@property (weak, nonatomic) IBOutlet IMLabel *notificationDateLabel;

@end
