//
//  IMSearchTableViewCell.h
//  InstaMed
//
//  Created by Arjuna on 22/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface IMNonPharmaSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@end
