//
//  IMproductDosageTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMproductDosageTableViewCell.h"

@interface IMproductDosageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *productname;
@property (weak, nonatomic) IBOutlet UILabel *strength;
@property (weak, nonatomic) IBOutlet UILabel *forDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forDaysTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frequencyTopConstraint;
@end

@implementation IMproductDosageTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(IMProductDosage *)model
{
    _model = model;
    [self loadUI];
}

- (void)loadUI
{
    NSString *productName =@"";
    if(_model.productName)
    {
        productName = _model.productName;
    }
    self.productname.attributedText = [self attributedStringForString:productName];
    
//    if (_model.sos)
//    {
//        [self configureForSos];
//        [self configureDuration];
//        [self configureStrengthLabel];
//        [self configureFrequencyLabel];
//    }
//    else
//    {
        [self configureDuration];
        [self configureStrengthLabel];
        [self configureFrequencyLabel];
//    }
}

- (void)configureForSos
{
    self.strength.text = @"As per instruction";
    self.frequencyLabel.text = @"";
    self.frequencyTopConstraint.constant = 0.0f;
}

- (void)configureDuration
{
    self.forDaysLabel.text = @"";

    if (_model.duration && ![_model.duration isEqualToString:@""])
    {
        NSString *forDayString = [NSString stringWithFormat:@"%@",_model.duration];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:forDayString];
//        [attString addAttribute: NSFontAttributeName value:  [UIFont fontWithName:@"HelveticaNeue" size:14] range: NSMakeRange(0,3)];
//        [attString addAttribute: NSFontAttributeName value:  [UIFont fontWithName:@"HelveticaNeue" size:14] range: NSMakeRange(forDayString.length - 4,4)];
        
    self.forDaysLabel.attributedText = attString;
    }
    else
    {
        self.forDaysLabel.text = @"";
    }
}

- (void)configureStrengthLabel
{
    self.strength.text = _model.quantity;
    if (_model.foodInstruction)
    {
        if (self.strength.text)
        {
            self.strength.text = [NSString stringWithFormat:@"%@, %@", _model.quantity, [_model.foodInstruction lowercaseString]];
        }
        else
        {
            self.strength.text = _model.foodInstruction;
        }
    }
}

- (void)configureFrequencyLabel
{
    self.frequencyTopConstraint.constant = 4.0f;
    NSString *frequencyString= @"";
    if (_model.specificTimings)
    {
        frequencyString = _model.specificTimings;
//        self.frequencyLabel.text = _model.specificTimings;
    }
    else
    {
        if (_model.frequency && ![_model.frequency isEqualToString:@""])
        {
            
            if ([self timeString])
            {
                frequencyString = [NSString stringWithFormat:@"%@, %@", _model.frequency, [self timeString]];
//                self.frequencyLabel.text = [NSString stringWithFormat:@"%@, %@", _model.frequency, [self timeString]];
            }
            else
            {
                frequencyString = _model.frequency;;
//                self.frequencyLabel.text = _model.frequency;
            }
        }
        else
        {
            if ([self timeString])
            {
                frequencyString = [self timeString];
//                self.frequencyLabel.text = [self timeString];
            }
            else
            {
                frequencyString = @"As per instruction";
//                self.frequencyLabel.text = @"As per instruction";
//                self.frequencyTopConstraint.constant = 0.0f;
            }
        }
        
    }
    self.frequencyLabel.attributedText = [self attributedStringForString:frequencyString];

}

- (NSString *)timeString
{
    NSString *timeString = nil;
    
    if (_model.timeMorning)
    {
        timeString = @"Morning";
    }
    
    if (_model.timeAfternoon)
    {
        timeString = timeString == nil ? @"Afternoon" : [NSString stringWithFormat:@"%@, afternoon", timeString];
    }
    
    if (_model.timeEvening)
    {
        timeString = timeString == nil ? @"Evening" : [NSString stringWithFormat:@"%@, evening", timeString];
    }
    
    if (_model.timeNight)
    {
        timeString = timeString == nil ? @"Night" : [NSString stringWithFormat:@"%@, night", timeString];
    }
    return timeString;
}

-(void)layoutSubviews
{
    // http://stackoverflow.com/questions/15058108/ios-multiline-uilabel-only-shows-one-line-with-autolayout
    [super layoutSubviews];
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    self.productname.preferredMaxLayoutWidth = 240.0;
//    CGFloat width = self.frame.size.width - self.forDaysLabel.frame.size.width - 20;
//    self.productname.preferredMaxLayoutWidth = CGRectGetWidth(self.productname.frame);
    self.strength.preferredMaxLayoutWidth = 280.0f;
    self.frequencyLabel.preferredMaxLayoutWidth = 240.0f;
    self.forDaysLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.forDaysLabel.frame);
}

- (NSMutableAttributedString *)attributedStringForString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
    
}
@end
