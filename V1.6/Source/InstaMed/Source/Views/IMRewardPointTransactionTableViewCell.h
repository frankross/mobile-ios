//
//  IMRewardPointTransactionTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 12/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMRewardPointTransaction.h"
@interface IMRewardPointTransactionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) IMRewardPointTransaction *transactionModel;
@end
