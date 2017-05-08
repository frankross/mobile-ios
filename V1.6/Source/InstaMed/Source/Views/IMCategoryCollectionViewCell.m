//
//  IMCategoryCollectionViewCell.m
//  InstaMed
//
//  Created by Suhail K on 04/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCategoryCollectionViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
@implementation IMCategoryCollectionViewCell


- (void)loadUI
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.imageView.image = nil;//[UIImage imageNamed:_model.offerImageURL];
    
    self.imageView.image = [UIImage imageNamed:IMProductPlaceholderName];
    
    if(_model.homeIconImageURL && _model.homeIconImageURL != ((id)[NSNull null]) )
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:_model.homeIconImageURL]
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 0.5;
    
//    if(_model.imageURL && _model.imageURL != ((id)[NSNull null]) )
//    {
//        [self.imageView setImageWithURL:[NSURL URLWithString:_model.imageURL]
//            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }
    self.titleLabel.text = _model.name;
}

- (void)setModel:(IMCategory *)model
{
    _model = model;
    [self loadUI];
}

@end
