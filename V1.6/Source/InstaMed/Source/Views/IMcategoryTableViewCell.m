//
//  IMcategoryTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 04/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMcategoryTableViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"



@interface IMcategoryTableViewCell ()



@end

@implementation IMcategoryTableViewCell


- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(IMCategory *)model
{
    _model = model;
    [self loadUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //[self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.title.preferredMaxLayoutWidth = CGRectGetWidth(self.title.frame);
}
- (void)loadUI
{
//    self.title.text = _model.name;
//    
//    self.imgView.image = [UIImage imageNamed:@"productPlaceHolder"];
//    
//    NSLog(@"URL: %@",_model.imageURL);
//    if(_model.imageURL && _model.imageURL != ((id)[NSNull null]) )
//    {
//        [self.imgView setImageWithURL:[NSURL URLWithString:_model.imageURL]
//          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }

}

@end
