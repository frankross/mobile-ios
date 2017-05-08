//
//  IMOrderTableViewCell.m
//  InstaMed
//
//  Created by Arjuna on 30/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderTableViewCell.h"


@interface IMOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstProductNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondProductNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *reminderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondProductTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdProductTopConstraint;

@end

@implementation IMOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(void)updateUI
{
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"%@",self.model.identifier];
    [IMFunctionUtilities setBackgroundImage:self.reorderButton withImageColor:APP_THEME_COLOR];

    SET_CELL_CORER(self.reorderButton, 8.0);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    NSDate *date = [dateFormatter dateFromString:self.model.orderDate];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
    NSString *newDateString = [dateFormatter2 stringFromDate:date];

    
    self.orderDateLabel.text = newDateString;
    self.firstProductNameLabel.text = ((IMLineItem*)self.model.orderedItems[0]).name;
    
    
    if(self.model.orderedItems.count > 1 )
    {
        self.secondProductNameLabel.text = ((IMLineItem*)self.model.orderedItems[1]).name;
        self.secondProductTopConstraint.constant = 8.0f;
    }
    else
    {
        self.secondProductNameLabel.text = @"";
        self.secondProductTopConstraint.constant = 0.0f;
    }
    
    if(self.model.orderedItems.count > 2)
    {
        self.moreCountLabel.text = [NSString stringWithFormat:@"+%lu more",(unsigned long)self.model.orderedItems.count - 2];
        self.thirdProductTopConstraint.constant = 8.0f;
    }
    else
    {
        self.moreCountLabel.text = @"";
        self.thirdProductTopConstraint.constant = 0.0f;
    }
    
    self.orderStatusLabel.text = [self.model.stateDisplayName capitalizedString];
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %@",self.model.totalAmount];
    
    if(self.model.hasReoorderReminder)
    {
        self.reminderImageView.hidden = NO;
    }
    else
    {
        self.reminderImageView.hidden = YES;
    }
    if([_model.state isEqualToString:@"digitisation_mismatch"])
    {
        self.reorderButton.hidden = NO;
        [self.reorderButton setTitle:IMUpdateButtontitle forState:UIControlStateNormal];
    }
    else
    {
        //Button Enable/Disable
//        [self.reorderButton setTitle:@"Reorder" forState:UIControlStateNormal];
//        [self.reorderButton setTitle:@"" forState:UIControlStateNormal];
        if(!_model.isReorderable)
        {
            self.reorderButton.hidden = YES;
//            self.reorderButton.enabled = NO;
        }
        else
        {
            self.reorderButton.hidden = NO;
//            self.reorderButton.enabled = YES;
            [self.reorderButton setTitle:@"Reorder" forState:UIControlStateNormal];
        }
    }

//    if(!self.model.isReorderable)
//    {
//        self.reorderButton.hidden = YES;
//    }
//    else
//    {
//        self.reorderButton.hidden = NO;
//    }
    
}

-(void)setModel:(IMOrder *)model
{
    _model = model;
    [self updateUI];
}

@end
