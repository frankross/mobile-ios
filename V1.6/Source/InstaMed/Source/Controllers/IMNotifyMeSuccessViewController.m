//
//  IMNotifyMeSuccessViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 09/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNotifyMeSuccessViewController.h"

@interface IMNotifyMeSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;

@end

@implementation IMNotifyMeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView.layer.cornerRadius = 12.0f;
    self.OKButton.layer.cornerRadius = 2.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)OKButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)dismissScreen:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
