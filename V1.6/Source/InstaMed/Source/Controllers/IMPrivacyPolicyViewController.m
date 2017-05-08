//
//  IMPrivacyPolicyViewController.m
//  InstaMed
//
//  Created by GPB on 23/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrivacyPolicyViewController.h"
#import "IMSettingsUtility.h"

@interface IMPrivacyPolicyViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *privacyPolicyWebView;

@end

@implementation IMPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Privacy_Policy";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showActivityIndicatorView];
    [self downloadFeed];
}

-(void)downloadFeed
{
    NSURL *url = [NSURL URLWithString:[IMSettingsUtility privacyUrl]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.privacyPolicyWebView loadRequest:urlRequest];
}

#pragma mark - Web view delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hideActivityIndicatorView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self hideActivityIndicatorView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideActivityIndicatorView];
    [self handleError:error withRetryStatus:YES];
}
@end
