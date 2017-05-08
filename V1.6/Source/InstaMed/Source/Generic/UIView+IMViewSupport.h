//
//  NSString+IMViewSupport.h
//  InstaMed
//
//  Created by Arjuna on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

extern const CGFloat RTNoAnimDelay ;
extern const CGFloat RTQuickAnimDuration ;
 extern const CGFloat RTFastAnimDuration;
extern const CGFloat RTAvgAnimDuration;
extern const CGFloat RTSlowAnimDuration ;


@interface UIView (IMViewSupport)

- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha duration:(CGFloat)duration;
- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha;
- (void)fadeFromAplha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha duration:(CGFloat)duration
                delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion;
- (void)slideInForDuration:(CGFloat)duration
                     delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion;
- (void)slideOutForDuration:(CGFloat)duration
                      delay:(CGFloat)delay option:(UIViewAnimationOptions)option completion:(void (^)(BOOL finished))completion;

@end
