//
//  IMVarientSelectionTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMVarientSelction.h"

@interface IMVarientSelectionTableViewCell : UITableViewCell

@property (strong, nonatomic) IMVarientSelction *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
