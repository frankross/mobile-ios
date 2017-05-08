//
//  IMPharmaSerachTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 31/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMPharmaSerachTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *comPanyNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@end
