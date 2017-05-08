//
//  IMTagCollectionViewCell.h
//  InstaMed
//
//  Created by Kavitha on 19/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@class IMCoupon;

/**
 @brief Class representing the Coupon tags with coupon code and cross mark displayed in the Cart screen below the enter coupon code field.
 */
@interface IMTagCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) IMCoupon* model;
@property (weak, nonatomic) IBOutlet UILabel *couponCode;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;

- (void)loadUI;

@end
