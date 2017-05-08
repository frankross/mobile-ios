//
//  IMRatingView.m
//  InstaMed
//
//  Created by Suhail K on 03/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMRatingView.h"
#define kLeftPadding 5.0f

@implementation IMRatingView

- (void)refreshStars {
    for(int i = 0; i < _starViews.count; ++i) {
        UIImageView *imageView = [_starViews objectAtIndex:i];
        if (_rating >= i+1) {
            imageView.image = _selectedStar;
        } else if (_rating > i) {
            imageView.image = _halfSelectedStar;
        } else {
            imageView.image = _notSelectedStar;
        }
    }
}

- (void)setupView {
    for(int i = 0; i < _maxRating; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_starViews addObject:imageView];
        [self addSubview:imageView];
    }
    [self refreshStars];
}

- (void)baseInit {
    _notSelectedStar = [UIImage imageNamed:@"not_selected_star"];
    _selectedStar = [UIImage imageNamed:@"selected_star"];
    _halfSelectedStar = [UIImage imageNamed:@"half_selected_star"];
    _starViews = [NSMutableArray array];
    _maxRating = kDefaultMaxRating;
    _midMargin = kDefaultMidMargin;
    _leftMargin = kDefaultLeftMargin;
    _rightMargin = kDefaultRightMargin;
    _minStarSize = kDefaultMinStarSize;
    _minAllowedRating = kDefaultMinAllowedRating;
    _maxAllowedRating = kDefaultMaxAllowedRating;
    _rating = _minAllowedRating;
    _canEdit = YES;
    [self setupView];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%f, %f, %f, %lu", self.frame.size.width, _leftMargin, _midMargin, (unsigned long)_starViews.count);
    float desiredImageWidth = (self.frame.size.width - (_leftMargin*2) - (_midMargin*_starViews.count)) / _starViews.count;
    float imageWidth = MAX(_minStarSize.width, desiredImageWidth);
    float imageHeight = MAX(_minStarSize.height, self.frame.size.height);
    
    for (int i = 0; i < _starViews.count; ++i) {
        
        UIImageView *imageView = [_starViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(_leftMargin + i*(_midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }
    
}

- (void)setMaxRating:(int)maxRating {
    if (_maxAllowedRating == _maxRating) {
        _maxAllowedRating = maxRating;
    }
    _maxRating = maxRating;
    
    
    // Remove old image views
    for(int i = 0; i < _starViews.count; ++i) {
        UIImageView *imageView = (UIImageView *) [_starViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [_starViews removeAllObjects];
    
    // Add new image views
    [self setupView];
    // Relayout and refresh
    [self setNeedsLayout];
    [self refreshStars];
}

- (void)setRating:(float)rating {
    _rating = rating;
    [self refreshStars];
}


@end
