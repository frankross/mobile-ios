//
//  IMTabBarController.m
//  InstaMed
//
//  Created by GPB on 28/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMTabBarController.h"
#import "IMAccountsManager.h"
#import "IMLoginViewController.h"
#import "IMSupportViewController.h"



@interface IMTabBarController ()<UITabBarControllerDelegate>

@end

@implementation IMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITabBarControllerDelegate

/**
 @brief To handle the login view pushing
 @returns BOOL
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSUInteger indexOfTab = [self.viewControllers indexOfObject:viewController];
    if(indexOfTab == MYAccountTabIndex)
    {
        [IMFlurry logEvent:IMMyAccountTapped withParameters:@{}];
    }
    if(indexOfTab == SupportTabIndex)
    {
        if( [[IMAccountsManager sharedManager] userToken])
        {
            UINavigationController *navVC = self.viewControllers[SupportTabIndex];
            if([navVC.viewControllers[0] isKindOfClass:[IMLoginViewController class]])
            {
                NSMutableArray *vcArray = [self.viewControllers mutableCopy];
                
                UINavigationController *supportNVC = [[UINavigationController alloc]initWithRootViewController:[[UIStoryboard storyboardWithName:IMSupportSBName bundle:nil]instantiateViewControllerWithIdentifier:IMSupportVCID]];
                
                UIViewController *nVC3 = self.viewControllers[SupportTabIndex];
                UITabBarItem *tabItem3 = nVC3.tabBarItem;
                supportNVC.tabBarItem = tabItem3;
                [vcArray replaceObjectAtIndex:SupportTabIndex withObject:supportNVC];
                
                self.viewControllers = vcArray;
                [self setSelectedViewController:supportNVC];
                return NO;
            }
        }
        else
        {
            UINavigationController *navVC = self.viewControllers[SupportTabIndex];
            
            if([navVC.viewControllers[0] isKindOfClass:[IMSupportViewController class]])
            {
                NSMutableArray *vcArray = [self.viewControllers mutableCopy];
                
                IMLoginViewController *loginVC = [[UIStoryboard storyboardWithName:IMAccountSBName bundle:nil]instantiateViewControllerWithIdentifier:IMLoginVCID];
                UINavigationController *loginNVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
                loginVC.navigationController.navigationBar.tintColor = [UIColor blackColor];
                loginVC.loginCompletionBlock = ^(NSError* error ){
                    if(!error)
                    {
                        UINavigationController *navVC = self.viewControllers[SupportTabIndex];
                        IMSupportViewController *supportVC = [[UIStoryboard storyboardWithName:IMSupportSBName bundle:nil]instantiateViewControllerWithIdentifier:IMSupportVCID];
                        [navVC pushViewController:supportVC animated:YES];
                    }
                };
                
                UIViewController *nVC3 = self.viewControllers[SupportTabIndex];
                UITabBarItem *tabItem3 = nVC3.tabBarItem;
                loginNVC.tabBarItem = tabItem3;
                [vcArray replaceObjectAtIndex:SupportTabIndex withObject:loginNVC];
                
                self.viewControllers = vcArray;
                [self setSelectedViewController:loginNVC];
                return NO;
            }
        }
        
    }
    return YES;
}

//- (void)viewWillLayoutSubviews
//{
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 62;
//    tabFrame.origin.y = self.view.frame.size.height - 62;
//    self.tabBar.frame = tabFrame;
//}

@end
