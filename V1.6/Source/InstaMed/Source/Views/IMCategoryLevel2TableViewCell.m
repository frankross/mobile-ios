//
//  IMCategoryLevel2TableViewCell.m
//  InstaMed
//
//  Created by Suhail K on 31/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCategoryLevel2TableViewCell.h"

@implementation IMCategoryLevel2TableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsExpanded:(BOOL)isExpanded
{
    [super setIsExpanded:isExpanded];
    if (isExpanded)
    {
        self.title.textColor = [UIColor blackColor];
    }
    else
    {
        self.title.textColor = APP_THEME_COLOR;

    }

}
@end
