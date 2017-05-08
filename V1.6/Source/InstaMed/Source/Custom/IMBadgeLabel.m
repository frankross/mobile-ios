//
//  IMBadgeLabel.m
//  InstaMed
//
//  Created by Suhail K on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBadgeLabel.h"

@implementation IMBadgeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCorner)UIRectCornerAllCorners cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSaveGState(ctx);
    {
        CGContextAddPath(ctx, borderPath.CGPath);
        
        CGContextSetLineWidth(ctx, 4.0f);
        CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
        
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    {
        CGContextSetFillColorWithColor(ctx, CART_BADGE_COLOR.CGColor);
        
        CGRect textFrame = rect;
        //[self.text sizeWithFont:[UIFont systemFontOfSize:13.0f]];
        const CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
        
        
        textFrame.size.height = textSize.height;
        textFrame.origin.y = rect.origin.y + ceilf((rect.size.height - textFrame.size.height) / 2.0f);
        
//        [self.text drawInRect:textFrame
//                     withFont:[UIFont systemFontOfSize:13.0f]
//                lineBreakMode:NSLineBreakByClipping
//                    alignment:NSTextAlignmentCenter];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [self.text drawInRect:textFrame withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:CART_BADGE_COLOR}];
    }
    CGContextRestoreGState(ctx);
}


@end
