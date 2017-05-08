//
//  IMProductListCollectionViewCell.m
//  InstaMed
//
//  Created by Suhail K on 26/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProductListCollectionViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"

@interface IMProductListCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sellingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameToOffVConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *strockLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manufacturerLabelTop;

@end

@implementation IMProductListCollectionViewCell

- (void)setModel:(IMProduct *)model
{
    _model = model;
    [self loadUI];
}

- (void)loadUI
{
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.name];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:4];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.name length])];
//    self.nameLabel.attributedText = attributedString;
    self.nameLabel.text = _model.name;

    
    self.manufacturerLabel.text = _model.manufacturer;
    
    if(_model.isPharma)
    {
        self.manufacturerLabel.text = @"";
        if(_model.manufacturer != ((id)[NSNull null]))
        {
            if([_model.manufacturer isEqualToString:@""] || _model.manufacturer == nil)
            {
                self.manufacturerLabelTop.constant = 0.0f;
            }
            else
            {
                self.manufacturerLabelTop.constant = 10.0f;
            }
            self.manufacturerLabel.text = _model.manufacturer;
        }
        
    }
    else
    {
        self.manufacturerLabel.text = @"";
        
        if(_model.brand != ((id)[NSNull null]))
        {
            if([_model.brand isEqualToString:@""] || _model.brand == nil)
            {
                self.manufacturerLabelTop.constant = 0.0f;
                
            }
            else
            {
                self.manufacturerLabelTop.constant = 10.0f;
            }
            self.manufacturerLabel.text = [NSString stringWithFormat:@"By %@",_model.brand];
        }
    }
    
    self.sellingPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.sellingPrice];
    self.actualPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.mrp];
    
    if([_model.discountPercent isEqualToString:@"0.0"] || [_model.discountPercent isEqualToString:@"0"])
        //    if(_model.discountPercentDouble.doubleValue != 0.0 )
    {
        
        
        self.discountLabelHeightConstraint.constant = 0;
        self.nameToOffVConstraint.constant = 0;
        self.discountLabel.hidden = YES;
        self.actualPriceLabel.hidden = YES;
        self.strockLabel.hidden = YES;
        
    }
    else
    {
        self.discountLabel.hidden = NO;
        self.discountLabelHeightConstraint.constant = 19;
        self.nameToOffVConstraint.constant = 12;
        //ka
        self.discountLabel.text =   [NSString stringWithFormat:@"%@%% off",_model.formattedDiscountPercent];
        //        self.discountLabel.text =   _model.formattedDiscountPercent;
        self.sellingPriceLabel.text = [NSString stringWithFormat:@"₹ %@", _model.promotionalPrice];
        self.actualPriceLabel.hidden = NO;
        self.strockLabel.hidden = NO;
    }

    self.imgView.image = [UIImage imageNamed:IMProductPlaceholderName];
    
    NSLog(@"URL: %@",_model.thumbnailImageURL);
    if(_model.thumbnailImageURL != ((id)[NSNull null]))
    {
        [self.imgView setImageWithURL:[NSURL URLWithString:_model.thumbnailImageURL]
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 0.50;
}


@end
