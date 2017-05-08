//
//  IMNonEditableTextView.m
//  InstaMed
//
//  Created by Suhail K on 11/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNonEditableTextView.h"

@implementation IMNonEditableTextView


/**
 @brief disbale the actions
 @returns BOOL
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

/**
 @brief disable the first responder
 @returns BOOL
 */
- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end
