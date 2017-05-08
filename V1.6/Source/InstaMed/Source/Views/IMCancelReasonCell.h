//
//  IMCancelReasonCell.h
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMCancelReason.h"

@interface IMCancelReasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cancelReasonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;

@property(nonatomic,strong) IMCancelReason* model;

@end
