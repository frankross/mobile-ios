//
//  IMProductDetailTypeNotificationTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 25/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMLabel.h"

@interface IMProductDetailTypeNotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet IMLabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet IMLabel *notificationDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstaint;

@end
