//
//  IMPrescriptionPendingTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 24/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionPendingTableViewCell.h"

@interface IMPrescriptionPendingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@end
@implementation IMPrescriptionPendingTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(IMLineItem *)model
{
    _model = model;
    [self loadUI];
}

- (void)loadUI
{
    self.nameLabel.text = _model.name;
    self.brandLabel.text = @"";
    if(_model.unitOfSales)
        self.brandLabel.text = self.model.unitOfSales;
    if(_model.innerPackingQuantity )
    {
        self.brandLabel.text =  [NSString stringWithFormat:@"%@ (1x%@)", self.brandLabel.text,_model.innerPackingQuantity];
    }
    
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 0.5;
}

-(void)layoutSubviews
{
     // http://stackoverflow.com/questions/15058108/ios-multiline-uilabel-only-shows-one-line-with-autolayout
    [super layoutSubviews];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    self.nameLabel.preferredMaxLayoutWidth = 280.0f;
    self.brandLabel.preferredMaxLayoutWidth = 280.0f;
}
@end
