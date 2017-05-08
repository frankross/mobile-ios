//
//  IMOfferCollectionViewCell.m
//  InstaMed
//
//  Created by Arjuna on 05/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOfferCollectionViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"


@implementation IMOfferCollectionViewCell

- (void)loadUI
{
    [self.imageView setImage:[UIImage imageNamed:IMProductPlaceholderName]];

    if(_model.offerImageURL != ((id)[NSNull null]))
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:_model.offerImageURL]  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)setModel:(IMOffer *)model
{
    _model = model;
    [self loadUI];
}

@end
