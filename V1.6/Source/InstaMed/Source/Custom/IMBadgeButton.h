//
//  IMBadgeButton.h
//  InstaMed
//
//  Created by Suhail K on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//To handle the badged barbutton item
#import <UIKit/UIKit.h>

@interface IMBadgeButton : UIButton

@property (nonatomic, strong) NSString *badgeString;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic) UIEdgeInsets badgeEdgeInsets;

- (id) initWithFrame:(CGRect) frame withBadgeString:(NSString *)string badgeInsets:(UIEdgeInsets)badgeInsets;

- (void)animateBadge;
@end
