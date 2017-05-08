//
//  IMAddressTableViewCell.h
//  InstaMed
//
//  Created by Arjuna on 19/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"
#import "IMAddress.h"

@interface IMAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddressIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cityPincodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultAddressLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultAdressheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultToNameVConstraint;

@end
