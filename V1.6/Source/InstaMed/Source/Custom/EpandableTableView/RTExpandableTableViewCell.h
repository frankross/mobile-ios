//
//  RTExpandableTableViewCell.h
//
//  Created by Yatheesh BL on 25/04/14.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@interface RTExpandableTableViewCell : UITableViewCell


@property (nonatomic, assign) BOOL isExpandable;

@property (nonatomic, assign) BOOL isExpanded;


- (void)addIndicatorView;

- (void)removeIndicatorView;

- (BOOL)containsIndicatorView;

@end
