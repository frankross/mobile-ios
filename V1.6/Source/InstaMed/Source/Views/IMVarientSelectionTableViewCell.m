//
//  IMVarientSelectionTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMVarientSelectionTableViewCell.h"
@interface IMVarientSelectionTableViewCell()

@end

@implementation IMVarientSelectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModel:(IMVarientSelction *)model
{
    self.model = model;
    [self loadUI];
}

- (void)loadUI
{
    
}

@end
