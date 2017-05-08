//
//  IMReturnProductInactiveTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 01/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMReturnProductInactiveTableViewCell.h"

@implementation IMReturnProductInactiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.productImageView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
