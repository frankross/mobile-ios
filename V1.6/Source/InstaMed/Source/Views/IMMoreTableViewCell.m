//
//  IMMoreTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMMoreTableViewCell.h"

@implementation IMMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.separatorHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
   return UIEdgeInsetsZero;
}

@end
