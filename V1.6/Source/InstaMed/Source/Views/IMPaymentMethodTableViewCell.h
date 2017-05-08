//
//  IMPaymentMethodType1TableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 11/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMPaymentMethodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *radioImageview;

@end
