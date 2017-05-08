//
//  IMDefaultNotificationTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 20/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDefaultNotificationTableViewCell.h"

@implementation IMDefaultNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.notificationTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.notificationTitleLabel.frame);
    self.notificationDescriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.notificationDescriptionLabel.frame);
    
}

@end
