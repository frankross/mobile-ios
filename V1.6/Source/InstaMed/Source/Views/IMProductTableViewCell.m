//
//  IMProductTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProductTableViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"



@interface IMProductTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sellingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIView *strockLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manufacturerLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manufacturerLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cashbackDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconTopConstraint;

@end

@implementation IMProductTableViewCell

- (void)awakeFromNib {
    
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.frame);
    
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (void)setModel:(IMProduct *)model
{
    _model = model;
    [self loadUI];
}

- (void)loadUI
{
    
    self.nameLabel.text = _model.name;

    
    if(_model.isPharma)
    {
        self.manufacturerLabel.text = @"";

        if([_model.manufacturer isEqualToString:@""] || _model.manufacturer == nil)
        {
            self.manufacturerLabelTop.constant = 0.0f;
            self.manufacturerLabelHeightConstraint.constant = 0.0f;
        }
        else
        {
            self.manufacturerLabelTop.constant = 8.0f;
            self.manufacturerLabelHeightConstraint.constant = 17.0f;
        }
        self.manufacturerLabel.text = _model.manufacturer;

    }
    else
    {
        self.manufacturerLabel.text = @"";

        if([_model.brand isEqualToString:@""] || _model.brand == nil)
        {
            self.manufacturerLabelTop.constant = 0.0f;
            self.manufacturerLabelHeightConstraint.constant = 0.0f;
            
        }
        else
        {
            self.manufacturerLabelTop.constant = 8.0f;
            self.manufacturerLabelHeightConstraint.constant = 17.0f;
        }
        self.manufacturerLabel.text = [NSString stringWithFormat:@"By %@",_model.brand];

    }
    
    self.sellingPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.sellingPrice];
    self.actualPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.mrp];

    
    if([_model.discountPercent isEqualToString:@"0.0"] || [_model.discountPercent isEqualToString:@"0"])
    {
        self.discountLabel.hidden = YES;
        self.actualPriceLabel.hidden = YES;
        self.strockLabel.hidden = YES;
    }
    else
    {
        self.discountLabel.hidden = NO;
        self.actualPriceLabel.hidden = NO;
        self.strockLabel.hidden = NO;
        self.discountLabel.text =   [NSString stringWithFormat:@"%@%% off",_model.formattedDiscountPercent];
        self.sellingPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.promotionalPrice];

    }
    
    if(_model.isCashBackAvailable && _model.cashbackDescription)
    {
        self.cashbackDescriptionLabel.text = _model.cashbackDescription;
        self.cashbackIconTopConstraint.constant = 8.0f;
        self.cashbackIconHeightConstraint.constant = 14.0f;
    }
    else
    {
        self.cashbackDescriptionLabel.text = @"";
        self.cashbackIconTopConstraint.constant = 0;
        self.cashbackIconHeightConstraint.constant = 0;
    }
    
    if(_model.available)
    {
        self.addToCartButton.enabled = YES;
    }
    else
    {
        self.addToCartButton.enabled = NO;
    }
    

    
    self.imgView.image = [UIImage imageNamed:IMProductPlaceholderName];
    
    NSLog(@"URL: %@",_model.thumbnailImageURL);
    if(_model.thumbnailImageURL != ((id)[NSNull null]))
    {
        [self.imgView setImageWithURL:[NSURL URLWithString:_model.thumbnailImageURL]
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    }

}

@end
