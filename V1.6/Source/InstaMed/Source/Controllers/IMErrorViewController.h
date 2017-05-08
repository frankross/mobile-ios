//
//  IMErrorViewController.h
//  InstaMed
//
//  Created by Suhail K on 27/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing error displaying screen.

#import <UIKit/UIKit.h>

@protocol IMErrorViewControllerDelegate

- (void)retryButtonPressed;

@end

@interface IMErrorViewController : UIViewController

@property (nonatomic, weak) id delegate;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showErrorPanelWithMessage:(NSString *)message showRetryButton:(BOOL)showRetryButton;
- (void)hideErrorPanel;

@end
