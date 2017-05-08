//
//  IMPrescriptionFilterTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 02/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionFilterTableViewCell.h"

@implementation IMPrescriptionFilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if(selected)
    {
        self.nameLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:0.6];
        self.checkedImageView.image = [UIImage imageNamed:IMTickMarkImageName];
    }
    else
    {
        self.checkedImageView.image = nil;
        self.nameLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1];
    }
}
@end
