//
//  IMCartOfferCollectionViewCell.h
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

#import "IMPromotionOffer.h"

/**
 @brief Class representing the Promotional offers with offer image and text displayed at the top of Cart screen.
 */
@interface IMCartOfferCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) IMPromotionOffer* model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *offerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerImageLeadingSpaceConstraint;

- (void)loadUI;

@end
