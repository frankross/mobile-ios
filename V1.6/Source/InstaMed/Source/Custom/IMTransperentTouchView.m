//
//  IMTransperentTouchView.m
//  InstaMed
//
//  Created by Suhail K on 26/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMTransperentTouchView.h"

@implementation IMTransperentTouchView


/**
 @brief bypass the touch on the view
 @returns void
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // UIView will be "transparent" for touch events if we return NO
    return NO;
}

@end
