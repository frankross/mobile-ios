//
//  IMMoreTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMMoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLAbel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;
@property (weak, nonatomic) IBOutlet UIButton *disclosure;

@end
