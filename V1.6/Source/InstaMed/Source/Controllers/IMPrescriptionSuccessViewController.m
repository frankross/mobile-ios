//
//  IMPrescriptionSuccessViewController.m
//  InstaMed
//
//  Created by Suhail K on 16/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionSuccessViewController.h"
#import "IMAccountsManager.h"
#import "IMCart.h"

@interface IMPrescriptionSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)uploadAnotherPressed:(UIButton *)sender;
- (IBAction)donePressed:(UIButton *)sender;

@end

@implementation IMPrescriptionSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUI
{
//    [super loadUI];
    [self addBackButton];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    SET_CELL_CORER(self.doneButton, 10.0);
    [IMFunctionUtilities setBackgroundImage:self.doneButton withImageColor:APP_THEME_COLOR];
    self.imageView.image = self.selectedImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 @brief To handle uploadAnother button action
 @returns void
 */
- (IBAction)uploadAnotherPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMPrescriptionAddAnother withParameters:@{}];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}

/**
 @brief To handle done button action in revised order flow
 @returns void
 */
- (void)donePressedForOrderRevise
{
    [self showActivityIndicatorView];
    [[IMAccountsManager sharedManager] completePrescriptionUploadForOrderReviseWithCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
        if(!error)
        {
        }
    }];
}

/**
 @brief To handle done button action 
 @returns void
 */
- (IBAction)donePressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMPrescriptionDone withParameters:@{}];

    // order revise flow
    if (self.cart != nil && !self.cart.isNewOrder) {
        [self donePressedForOrderRevise];
    }
    else{
        [self showActivityIndicatorView];
        [[IMAccountsManager sharedManager] completePrescriptionUploadWithCompletion:^(NSError *error) {
            [self hideActivityIndicatorView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
            if(!error)
            {
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"IMUploadDone" object:nil];
            }
        }];
    }
}
@end
