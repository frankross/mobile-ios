//
//  IMPrescriptionFilterTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 02/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMPrescriptionFilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;

@end
