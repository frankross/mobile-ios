//
//  IMBackInStockItemNotificationTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 20/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMLabel.h"

@interface IMBackInStockItemNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IMLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (weak, nonatomic) IBOutlet UILabel *sellingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;

@end
