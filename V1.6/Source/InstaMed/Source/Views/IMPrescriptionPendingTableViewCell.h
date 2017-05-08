//
//  IMPrescriptionPendingTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 24/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMLineItem.h"

@interface IMPrescriptionPendingTableViewCell : UITableViewCell

@property (strong, nonatomic) IMLineItem *model;

@end