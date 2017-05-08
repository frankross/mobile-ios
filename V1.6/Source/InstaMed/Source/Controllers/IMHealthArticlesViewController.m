//
//  IMHealthArticlesViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 13/09/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.

static NSString *const IMHealthArticlesHTMlURL = @"http://blog.frankross.in?dv=1";

#import "IMHealthArticlesViewController.h"

#import "UITextField+IMSearchBar.h"


@interface IMHealthArticlesViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *healthArticlesWebView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@end

@implementation IMHealthArticlesViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Health Articles";
    self.searchContainerView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCartButton];
}


/**
 @brief To setup initial ui elements
 @returns void
 */
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
    
    // if visiting this screen using push notification or from clicking health article URL
    if(self.isDeepLinkingPush)
    {
        NSURL *url = [NSURL URLWithString:self.webPageUrl];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self showActivityIndicatorView];
        [self.healthArticlesWebView loadRequest:urlRequest];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:IMHealthArticlesHTMlURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self showActivityIndicatorView];
        [self.healthArticlesWebView loadRequest:urlRequest];
    }
}


#pragma mark - Web view delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityIndicatorView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    [self hideActivityIndicatorView];
    self.searchContainerView.hidden = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideActivityIndicatorView];
    self.searchContainerView.hidden = NO;
    [self handleError:error withRetryStatus:YES];
}


#pragma mark - IBActions

/**
 @brief To move to search controller
 @returns void
 */
- (IBAction)tappedSearchBar:(UITapGestureRecognizer *)sender
{
    
    NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.screenName, @"Screen_Name",
                            nil];
    [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
    
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:IMMainSBName bundle:nil];
    UIViewController* searchVc = [storyboard instantiateViewControllerWithIdentifier:IMSearchViewControllerID];
    [self.navigationController pushViewController:searchVc animated:YES];
}


@end
