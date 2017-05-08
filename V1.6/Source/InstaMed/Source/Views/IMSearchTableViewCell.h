//
//  IMSearchTableViewCell.h
//  InstaMed
//
//  Created by Arjuna on 22/07/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@end
