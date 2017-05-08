//
//  IMKeyFeatureTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 03/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMKeyFeatureTableViewCell.h"

@implementation IMKeyFeatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];

    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //[self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];

    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}
@end
