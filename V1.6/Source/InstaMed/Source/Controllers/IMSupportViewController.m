//
//  IMSupportViewController.m
//  InstaMed
//
//  Created by Arjuna on 21/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSupportViewController.h"
#import "AFHTTPRequestOperation.h"
#import "IMLocationManager.h"
#import "IMAccountsManager.h"


#define LC_URL              "http://cdn.livechatinc.com/app/mobile/urls.json"
//production
#define LC_LICENSE          "6451451"
//test
//#define LC_LICENSE          "6699861"

#define LC_CHAT_GROUP       "0"
#define CHAT_APPEND_URL @"&email=%@&name=%@&params=%@"

@interface IMSupportViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIWebView *chatWebViewController;
@property (nonatomic, strong) NSString *chatURL;
@property (nonatomic, strong) NSString *oldChatURL;
@property (nonatomic, strong) NSString *userPhoneNumber;
@property (strong, nonatomic) NSNumber *contactNumber;
@property (nonatomic) BOOL chatWebViewLoaded;
@property (nonatomic,strong) IMUser* user;


- (IBAction)callButtonPressed:(id)sender;

@end

@implementation IMSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *vcArray = [self.navigationController viewControllers];
    
    if (vcArray.count > 1) {
        /*During login flow this view controller is second one in VC stack
         so we are modifying VC stack so that this VC is root view controller.
         */
        NSArray *newVCArray = [NSArray arrayWithObject:vcArray.lastObject];
        self.navigationController.viewControllers = newVCArray;
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.leftBarButtonItem = nil;
    }
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] fetchUserWithCompletion:^(IMUser *user, NSError *error) {
        if(!error)
        {
            [IMAccountsManager sharedManager].currentLoggedInUser = user;
            [self requestUrl];
        }
        else
        {
            [self hideActivityIndicatorView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMSupportScreenVisited withParameters:@{}];
    if(!self.chatWebViewLoaded)
    {
      [self startChat];
    }
    if([IMAccountsManager sharedManager].needToReload)
    {
        [self removeCookies];
        [self requestUrl];
    }
    
    [self downloadFeed];

}

- (void)loadUI
{
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
                                 
    self.navigationItem.rightBarButtonItem = refreshItem;
    refreshItem.tintColor = [UIColor blackColor];
    self.callButton .hidden = YES;

    [IMFunctionUtilities setBackgroundImage:self.callButton withImageColor:APP_THEME_COLOR];
    [self setUpNavigationBar];
}

- (void)refresh
{
    [self startChat];
}

-(void)downloadFeed
{
    [[IMLocationManager sharedManager] fetchCityDetailsWithCompletion:^(IMCity *currentCity, NSError *error) {
        self.callButton.hidden = NO;
        if(!error)
        {
            self.contactNumber = currentCity.contactNumber;
        }
        else
        {
            [self handleError:error withRetryStatus:YES];
        }

    }];
}

- (void)removeCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if(self.chatURL)
    {
        NSArray* cookiesWeLike = [cookieJar cookiesForURL:[NSURL URLWithString:self.chatURL]];
        for (NSHTTPCookie* cookie in cookiesWeLike)
        {
            [cookieJar deleteCookie:cookie];
        }
    }
}


- (NSString*)encodedString:(NSString*)str
{
    NSString *encodedStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                 kCFAllocatorDefault,
                                                                                                 (CFStringRef)str,
                                                                                                 NULL, // characters to leave unescaped
                                                                                                 (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                                 kCFStringEncodingUTF8));
    return encodedStr;
}

#pragma mark -
#pragma mark Tasks

- (void)requestUrl
{
    
    NSURL *url = [NSURL URLWithString:@LC_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *reqOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [reqOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *e = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: responseObject options: NSJSONReadingMutableContainers error: &e];
        if([JSON isKindOfClass:[NSDictionary class]])
        {
            self.chatURL = [self prepareUrl:JSON[@"chat_url"]];
            [self startChat];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
    [reqOperation start];
}

#pragma mark -
#pragma mark Helper functions

- (NSString *)prepareUrl:(NSString *)url
{    
    NSString *email =  [IMAccountsManager sharedManager].currentLoggedInUser.emailAddress;
    NSString *name =  [IMAccountsManager sharedManager].currentLoggedInUser.name;
    if(email == nil)
    {
        email = @"";
    }
    NSString *encodedEmail = [self encodedString:email];
    NSString *encodedName = [self encodedString:name];
    
    NSString *paraString = [NSString stringWithFormat:@"phone=%@&=",[IMAccountsManager sharedManager].currentLoggedInUser.mobileNumber ];
    NSString *encodedPara = [self encodedString:paraString];
    
    NSString *appendUrlStr = [NSString stringWithFormat:CHAT_APPEND_URL,encodedEmail,encodedName,encodedPara];
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"http://%@%@", url,appendUrlStr];
    
    [string replaceOccurrencesOfString:@"{%license%}"
                            withString:@LC_LICENSE
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    [string replaceOccurrencesOfString:@"{%group%}"
                            withString:@LC_CHAT_GROUP
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    
    return string;
}

#pragma mark -
#pragma mark Actions

- (void)startChat
{
    NSURL *url = [NSURL URLWithString:self.chatURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.chatWebViewController loadRequest:request];
}


- (IBAction)callButtonPressed:(id)sender
{
    [IMFlurry logEvent:IMSupportCall withParameters:@{}];

    NSString *phNo = [NSString stringWithFormat:@"%@",self.contactNumber];
    if(phNo != nil)
    {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
        {
            static UIWebView *webView = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                webView = [UIWebView new];
            });
            [webView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];

        }
        else
        {
            [self showAlertWithTitle:@"" andMessage:@"Call facility is not available!!!"];
            
        }
    }
    else
    {
        [self showAlertWithTitle:@"Alert" andMessage:IMCallNotAvailableForCity];
    }
  
}

#pragma mark - Web view delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"req url %@",request.URL.absoluteString);
    if([request.URL.absoluteString hasPrefix:@"http://secure.livechatinc.com/licence"] || [request.URL.absoluteString hasPrefix:@"https://api.livechatinc.com/v2/tickets/new?post_message=true"] )
    {
        return YES;
    }
    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [self hideActivityIndicatorView];
    self.chatWebViewLoaded = YES;
    [IMAccountsManager sharedManager].needToReload = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView, didFailLoadWithError %@",error);
    [self hideActivityIndicatorView];
    self.chatWebViewLoaded = NO;
}

@end
