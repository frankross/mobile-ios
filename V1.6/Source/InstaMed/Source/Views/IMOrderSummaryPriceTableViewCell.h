//
//  IMOrderSummaryPriceTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 29/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMOrder.h"

@protocol IMOrderSummaryPriceTableViewCellDelegate <NSObject>

- (void) didClickApplyWalletCheckBox;

@end

@interface IMOrderSummaryPriceTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IMOrderSummaryPriceTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *shippingChargesValuelabel;

@property (weak, nonatomic) IBOutlet UILabel *additionalDiscountTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalDiscountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardPointTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rewardPointValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardPointPriceDescriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalDiscountTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardPointTitleLabelTopCOnstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardPointLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardPointTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardPointValueHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (weak, nonatomic) IBOutlet UIView *separotorViewBelowRewardPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxImageViewHeightConstaint;
 

- (void) configureCellForOrder:(IMOrder *)order andRewardPointCheckBoxSelected:(BOOL) selected;
- (void) configureCellForCart: (IMCart *)cart andRewardPointCheckBoxSelected:(BOOL) selected;
@end
