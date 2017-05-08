//
//  IMBaseViewController.m
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"
#import "IMDefines.h"
#import "IMBadgeButton.h"
#import "IMCartManager.h"
#import "IMErrorViewController.h"
#import "IMCartViewController.h"
#import "IMConstants.h"

@interface IMBaseViewController ()<IMErrorViewControllerDelegate>

@property (nonatomic, strong) IMBadgeButton *cartButton;
@property (nonatomic, strong) UILabel *noContentLabel;
@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong,nonatomic) IMErrorViewController* errorVC;

@end

@implementation IMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self != self.navigationController.viewControllers[0])
    {
        [self addBackButton];
    }
  
    [self addNoContentLabel];
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)downloadFeed
{
    // Need to be implemented by subclasses as needed
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCartButton];
}

/**
 @brief To setup navigation bar color and theme
 @returns void
 */
-(void)setUpNavigationBar
{
    [self.navigationController.navigationBar setBarTintColor:APP_THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]};
}


- (void)loadUI
{
    [self setUpNavigationBar];
    [self addCartButton];
    [self addSearchButton];
}

- (void)updateUI
{

}

/**
 @brief To Add cart button to the navigation bar when needed.
 @returns void
 */
- (void)addCartButton
{
    self.cartButton = [[IMBadgeButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40) withBadgeString:@"0" badgeInsets:UIEdgeInsetsMake(22, -2, 0, 18)];
    [self.cartButton setImage:[UIImage imageNamed:@"CartIcon.png"] forState:UIControlStateNormal];
    
   [self.cartButton addTarget:self action:@selector(loadCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
    
    self.navigationItem.rightBarButtonItem = cartButtonItem;
}

/**
 @brief To update cart badge count
 @returns void
 */
-(void)updateCartButton
{
    NSLog(@"count %@",[NSString stringWithFormat:@"%lu",(unsigned long)[IMCartManager sharedManager].currentCart.lineItems.count]);
    [self.cartButton setBadgeString:[NSString stringWithFormat:@"%lu",(unsigned long)[IMCartManager sharedManager].currentCart.lineItems.count]];
}

/**
 @brief To animate badge count.
 @returns void
 */
- (void)animateBadgeIcon
{
    [self.cartButton animateBadge];
}

/**
 @brief To add search button to navigation bar when needed.
 @returns void
 */
- (void)addSearchButton
{
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -2, 30, 30)];
    
    [searchButton setImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(loadSearch)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc]
                               initWithCustomView:searchButton];
    
     UIBarButtonItem *cartButtonItem  = self.navigationItem.rightBarButtonItem;
    NSArray *buttons;
    if(cartButtonItem == nil)
    {
       buttons = [[NSArray alloc] initWithObjects:searchButtonItem, nil];
    }
    else
    {
       buttons = [[NSArray alloc] initWithObjects:cartButtonItem,searchButtonItem, nil];

    }
    self.navigationItem.rightBarButtonItems = buttons;
}

/**
 @brief To load the search screen
 @returns void
 */
- (void)loadSearch
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* searchVc = [storyboard instantiateViewControllerWithIdentifier:IMSearchViewControllerID];
    [IMFlurry logEvent:IMSearchTapped withParameters:@{}];
    [self.navigationController pushViewController:searchVc animated:YES];
}

/**
 @brief To load the cart screen
 @returns void
 */
- (void)loadCart:(id)sender
{
    [self loadCartFor:nil order:nil];
}

- (void)loadCartFor:(IMCart*)cart order:(IMOrder*)order
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMCartSBName bundle:nil];
    
    [IMCartManager sharedManager].orderInitiatedViewController = self;
    
    IMCartViewController* cartVC = [storyboard instantiateInitialViewController];
    cartVC.cart = cart;
    cartVC.order = order;
    
    NSDictionary *cartParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.screenName, @"Screen_Name",
                                    nil];
    [IMFlurry logEvent:IMCartTapped withParameters:cartParams];
    
    [self.navigationController pushViewController:cartVC animated:YES];

}

/**
 @brief To display message (error,no item etc)
 @returns void
 */
- (void)setNoContentTitle:(NSString *)title
{
    if([title isEqualToString:@""])
    {
        self.noContentLabel.hidden = YES;
    }
    else
    {
        self.noContentLabel.center = CGPointMake(self.view.bounds.size.width/2,  self.view.bounds.size.height/2);
        self.noContentLabel.hidden = NO;
        self.noContentLabel.text = title;
    }
}

/**
 @brief To display message (error,no item etc)
 @returns void
 */
- (void) addNoContentLabel
{
//    CGFloat height = (IS_IPAD ? 150 : 75);
    self.noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width - 20, 75)];
    self.noContentLabel.textAlignment = NSTextAlignmentCenter;
    self.noContentLabel.textColor = [UIColor lightGrayColor];
    self.noContentLabel.font = [UIFont systemFontOfSize:20];
    self.noContentLabel.numberOfLines = 0;
    self.noContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noContentLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.noContentLabel];
    self.noContentLabel.hidden = YES;
}

/**
 @brief To Add back button to navigation bar
 @returns void
 */
- (void) addBackButton
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

/**
 @brief To display activity indicator screen
 @returns void
 */
-(void)showActivityIndicatorView
{
    if(!self.errorVC)
    {
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.errorVC = [storyboard instantiateViewControllerWithIdentifier:@"IMErrorViewController"];
        self.errorVC.delegate = self;
    }
    
    [self addChildViewController:self.errorVC];
    self.errorVC.view.alpha = 0.0f;
    [self.view addSubview:self.errorVC.view];
    [self.errorVC showActivityIndicator];
     [self.errorVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.errorVC.view.alpha = 1.0f;
    }];
}

/**
 @brief To remove activity indicator screen
 @returns void
 */
-(void)hideActivityIndicatorView
{//
   [self.activityIndicator removeFromSuperview];
    if(self.errorVC)
    {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.errorVC.view.alpha = 0.0f;
        }completion:^(BOOL finished) {
//            [self.errorVC willMoveToParentViewController:nil];
//            [self.errorVC.view removeFromSuperview];
//            [self.errorVC removeFromParentViewController];
//            self.errorVC = nil;

        }];
    }
    
//    [self.errorVC willMoveToParentViewController:nil];
//    [self.errorVC.view removeFromSuperview];
//    [self.errorVC removeFromParentViewController];
//    self.errorVC = nil;

}

/**
 @brief To display activity indicator screen in full screen mode
 @returns void
 */
-(void)showErrorPanelOnTabbarWithMessage:(NSString *)message
{
    if(!self.errorVC)
    {
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.errorVC = [storyboard instantiateViewControllerWithIdentifier:@"IMErrorViewController"];
        self.errorVC.delegate = self;
    }
    [self.tabBarController addChildViewController:self.errorVC];
    self.errorVC.view.alpha = 1.0f;
    [self.tabBarController.view addSubview:self.errorVC.view];
    [self.errorVC showActivityIndicator];
    [self.errorVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.errorVC.view.alpha = 1.0f;
    }];
    [self.errorVC showErrorPanelWithMessage:message showRetryButton:YES];
}

/**
 @brief To display error message screen
 @returns void
 */
- (void)showErrorPanelWithMessage:(NSString *)message showRetryButton:(BOOL)showRetryButton
{
//    if(!self.errorVC)
//    {
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.errorVC = [storyboard instantiateViewControllerWithIdentifier:@"IMErrorViewController"];
        self.errorVC.delegate = self;
        
//    }
    [self addChildViewController:self.errorVC];
    self.errorVC.view.alpha = 0.0f;
    [self.view addSubview:self.errorVC.view];
    [self.errorVC showActivityIndicator];
    [self.errorVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.errorVC.view.alpha = 1.0f;
    }];
    [self.errorVC showErrorPanelWithMessage:message showRetryButton:showRetryButton];
}

/**
 @brief To handle all API response errors
 @returns void
 */
- (void)handleError:(NSError *)error withRetryStatus:(BOOL)retry
{
    if(error.userInfo[IMMessage])
    {
        [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
        if(!retry)
        {
            [self showErrorPanelWithMessage:@"" showRetryButton:NO];
        }
    }
    else
    {
        if (error.code == kCFNetServiceErrorTimeout || error.code ==  kCFURLErrorNotConnectedToInternet || error.code == kCFURLErrorNetworkConnectionLost || error.code == -1016 || (error.code >= -1006  && error.code <= -1003) )
        {
            [self showErrorPanelWithMessage:IMNoNetworkErrorMessage showRetryButton:YES];
        }
        else
        {
            [self showErrorPanelWithMessage:@"Unknown error has occurred" showRetryButton:YES];
        }
    }
}




- (void)hideErrorPanel
{
    
}

-(void)retryButtonPressed
{
    [self downloadFeed];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Application Delegate methods -

- (void)willResignActive
{
    // Need to be implemented by subclasses as needed
}

- (void)didEnterBackground
{
    // Need to be implemented by subclasses as needed
}

- (void)willEnterForeground
{
}

- (void)didBecomeActive
{
    // Need to be implemented by subclasses as needed
}

- (void)screenWillApper
{
    // Need to be implemented by subclasses as needed
}

- (void)screenWillDisapper
{
    // Need to be implemented by subclasses as needed
}

#pragma mark - Others -

/**
 @brief To display alert with message
 @returns void
 */
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil, nil];
    [alert show];
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:title
//                                              message:message
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:IMOK
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           
//                                       }];
//
//        
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
}

/**
 @brief To formatting multilined text
 @returns NSMutableAttributedString
 */
- (NSMutableAttributedString *)attributedStringForString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
    
}

- (void)showNoNetworkAlert
{
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@""
//                                          message:IMNoNetworkErrorMessage
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:IMOK
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       
//                                   }];
//    
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:IMNoNetworkErrorMessage delegate:nil cancelButtonTitle:IMOK otherButtonTitles:nil];
    [alert show];
}
@end
