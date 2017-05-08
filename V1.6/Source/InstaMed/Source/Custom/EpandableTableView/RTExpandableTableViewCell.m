//
//  RTExpandableTableViewCell.m
//
//  Created by Yatheesh BL on 25/04/14.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "RTExpandableTableViewCell.h"
#import "RTExpandIndicatorView.h"

static const NSUInteger kIndicatorTag = 456;
static NSString *const kExpandableImageName = @"DownArrow";

@implementation RTExpandableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self commonInitialization];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInitialization];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInitialization];
    }
    return self;
}

-(void)commonInitialization
{
    [self setIsExpandable:NO];
    [self setIsExpanded:NO];
    
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:10/255.0 green:172/255.0 blue:90/255.0 alpha:1]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isExpanded)
    {
        if (![self containsIndicatorView])
        {
            [self addIndicatorView];
        }
        else
        {
            [self removeIndicatorView];
            [self addIndicatorView];
        }
    }
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image)
    {
        _image = [UIImage imageNamed:kExpandableImageName];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

- (void)setIsExpandable:(BOOL)isExpandable
{
    if (isExpandable)
    {
        [self setAccessoryView:[self expandableView]];
    }
    _isExpandable = isExpandable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)addIndicatorView
{
    CGPoint point = self.accessoryView.center;
    CGRect bounds = self.accessoryView.bounds;
    
    CGRect frame = CGRectMake(self.contentView.center.x , point.y * 1.4, CGRectGetWidth(bounds) * 3.0, CGRectGetHeight(self.bounds) - point.y * 1.4);
    
    RTExpandIndicatorView *indicatorView = [[RTExpandIndicatorView alloc] initWithFrame:frame];
    indicatorView.tag = kIndicatorTag;
    //For showing triangle view to pointing towards the parent row
//    [self.contentView addSubview:indicatorView];
}

- (void)removeIndicatorView
{
    id indicatorView = [self.contentView viewWithTag:kIndicatorTag];
    if (indicatorView)
    {
        [indicatorView removeFromSuperview];
    }
}

- (BOOL)containsIndicatorView
{
    return [self.contentView viewWithTag:kIndicatorTag] ? YES : NO;
    
}

@end
