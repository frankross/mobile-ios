//
//  IMCancelReasonCell.m
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCancelReasonCell.h"

@implementation IMCancelReasonCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if(selected)
    {
        self.cancelReasonLabel.textColor = APP_THEME_COLOR_WITH_ALPHA;
        self.checkedImageView.image = [UIImage imageNamed:IMTickMarkImageName];
    }
    else
    {
        self.checkedImageView.image = nil;
        self.cancelReasonLabel.textColor = APP_THEME_COLOR;
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    self.cancelReasonLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.cancelReasonLabel.frame);
}

@end
