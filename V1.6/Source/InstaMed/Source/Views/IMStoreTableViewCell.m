//
//  IMStoreTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMStoreTableViewCell.h"
@interface IMStoreTableViewCell()



@end

@implementation IMStoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.addressLabel.frame);
}

-(void)setModel:(IMStore *)model
{
    _model = model;
}



@end
