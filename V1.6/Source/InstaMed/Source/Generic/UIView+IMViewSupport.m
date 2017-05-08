//
//  NSString+IMViewSupport.m
//  InstaMed
//
//  Created by Arjuna on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "UIView+IMViewSupport.h"

const CGFloat RTNoAnimDelay                = 0.0f;
const CGFloat RTQuickAnimDuration          = 0.25f;
const CGFloat RTFastAnimDuration           = 0.3f;
const CGFloat RTAvgAnimDuration            = 1.0f;
const CGFloat RTSlowAnimDuration           = 2.0f;

@implementation UIView (IMViewSupport)

- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha duration:(CGFloat)duration
{
    [self fadeFromAplha:fromAlpha
                toAlpha:toAlpha
               duration:duration
                  delay:RTNoAnimDelay
                 option:UIViewAnimationOptionCurveEaseInOut
             completion:nil];
}

- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha
{
    [self fadeFromAplha:fromAlpha
                toAlpha:toAlpha
               duration:RTQuickAnimDuration
                  delay:RTNoAnimDelay
                 option:UIViewAnimationOptionCurveEaseInOut
             completion:nil];
}

- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha duration:(CGFloat)duration
                delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion
{
    self.alpha = fromAlpha;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:option
                     animations:^
     {
         self.alpha = toAlpha;
         
     }
                     completion:^(BOOL finished)
     {
         if(completion)
         {
             completion(finished);
         }
     }];
}

- (void)slideInForDuration:(CGFloat)duration
                delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenwidth = screenRect.size.width;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat centerX = (screenwidth - viewWidth)/2.0f;
    
    self.frame = CGRectMake(centerX, self.center.y,self.frame.size.width,0);

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.frame = CGRectMake(centerX, self.center.y+screenHeight, self.frame.size.width,0);
        
    } completion:^(BOOL finished) {
        
        self.frame = self.frame;
        if(completion)
        {
            completion(finished);
        }
    }];
}

- (void)slideOutForDuration:(CGFloat)duration
                     delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenwidth = screenRect.size.width;
    CGFloat viewWidth = self.frame.size.width;
    CGFloat centerX = (screenwidth - viewWidth)/2.0f;

    
    self.frame = self.frame;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.frame = CGRectMake(centerX, self.center.y+screenHeight, self.frame.size.width,0);
        
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(centerX, self.center.y,self.frame.size.width,0);
        if(completion)
        {
            completion(finished);
        }
    }];

}
@end
