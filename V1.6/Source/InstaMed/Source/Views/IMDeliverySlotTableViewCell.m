//
//  IMDeliverySlotTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDeliverySlotTableViewCell.h"

@implementation IMDeliverySlotTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
    {
        self.checkedImageView.image = [UIImage imageNamed:IMTickMarkImageName];
        self.slotTitleLable.textColor = [UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0];
    }
    else
    {
        self.checkedImageView.image = nil;
        self.slotTitleLable.textColor = [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1.0];
    }
}

@end
