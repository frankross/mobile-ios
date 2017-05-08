//
//  IMEmergencyContactsViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 07/11/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMEmergencyContactsViewController.h"

#import "UITextField+IMSearchBar.h"

static NSString *const IMEmergencyContactsWebPageURL = @"https://s3-ap-southeast-1.amazonaws.com/emami-images-2/EmergencyServices/ambulance.html";

@interface IMEmergencyContactsViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *emergencyContactsWebView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@end

@implementation IMEmergencyContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Emergency";
    self.searchContainerView.hidden = YES;
    
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


/**
 @brief To load webview
 @returns void
 */
-(void)downloadFeed
{
    NSURL *url = [NSURL URLWithString:IMEmergencyContactsWebPageURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self showActivityIndicatorView];
    [self.emergencyContactsWebView loadRequest:urlRequest];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    
    //for tel scheme
    if([url.scheme isEqualToString:@"tel"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            static UIWebView *webView = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                webView = [UIWebView new];
            });
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            return NO;
        }

    }
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            return NO; // Let OS handle this url
        }
    }
    
    return YES;// allow to load http & https URLs
}

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
