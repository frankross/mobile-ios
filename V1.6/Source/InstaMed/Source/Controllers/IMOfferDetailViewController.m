//
//  IMOfferDetailViewController.m
//  InstaMed
//
//  Created by Suhail K on 12/01/16.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOfferDetailViewController.h"
#import "UITextField+IMSearchBar.h"

@interface IMOfferDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *OfferWebView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@end

@implementation IMOfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Promotion_Detail";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

-(void)loadUI
{
    [self setUpNavigationBar];
    [self addCartButton];
    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
    [self.searchField configureAsSearchBar];
    [self downloadFeed];
   
}

-(void)downloadFeed
{
    NSURL *url = [NSURL URLWithString:self.htmlURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self showActivityIndicatorView];
    [self.OfferWebView loadRequest:urlRequest];
}
#pragma mark - Web view delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [self showActivityIndicatorView];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [self hideActivityIndicatorView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView, didFailLoadWithError %@",error);
    [self hideActivityIndicatorView];
    [self handleError:error withRetryStatus:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"SearchBarSegue"])
    {
        NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.screenName, @"Screen_Name",
                                nil];
        [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
    }
}


@end
