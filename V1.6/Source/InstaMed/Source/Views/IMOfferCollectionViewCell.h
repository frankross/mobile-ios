//
//  IMOfferCollectionViewCell.h
//  InstaMed
//
//  Created by Arjuna on 05/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

#import "IMOffer.h"

@interface IMOfferCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) IMOffer* model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)loadUI;

@end
