//
//  RTExpandableTableView.h
//
//  Created by Yatheesh BL on 25/04/14.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <UIKit/UIKit.h>

@class RTExpandableTableView;

@protocol RTExpandableTableViewDelegate;
@protocol RTExpandableTableViewDataSource;

@interface RTExpandableTableView : UITableView

@property(nonatomic,weak) IBOutlet id <RTExpandableTableViewDataSource> et_dataSource;
@property(nonatomic,weak) IBOutlet id <RTExpandableTableViewDelegate> et_delegate;

@property(nonatomic) BOOL shouldExpandOnlyOneCell;
- (void)collapseCurrentlyExpandedIndexPaths;

-(BOOL)isCellExpandedAtIndexPath:(NSIndexPath *)indexPath;

@end


#pragma mark - RTExpandableTableViewDataSource
@protocol RTExpandableTableViewDataSource <UITableViewDataSource>

- (NSInteger)tableView:(RTExpandableTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(RTExpandableTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;


@end


#pragma mark - RTExpandableTableViewDelegate
@protocol RTExpandableTableViewDelegate <UITableViewDelegate>

@optional

- (CGFloat)tableView:(RTExpandableTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@end



#pragma mark - NSIndexPath (RTExpandableTableView)

@interface NSIndexPath (RTExpandableTableView)

@property (nonatomic, assign) NSInteger subRow;

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;

@end