//
//  IMCartOfferCollectionViewCell.m
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartOfferCollectionViewCell.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import "IMCartUtility.h"

@implementation IMCartOfferCollectionViewCell

- (void)loadUI
{
    self.offerTitle.text = @"";
    // offer with only text
    if (!self.model.offerImageURL || [self.model.offerImageURL isEqualToString:@""]) {
        self.offerImageWidthConstraint.constant = 0;
        self.offerImageLeadingSpaceConstraint.constant = 0;
        self.offerTitle.textAlignment = NSTextAlignmentLeft;
    }
    else{
        self.offerTitle.textAlignment = NSTextAlignmentLeft;
        [self.imageView setImageWithURL:[NSURL URLWithString:_model.offerImageURL]  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    NSString *offertext = [NSString stringWithFormat:@"%@\n%@",self.model.mainText,self.model.subText];

    NSAttributedString *attributedString = [IMCartUtility bold:self.model.mainText inText:offertext];
    self.offerTitle.attributedText = attributedString;

}

- (void)setModel:(IMPromotionOffer *)model
{
    _model = model;
    [self loadUI];
}

@end
