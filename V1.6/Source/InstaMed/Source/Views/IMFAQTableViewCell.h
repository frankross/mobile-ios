//
//  IMFAQTableViewCell.h
//  InstaMed
//
//  Created by Yusuf Ansar on 04/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>
#import "IMFAQ.h"
#import "RTExpandableTableViewCell.h"

@interface IMFAQTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *expansionIndicatorImageView;

@property(nonatomic,strong) IMFAQ* model;
@property(nonatomic) BOOL showingAnswer;

@end
