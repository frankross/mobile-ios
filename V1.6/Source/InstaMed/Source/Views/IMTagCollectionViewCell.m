//
//  IMTagCollectionViewCell.m
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMTagCollectionViewCell.h"
#import "IMCoupon.h"

@implementation IMTagCollectionViewCell

- (void)loadUI
{
    self.couponCode.text = self.model.couponCode;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;

}

- (void)setModel:(IMCoupon*)model
{
    _model = model;
    [self loadUI];
}

@end
