//
//  IMProductTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMProduct.h"

@interface IMProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IMProduct *model;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productTitleTopConstraint;


@end
