//
//  RTExpandableTableView.m
//
//  Created by Yatheesh BL on 25/04/14.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "RTExpandableTableView.h"
#import "RTExpandableTableViewCell.h"
#import "RTExpandIndicatorView.h"
#import <objc/runtime.h>

CGFloat const rowHeight = 44.0f;

#pragma mark - NSArray (RTExpandableTableView)

@interface NSMutableArray (RTExpandableTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (RTExpandableTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems
{
    for (NSInteger index = [self count]; index < numItems; index++)
    {
        NSMutableArray *array = [NSMutableArray array];
        [self addObject:array];
    }
}

@end


#pragma mark - ZEExpandableTableView
@interface RTExpandableTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;
@property (nonatomic, strong) NSMutableDictionary *expandableCells;

@end


@implementation RTExpandableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit
{
    _shouldExpandOnlyOneCell = NO;
    
}

-(void)setEt_dataSource:(id<RTExpandableTableViewDataSource>)et_dataSource
{
    self.dataSource = self;
    [self setSeparatorColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    
    if (!_et_dataSource) {
        _et_dataSource = et_dataSource;
    }
}

-(void)setEt_delegate:(id<RTExpandableTableViewDelegate>)et_delegate
{
    self.delegate = self;
    
    if (!_et_delegate) {
        _et_delegate = et_delegate;
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    [super setSeparatorColor:separatorColor];
    [RTExpandIndicatorView setIndicatorColor:separatorColor];
}

- (NSMutableArray *)expandedIndexPaths
{
    if (!_expandedIndexPaths)
    {
        _expandedIndexPaths = [NSMutableArray array];
    }
    
    return _expandedIndexPaths;
}

- (NSMutableDictionary *)expandableCells
{
    if (!_expandableCells)
    {
        _expandableCells = [NSMutableDictionary dictionary];
    }
    return _expandableCells;
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.et_dataSource tableView:tableView numberOfRowsInSection:section] + [[[self expandedIndexPaths] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        RTExpandableTableViewCell *cell = (RTExpandableTableViewCell *)[self.et_dataSource tableView:tableView cellForRowAtIndexPath:tempIndexPath];
        
        if ([[self.expandableCells allKeys] containsObject:tempIndexPath])
        {
            [cell setIsExpanded:[[self.expandableCells objectForKey:tempIndexPath] boolValue]];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if (cell.isExpandable)
        {
            [self.expandableCells setObject:[NSNumber numberWithBool:[cell isExpanded]]
                                     forKey:indexPath];
            
            UIButton *expandableButton = (UIButton *)cell.accessoryView;
            [expandableButton addTarget:tableView
                                 action:@selector(expandableButtonTouched:event:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            if (cell.isExpanded)
            {
                cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            else
            {
                if ([cell containsIndicatorView])
                {
                    [cell removeIndicatorView];
                }
            }
            
        }
        else
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            [cell removeIndicatorView];
            cell.accessoryView = nil;
        }
        
        return cell;
        
    }
    else
    {
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        UITableViewCell *cell = [self.et_dataSource tableView:(RTExpandableTableView *)tableView cellForSubRowAtIndexPath:indexPathForSubrow];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        cell.indentationLevel = 2;
        
        return cell;
    }
}

#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.et_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        NSInteger numberOfSections = [self.et_dataSource numberOfSectionsInTableView:tableView];
        
        if ([self.expandedIndexPaths count] != numberOfSections)
        {
            [self.expandedIndexPaths initiateObjectsForCapacity:numberOfSections];
        }
        
        return numberOfSections;
    }
    
    return 1;
}


#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];
    
    RTExpandableTableViewCell *cell = (RTExpandableTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RTExpandableTableViewCell class]] && cell.isExpandable)
    {
        cell.isExpanded = !cell.isExpanded;
                
        NSIndexPath *_indexPath = indexPath;
        if (cell.isExpanded && self.shouldExpandOnlyOneCell)
        {
            _indexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            [self collapseCurrentlyExpandedIndexPaths];
        }
        
        NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:_indexPath];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger row = _indexPath.row;
        NSInteger section = _indexPath.section;
        
        for (NSInteger index = 1; index <= numberOfSubRows; index++)
        {
            NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
            [indexPaths addObject:expIndexPath];
        }
        
        if (cell.isExpanded)
        {
            [self setIsExpanded:YES forCellAtIndexPath:_indexPath];
            [self insertExpandedIndexPaths:indexPaths forSection:_indexPath.section];
            
        }
        else
        {
            [self setIsExpanded:NO forCellAtIndexPath:_indexPath];
            [self removeExpandedIndexPaths:indexPaths forSection:_indexPath.section];
        }
        
        [self accessoryViewAnimationForCell:cell];
    }
    
     [tableView endUpdates];
    if ([_et_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [_et_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    if ([_et_delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [_et_delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_et_delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
    {
        [_et_delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        if ([_et_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        {
            NSIndexPath *mainIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            return [_et_delegate tableView:tableView heightForRowAtIndexPath:mainIndexPath];
            
        }
        return rowHeight;
    }
    else
    {
        if ([_et_delegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)])
        {
            NSIndexPath *subIndexPath = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
            return [_et_delegate tableView:(RTExpandableTableView *)tableView heightForSubRowAtIndexPath:subIndexPath];
        }
        return rowHeight;
    }
}

#pragma mark - ExpandableTableViewUtils

- (IBAction)expandableButtonTouched:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath)
    {
        [self tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_et_dataSource tableView:self numberOfSubRowsAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
}

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    NSInteger row = 0;
    
    while (index < indexPath.row)
    {
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded)
        {
            NSInteger numberOfExpandedRows = [_et_dataSource tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            index += (numberOfExpandedRows + 1);
        }
        else
        {
            index++;
        }
        row++;
    }
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (NSIndexPath *)correspondingIndexPathForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    NSInteger row = 0;
    NSInteger subrow = 0;
    
    while (1)
    {
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded)
        {
            NSInteger numberOfExpandedRows = [_et_dataSource tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            if ((indexPath.row - index) <= numberOfExpandedRows)
            {
                subrow = indexPath.row - index;
                break;
            }
            index += (numberOfExpandedRows + 1);
            
        }
        else
        {
            index++;
        }
        
        row++;
    }
    
    return [NSIndexPath indexPathForSubRow:subrow inRow:row inSection:indexPath.section];
}

- (void)setIsExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    [self.expandableCells setObject:[NSNumber numberWithBool:isExpanded] forKey:correspondingIndexPath];
}

- (void)insertExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    NSIndexPath *firstIndexPathToExpand;
    NSIndexPath *firstIndexPathExpanded = nil;
    if(indexPaths.count >0)
    {
        firstIndexPathToExpand = indexPaths[0];
    }
    
    
    if ([self.expandedIndexPaths[section] count] > 0) firstIndexPathExpanded = self.expandedIndexPaths[section][0];
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    if (firstIndexPathExpanded && firstIndexPathToExpand.section == firstIndexPathExpanded.section && firstIndexPathToExpand.row < firstIndexPathExpanded.row)
    {
        [self.expandedIndexPaths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] + [indexPaths count])
                                                      inSection:[obj section]];
            
            [array addObject:updated];
        }];
        
        [array addObjectsFromArray:indexPaths];
        
        self.expandedIndexPaths[section] = array;
        
    }
    else
    {
        [self.expandedIndexPaths[section] addObjectsFromArray:indexPaths];
    }
    
    [self sortExpandedIndexPathsForSection:section];
    
    // Reload TableView
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
}


- (void)removeExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    if(indexPaths.count > 0)
    {
        NSUInteger index = [self.expandedIndexPaths[section] indexOfObject:indexPaths[0]];
        
        [self.expandedIndexPaths[section] removeObjectsInArray:indexPaths];
        
        if (index == 0)
        {
            __block NSMutableArray *array = [NSMutableArray array];
            [self.expandedIndexPaths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] - [indexPaths count])
                                                          inSection:[obj section]];
                [array addObject:updated];
            }];
            
            self.expandedIndexPaths[section] = array;
        }
        [self sortExpandedIndexPathsForSection:section];
    }
    
    // Reload Tableview
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
}

- (void)collapseCurrentlyExpandedIndexPaths
{
    NSArray *expandedCells = [self.expandableCells allKeysForObject:[NSNumber numberWithBool:YES]];
    
    if (expandedCells.count > 0)
    {
        __weak RTExpandableTableView *_self = self;
        [expandedCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            [_self.expandableCells setObject:[NSNumber numberWithBool:NO] forKey:indexPath];
            
            if ([_self.expandedIndexPaths[indexPath.section] count] > 0)
            {
                [_self removeExpandedIndexPaths:[_self.expandedIndexPaths[indexPath.section] copy] forSection:indexPath.section];
            }
            
            RTExpandableTableViewCell *cell = (RTExpandableTableViewCell *)[_self cellForRowAtIndexPath:indexPath];
            cell.isExpanded = NO;
            [_self accessoryViewAnimationForCell:cell];
        }];
    }
}

- (BOOL)isCellExpandedAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    
    if ([[self.expandableCells allKeys] containsObject:tempIndexPath])
    {
        return [[self.expandableCells objectForKey:tempIndexPath] boolValue];
    }
    return NO;
}

- (void)sortExpandedIndexPathsForSection:(NSInteger)section
{
    [self.expandedIndexPaths[section] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 section] < [obj2 section])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if([obj1 section] > [obj2 section])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
        {
            if ([obj1 row] < [obj2 row])
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
    }];
}

- (void)accessoryViewAnimationForCell:(RTExpandableTableViewCell *)cell
{
    __block RTExpandableTableViewCell *_cell = cell;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (_cell.isExpanded)
        {
            _cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            _cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finished) {
        
        if (!_cell.isExpanded)
        {
            [_cell removeIndicatorView];
        }
        
    }];
}

@end


#pragma mark - NSIndexPath (RTExpandableTableView)

static void *subRowObjectKey;

@implementation NSIndexPath (RTExpandableTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id class = [RTExpandableTableView class];
    
    id subRowObj = objc_getAssociatedObject(class, subRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id class = [RTExpandableTableView class];
    
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(class, subRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    return indexPath;
}


@end
