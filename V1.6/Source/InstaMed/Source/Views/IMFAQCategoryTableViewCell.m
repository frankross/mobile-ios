//
//  IMFAQCategoryTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 08/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFAQCategoryTableViewCell.h"
@interface IMFAQCategoryTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *expansionImageView;

@end

@implementation IMFAQCategoryTableViewCell

- (void)awakeFromNib
{
    self.expansionImageView.transform = CGAffineTransformMakeRotation(M_PI_2 * 3);
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
   self.categoryNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.categoryNameLabel.frame);

    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end
