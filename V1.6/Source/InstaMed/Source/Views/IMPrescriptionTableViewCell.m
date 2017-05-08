//
//  IMPrescriptionTableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionTableViewCell.h"

@interface IMPrescriptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleReferenceLabel;

@property (weak, nonatomic) IBOutlet UILabel *expiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dosage1Label;
@property (weak, nonatomic) IBOutlet UILabel *dosage2Label;
@property (weak, nonatomic) IBOutlet UILabel *dosage3Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dosage3BottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *referenceNumber;


@end


@implementation IMPrescriptionTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(IMPrescription *)model
{
    _model = model;
    [self loadUI];
}

- (void)loadUI
{
    if (!_model.identifier)
    {
        NSString *prescriptionNo = @"Prescription no: ";
        NSString *notAvailable = @"Not available";
        NSString * referenceNum = [NSString stringWithFormat:@"%@%@", prescriptionNo,notAvailable];
        
        NSMutableAttributedString* referenceString = [[NSMutableAttributedString alloc] initWithString:referenceNum];
        [referenceString addAttribute:NSForegroundColorAttributeName value:APP_THEME_COLOR range:NSMakeRange(0,prescriptionNo.length)];
        [referenceString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(prescriptionNo.length,notAvailable.length)];
        self.titleReferenceLabel.attributedText = referenceString;
    }
    else
    {
        self.titleReferenceLabel.text = [NSString stringWithFormat:@"Prescription no: %@",_model.identifier];
    }
    if(_model.isExpired)
    {
        self.expiryLabel.text = @"Expired";
    }
    else
    {
        self.expiryLabel.text = @"";
    }

    NSString *dateString;
    
    if(_model.date)
    {
        dateString = _model.date;
        
        NSMutableAttributedString *attString =[[NSMutableAttributedString alloc]
                                               initWithString:dateString];
        
        UIFont *mediumFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        [attString setAttributes:@{NSFontAttributeName: mediumFont} range:NSMakeRange(0, _model.date.length)];
        
        self.dateLabel.attributedText = attString;

    }
    else
    {
        self.dateLabel.text = @"";
    }
    self.dosage2Label.text = @"";
    self.dosage1Label.text = @"";

    self.expiryDateLabel.text = _model.expiryDate;
    self.patientNameLabel.text = _model.patient.name;
    self.doctorNameLabel.text = _model.doctor.name;
    if(_model.dosageList.count)
    {
        self.dosage1Label.text = _model.dosageList[0];
    }
    if(_model.dosageList.count > 1)
    {
        self.dosage2Label.text = _model.dosageList[1];
    }
   
    if(_model.moreCount.integerValue > 0)
    {
        self.dosage3Label.text = [NSString stringWithFormat:@"+%@ more",_model.moreCount];
         self.dosage3BottomConstraint.constant = 15.0f;
    }
    else
    {
        self.dosage3Label.text = @"";
        self.dosage3BottomConstraint.constant = 11.0f;
    }
    
    if (_model.referenceNumber && ![_model.referenceNumber isEqualToString:@""])
    {
        self.referenceNumber.text = [NSString stringWithFormat:@"Ref:%@", _model.referenceNumber];
    }
    else
    {
        self.referenceNumber.text = @"Ref no: NA";
    }
}

@end
