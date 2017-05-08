//
//  IMRewardPointTransactionTableViewCell.m
//  InstaMed
//
//  Created by Yusuf Ansar on 12/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMRewardPointTransactionTableViewCell.h"
#import "NSString+IMStringSupport.h"

@implementation IMRewardPointTransactionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTransactionModel:(IMRewardPointTransaction *)transactionModel
{
    self.dateLabel.text = transactionModel.date;
    self.summaryLabel.text = transactionModel.summary;
    NSString *transactionType = transactionModel.type;
    if([transactionType isEqualToString:@"debit"])
    {
        self.amountLabel.textColor = [UIColor redColor];
        self.amountLabel.text = [NSString stringWithFormat:@"- %@",[[transactionModel.amount description] rupeeSymbolPrefixedString]];;
        
    }
    else
    {
        self.amountLabel.textColor = APP_THEME_COLOR;
        self.amountLabel.text = [NSString stringWithFormat:@"+ %@",[[transactionModel.amount description] rupeeSymbolPrefixedString]];

    }
    //self.amountLabel.text = [[transactionModel.amount description] rupeeSymbolPrefixedString];
}

@end
