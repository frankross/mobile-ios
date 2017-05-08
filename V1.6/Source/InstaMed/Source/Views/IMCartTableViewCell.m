//
//  IMCartTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartTableViewCell.h"
#import "UIKit+AFNetworking.h"

@interface IMCartTableViewCell ()


@end
@implementation IMCartTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
//    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
}

@end
