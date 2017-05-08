//
//  IMMoreTaggedTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 10/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMMoreTaggedTableViewCell.h"

@implementation IMMoreTaggedTableViewCell

- (void)awakeFromNib {
    self.tagName.layer.cornerRadius = 4.0;
    //[myButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
