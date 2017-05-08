//
//  IMBaseViewController.h
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Base class for entair view controllers.
//Including all basic activities like navigation handling,error handling etc.

#import <UIKit/UIKit.h>

@class IMCart;
@class IMOrder;

typedef NS_ENUM(NSUInteger ,IMRegistrationType)
{
    IMDirectRegistration,
    IMRegistrationUsingSocialChannel,
};

@interface IMBaseViewController : UIViewController

@property (strong, nonatomic)IMBaseModel *selectedModel;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) NSString *screenName;

- (void)downloadFeed;
- (void)loadUI;
- (void)updateUI;
- (void)willResignActive;
- (void)didEnterBackground;
- (void)willEnterForeground;
- (void)didBecomeActive;
- (void)screenWillApper;
- (void)screenWillDisapper;

-(void)setUpNavigationBar;
- (void)addCartButton;
- (void)updateCartButton;
- (void)addSearchButton;
- (void) addBackButton;
- (void)animateBadgeIcon;

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)setNoContentTitle:(NSString *)title;

-(void)showActivityIndicatorView;
-(void)hideActivityIndicatorView;

- (void)showErrorPanelWithMessage:(NSString *)message showRetryButton:(BOOL)showRetryButton;
-(void)showErrorPanelOnTabbarWithMessage:(NSString *)message;

- (void)hideErrorPanel;

- (NSMutableAttributedString *)attributedStringForString:(NSString *)string;

- (void)loadCart:(id)sender;

- (void)handleError:(NSError *)error withRetryStatus:(BOOL) retry;
- (void)loadCartFor:(IMCart*)cart order:(IMOrder*)order;
- (void)backPressed;
- (void)loadSearch;
- (void)showNoNetworkAlert;
@end
