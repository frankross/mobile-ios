//
//  IMProductListSortTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 17/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOptionsTableViewCell.h"
#import "IMSortType.h"
#import "IMOffer.h"
#import "IMBrand.h"
#import "IMCategory.h"

@interface IMOptionsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeadingConstraint;

@end

@implementation IMOptionsTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if(selected)
    {
        self.nameLabel.textColor = APP_THEME_COLOR_WITH_ALPHA;
        self.checkedImageView.image = [UIImage imageNamed:IMTickMarkImageName];
    }
    else
    {
        self.checkedImageView.image = nil;
        self.nameLabel.textColor = APP_THEME_COLOR;
    }
}

-(void)setModel:(IMSortType *)model
{
    _model = model;
    [self updateUI];
}

-(void)hideImageView
{
    self.nameLabelLeadingConstraint.constant = 0;
    self.imageViewWidthConstraint.constant = 0;
}

-(void)updateUI
{
    if([self.model isKindOfClass:[IMSortType class]])
    {
        self.nameLabel.text =((IMSortType*)self.model).name;
        [self hideImageView];
    }
    else if([self.model isKindOfClass:[IMOffer class]])
    {
        self.nameLabel.text =((IMOffer*)self.model).name;
        [self hideImageView];
    }
    else if([self.model isKindOfClass:[IMBrand class]])
    {
        self.nameLabel.text =((IMBrand*)self.model).name;
    }
    else if([self.model isKindOfClass:[IMCategory class]])
    {
//        self.nameLabel.text =  [NSString stringWithFormat:@"%@",((IMCategory *)self.model).identifier];
        self.nameLabel.text =((IMCategory*)self.model).name;

    }
}

@end
