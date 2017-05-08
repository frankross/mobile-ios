//
//  IMBadgeButton.m
//  InstaMed
//
//  Created by Suhail K on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBadgeButton.h"
#import "IMBadgeLabel.h"

@interface IMBadgeButton() {
    UITextView *calculationTextView;
    UILabel *badgeLabel;
}

@end
@implementation IMBadgeButton

+(id)buttonWithType:(UIButtonType)t {
    return [[IMBadgeButton alloc] init];
}

#pragma mark - Setters

- (void)setBadgeString:(NSString *)badgeString
{
    _badgeString = badgeString;
    
    [self setupBadgeViewWithString:badgeString];
//    [self runSpinAnimationOnView:badgeLabel duration:0.18 rotations:360 repeat:1];

}

/**
 @brief For spin animation while setting the badge count
 @returns void
 */
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setBadgeEdgeInsets:(UIEdgeInsets)badgeEdgeInsets
{
    _badgeEdgeInsets = badgeEdgeInsets;
    [self setupBadgeViewWithString:_badgeString];
}

-(void)setBadgeTextColor:(UIColor *)badgeTextColor {
    self->_badgeTextColor = badgeTextColor;
    [self setupBadgeStyle];
}

-(void)setBadgeBackgroundColor:(UIColor *)color {
    self->_badgeBackgroundColor = color;
    [self setupBadgeStyle];
}

#pragma mark - Initializers

- (id) init
{
    if(self == [super init]) {
        [self setupBadgeViewWithString:nil];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super initWithCoder:aDecoder]) {
        [self setupBadgeViewWithString:nil];
    }
    return self;
}

- (id) initWithFrame:(CGRect) frame withBadgeString:(NSString *)string
{
    if (self == [super initWithFrame:frame]) {
        [self setupBadgeViewWithString:string];
    }
    return self;
}

- (id) initWithFrame:(CGRect) frame withBadgeString:(NSString *)string badgeInsets:(UIEdgeInsets)badgeInsets
{
    if (self == [super initWithFrame:frame]) {
        self.badgeEdgeInsets = badgeInsets;
        [self setupBadgeViewWithString:string];
//        self.badgeTextColor = CART_BADGE_COLOR;
        self.badgeBackgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 @brief To set the badge count to the barbutton
 @returns void
 */
- (void) setupBadgeViewWithString:(NSString *)string
{
    
    if(!badgeLabel) {
        
        badgeLabel = [[IMBadgeLabel alloc] init];
    }
    [badgeLabel setClipsToBounds:YES];
    [badgeLabel setText:string];
    self.badgeTextColor = CART_BADGE_COLOR;
    [badgeLabel setFont:[UIFont systemFontOfSize:13]];
    CGSize badgeSize = [badgeLabel sizeThatFits:CGSizeMake(320, FLT_MAX)];
    badgeSize.width = badgeSize.width < 17 ? 22 : badgeSize.width + 5;
    
    int vertical = self.badgeEdgeInsets.top - self.badgeEdgeInsets.bottom;
    int horizontal = self.badgeEdgeInsets.left - self.badgeEdgeInsets.right;
    
    [badgeLabel setFrame:CGRectMake(self.bounds.size.width - 10 + horizontal, - (badgeSize.height / 2) - 10 + vertical, badgeSize.width,  badgeSize.width > 22 ? badgeSize.height : badgeSize.width)];
    [self setupBadgeStyle];
    [self addSubview:badgeLabel];
    
    badgeLabel.hidden = [string isEqualToString:@"0"] || string == nil ? YES : NO;
}

- (void) setupBadgeStyle
{
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    [badgeLabel setBackgroundColor:self.badgeBackgroundColor];
    [badgeLabel setTextColor:self.badgeTextColor];
    badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.width > 25 ? 8 : badgeLabel.bounds.size.width / 2;
}

/**
 @brief Setup a pulse animation while setting the badge
 @returns void
 */
- (void)animateBadge
{
//    // Create a basic animation changing the transform.scale value
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

//    // Set the initial and the final values
//    [animation setFromValue:[NSNumber numberWithFloat:3.5f]];
//    [animation setToValue:[NSNumber numberWithFloat:1.0f]];
//    
//    // Set duration
//    [animation setDuration:0.4f];
//    
//    // Set animation to be consistent on completion
//    [animation setRemovedOnCompletion:NO];
//    [animation setFillMode:kCAFillModeForwards];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//
//    // Add animation to the view's layer
//    [[badgeLabel layer] addAnimation:animation forKey:@"scale1"];
    
    [UIView animateWithDuration:1
                     animations:^{
                         badgeLabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                                              badgeLabel.transform = CGAffineTransformIdentity;
                                              
                                          }];
                     }];
}
@end
