//
//  IMSearchTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 22/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNonPharmaSearchTableViewCell.h"

@implementation IMNonPharmaSearchTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    self.suggestionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.suggestionLabel.frame);
}

@end
