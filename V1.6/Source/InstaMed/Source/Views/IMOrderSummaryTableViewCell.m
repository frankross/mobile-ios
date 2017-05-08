//
//  IMOrderSummaryTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderSummaryTableViewCell.h"

@interface IMOrderSummaryTableViewCell ()



@end

@implementation IMOrderSummaryTableViewCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)loadUI
{
    self.nameLabel.text = self.model.name;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.quantity];
    if([self.model.discountPercentage isEqual:@"0.0"])
    {
        //ka removed rupee symbol
          self.priceLabel.text = [NSString stringWithFormat:@"%.02lf",[self.model.salesPrice doubleValue]];
    }
    else
    {
          self.priceLabel.text = [NSString stringWithFormat:@"%.02lf",[self.model.promotionalPrice doubleValue]];
    }
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

-(void)setModel:(IMLineItem *)model
{
    _model = model;
    [self loadUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
     [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
}
@end
