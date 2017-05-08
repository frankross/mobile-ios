//
//  IMCartTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMLineItem.h"

@interface IMCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *qtyButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *prescriptionrequiredLabel;
@property (weak, nonatomic) IBOutlet UILabel *insufficientInventoryLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insufficientInventoryTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *priceOverlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insufficientInventoryBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prescriptionRequiredBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerLabelBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prescriptionRequiredHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insufficientInventoryHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *cashbackDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconBottomConstraint;

@end
