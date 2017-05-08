//
//  IMOrderSummaryPriceTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 29/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderSummaryPriceTableViewCell.h"
#import "IMCart.h"

@implementation IMOrderSummaryPriceTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellForOrder:(IMOrder *)order andRewardPointCheckBoxSelected:(BOOL) checkBoxChecked
{

        self.shippingChargesValuelabel.text =  [NSString stringWithFormat:@"%@ %@",IMRupeeSymbol,order.shippingCharges] ;
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %.02f", IMRupeeSymbol ,order.totalAmount.floatValue];
    
    if (order.promotionDiscountTotal && ![order.promotionDiscountTotal isEqualToString:@""] && ![order.promotionDiscountTotal isEqualToString:@"0.00"])
    {
        self.additionalDiscountValueLabel.text = [NSString stringWithFormat:@"- ₹ %@",order.promotionDiscountTotal];
        self.additionalDiscountTitlelabel.text = IMDiscountTitle;
        self.additionalDiscountTopConstraint.constant = 6;
    }
    else
    {
        [self hideAdditionalDiscountControls];
        
    }
    self.rewardPointPriceDescriptionLabel.text = [NSString stringWithFormat:@"Pay ₹ %.02f from Frank Ross wallet",order.walletAmount.floatValue];
    if(checkBoxChecked)
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"checked_checkbox"];
        self.rewardPointTitleLabel.text = @"Frank Ross wallet balance";
        self.rewardPointValueLabel.text = [NSString stringWithFormat:@"- ₹ %.02f",order.walletAmount.floatValue];
        self.rewardPointTitleLabelTopCOnstraint.constant = 13;
        self.rewardPointLabelBottomConstraint.constant = 13;
        self.rewardPointTitleHeightConstraint.constant = 17;
        self.rewardPointValueHeightConstraint.constant = 17;
        self.separotorViewBelowRewardPoint.hidden = NO;
    }
    else
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"unchecked_checkbox"];
        self.rewardPointTitleLabel.text = @"";
        self.rewardPointValueLabel.text = @"";
        self.rewardPointTitleLabelTopCOnstraint.constant = 0;
        self.rewardPointLabelBottomConstraint.constant = 0;
        self.rewardPointTitleHeightConstraint.constant = 0;
        self.rewardPointValueHeightConstraint.constant = 0;
        self.separotorViewBelowRewardPoint.hidden = YES;
    }
    
    //to hide the checkBox

        self.checkBoxButtonHeightConstraint.constant = 0;
        self.checkBoxImageViewTopConstraint.constant = 8;
        self.checkBoxImageViewHeightConstaint.constant = 0;
        self.rewardPointPriceDescriptionLabel.hidden = YES;


}

- (void) configureCellForCart:(IMCart *)cart andRewardPointCheckBoxSelected:(BOOL)checkBoxChecked
{
    self.shippingChargesValuelabel.text = [NSString stringWithFormat:@"%@ %@",IMRupeeSymbol,cart.shippingsTotal] ;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %.02f", IMRupeeSymbol ,cart.netPayableAmount.floatValue];
    
    if (cart.promotionDiscountTotal && ![cart.promotionDiscountTotal isEqual:@""] && ![cart.promotionDiscountTotal isEqual:@"0.00"]) {
        self.additionalDiscountValueLabel.text = [NSString stringWithFormat:@"- ₹ %@",cart.promotionDiscountTotal];
        self.additionalDiscountTitlelabel.text = IMDiscountTitle;
        self.additionalDiscountTopConstraint.constant = 6;
    }
    else
    {
        [self hideAdditionalDiscountControls];
    }
    self.rewardPointPriceDescriptionLabel.text = [NSString stringWithFormat:@"Pay ₹ %.02f from Frank Ross wallet",cart.walletAmount.floatValue];
    if(checkBoxChecked)
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"checked_checkbox"];
        self.rewardPointTitleLabel.text = @"Frank Ross wallet balance";
        self.rewardPointValueLabel.text = [NSString stringWithFormat:@"- ₹ %.02f",cart.walletAmount.floatValue];
        self.rewardPointTitleLabelTopCOnstraint.constant = 13;
        self.rewardPointLabelBottomConstraint.constant = 13;
        self.rewardPointTitleHeightConstraint.constant = 17;
        self.rewardPointValueHeightConstraint.constant = 17;
        self.separotorViewBelowRewardPoint.hidden = NO;
    }
    else
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"unchecked_checkbox"];
        self.rewardPointTitleLabel.text = @"";
        self.rewardPointValueLabel.text = @"";
        self.rewardPointTitleLabelTopCOnstraint.constant = 0;
        self.rewardPointLabelBottomConstraint.constant = 0;
        self.rewardPointTitleHeightConstraint.constant = 0;
        self.rewardPointValueHeightConstraint.constant = 0;
        self.separotorViewBelowRewardPoint.hidden = YES;
    }
    if(cart.walletAmount.floatValue == 0.0f)
    {
        self.checkBoxButtonHeightConstraint.constant = 0;
        self.checkBoxImageViewTopConstraint.constant = 8;
        self.checkBoxImageViewHeightConstaint.constant = 0;
        self.rewardPointPriceDescriptionLabel.hidden = YES;
    }

}

- (void) hideAdditionalDiscountControls
{
    self.additionalDiscountTitlelabel.text = @"";
    self.additionalDiscountValueLabel.text = @"";
    self.additionalDiscountTopConstraint.constant = 0;
 
}

#pragma mark - IBActions

- (IBAction)clickedApplyWalletCheckBox:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickApplyWalletCheckBox)])
    {
        [self.delegate didClickApplyWalletCheckBox];
    }
}



@end
