//
//  IMSubCategoryTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 07/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSubCategoryTableViewCell.h"

@implementation IMSubCategoryTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setModel:(IMCategory *)model
{
    _model = model;
    [self updateUI];
}

-(void)updateUI
{
    self.subCatLabel.text = [NSString stringWithFormat:@"%@", self.model.name];
    self.subCatLabel.textColor = APP_THEME_COLOR;
    self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
}

@end
