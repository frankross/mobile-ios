//
//  IMErrorViewController.m
//  InstaMed
//
//  Created by Suhail K on 27/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMErrorViewController.h"

@interface IMErrorViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *retryPanelView;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
- (IBAction)retryPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *retryMessageLabel;

@end

@implementation IMErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.retryMessageLabel.attributedText = [self attributedStringForString:IMNoNetworkErrorMessage];
    [IMFunctionUtilities setBackgroundImage:self.retryButton withImageColor:APP_THEME_COLOR];
    SET_CELL_CORER(self.retryButton, 8.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSMutableAttributedString *)attributedStringForString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
    
}

- (IBAction)retryPressed:(id)sender {
    if([self.delegate respondsToSelector:@selector(retryButtonPressed)])
    {
        [self.delegate retryButtonPressed];
    }
    
}

- (void)showActivityIndicator
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.retryPanelView.hidden = YES;
    
}
- (void)hideActivityIndicator
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)showErrorPanelWithMessage:(NSString *)message showRetryButton:(BOOL)showRetryButton
{
    self.retryPanelView.hidden = !showRetryButton;
    [self hideActivityIndicator];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    self.retryMessageLabel.attributedText = attributedString;
    
}

- (void)hideErrorPanel
{
    self.retryPanelView.hidden = YES;

}

@end
