//
//  IMCategoryCollectionViewCell.h
//  InstaMed
//
//  Created by Suhail K on 04/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMCategory.h"

@interface IMCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) IMCategory* model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
