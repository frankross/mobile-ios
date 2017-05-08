//
//  IMFAQTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 04/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFAQTableViewCell.h"

@implementation IMFAQTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.questionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.questionLabel.frame);
    self.answerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.answerLabel.frame);
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


@end
