//
//  IMAlreadyRegisteredViewController.m
//  InstaMed
//
//  Created by Sahana Kini on 17/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAlreadyRegisteredViewController.h"

@interface IMAlreadyRegisteredViewController ()
@property (weak, nonatomic) IBOutlet UIButton *proceedToSignInButton;

@end

@implementation IMAlreadyRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.proceedToSignInButton.backgroundColor = APP_THEME_COLOR;
     SET_FOR_YOU_CELL_BORDER(self.proceedToSignInButton,APP_THEME_COLOR, 2.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proceedToSignInButtonTapped:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)loadUI
{
    [super setUpNavigationBar];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
