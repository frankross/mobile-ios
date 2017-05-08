//
//  IMImageCollectionViewCell.h
//  InstaMed
//
//  Created by Suhail K on 03/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;

@end
