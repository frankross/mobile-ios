//
//  IMcategoryTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 04/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMCategory.h"
@interface IMcategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IMCategory *model;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
