//
//  IMLabel.m
//  InstaMed
//
//  Created by Arjuna on 11/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMLabel.h"

@implementation IMLabel


- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    
    if ((self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) || (self.numberOfLines > 1 && bounds.size.width != self.preferredMaxLayoutWidth) ) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}


- (void)layoutSubviews
{
    self.preferredMaxLayoutWidth = self.frame.size.width;
    [super layoutSubviews];
}

@end
