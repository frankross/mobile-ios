//
//  IMStoreTableViewCell.h
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMStore.h"

@interface IMStoreTableViewCell : UITableViewCell

@property (strong, nonatomic) IMStore *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timingLabel;
@property (weak, nonatomic) IBOutlet UILabel *KMLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@end
