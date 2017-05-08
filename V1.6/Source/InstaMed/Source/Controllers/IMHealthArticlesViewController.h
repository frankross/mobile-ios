//
//  IMHealthArticlesViewController.h
//  InstaMed
//
//  Created by Yusuf Ansar on 13/09/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"

/**
 *  Class responsible for displaying health articles using webview
 */

@interface IMHealthArticlesViewController : IMBaseViewController

@property (nonatomic, assign) BOOL isDeepLinkingPush;
@property (nonatomic, strong) NSString *webPageUrl;

@end
