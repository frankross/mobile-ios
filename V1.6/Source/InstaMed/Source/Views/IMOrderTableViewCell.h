//
//  IMOrderTableViewCell.h
//  InstaMed
//
//  Created by Arjuna on 30/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMOrder.h"

@interface IMOrderTableViewCell : UITableViewCell

@property(nonatomic,strong) IMOrder* model;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;

@end
