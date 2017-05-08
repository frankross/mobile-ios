//
//  IMPrescriptionMedicinViewController.m
//  InstaMed
//
//  Created by Suhail K on 01/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionMedicinViewController.h"
#import "IMProductListViewController.h"
#import "IMLoginViewController.h"
#import "IMAccountsManager.h"
#import "UITextField+IMSearchBar.h"
#import "IMUploadPrescriptionViewController.h"

@interface IMPrescriptionMedicinViewController ()<IMProductListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *uploadPrescriptionButton;
@property (nonatomic, assign) BOOL isPrescriptionPresented;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@end

@implementation IMPrescriptionMedicinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Prescription_Medicine";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadDone:)
                                                 name:@"IMUploadDone"
                                               object:nil];
    
}

-(void)loadUI
{
    [self setUpNavigationBar];
    [self addCartButton];
    SET_CELL_CORER(self.uploadPrescriptionButton, 8.0);
    SET_CELL_CORER(self.searchButton, 8.0);
    [IMFunctionUtilities setBackgroundImage:self.searchBar withImageColor:APP_THEME_COLOR];
    [IMFunctionUtilities setBackgroundImage:self.uploadPrescriptionButton withImageColor:APP_THEME_COLOR];

    [self.searchField configureAsSearchBar];
    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
}

/**
 @brief prescription upload done callback
 @returns void
 */
- (void)uploadDone:(NSNotification *)notification
{
    if (self.isPrescriptionPresented) {
        self.isPrescriptionPresented = NO;
        [self.navigationController popToViewController:self animated:YES];
    }
    
}

/**
@brief  To handle upload prescription button action
@returns void
*/
- (IBAction)uploadPrescriptionPressed:(UIButton *)sender
{
    
    if( [[IMAccountsManager sharedManager] userToken])
    {
        self.isPrescriptionPresented = YES;
        UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
        
        IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
        prescriptionVC.prescriptionType = IMFromOthers;
        [self.navigationController pushViewController:prescriptionVC animated:YES];
    }
    else
    {
        UIStoryboard *storybord;
        storybord =[UIStoryboard storyboardWithName:@"Account" bundle:nil];
        IMLoginViewController *loginViewController = [storybord instantiateViewControllerWithIdentifier:IMLoginVCID];
        
        __weak IMPrescriptionMedicinViewController* weakSelf = self;
        loginViewController.loginCompletionBlock = ^(NSError* error ){
            if(!error)
            {
                weakSelf.isPrescriptionPresented = YES;
                UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
                [weakSelf.navigationController popViewControllerAnimated:NO];
                
                IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
                prescriptionVC.prescriptionType = IMFromOthers;
                [weakSelf.navigationController pushViewController:prescriptionVC animated:YES];
            }
        };
        if(loginViewController)
        {
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
    }

    }
#pragma mark - IMProductListViewControllerDelegate

-(void)didLoadTableViewWithTableViewHeight:(CGFloat)height andTotalProductCount:(NSInteger)totalProductCount andFacetInfo:(NSDictionary *)facetInfo
{
    self.containerViewHeightConstraint.constant = height;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"IMRecentlyOrderd"])
    {
        IMProductListViewController *productListVC = (IMProductListViewController *) segue.destinationViewController;
        productListVC.delegate = self;
        productListVC.productListType = IMRecentlyOrderedPharmacy;
    
    }
    else if([segue.identifier isEqualToString:@"IMSearchSegue"])
    {
        NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.screenName, @"Screen_Name",
                                nil];
        [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
    }
}

-(void)didUpdateCartButton
{
    [self updateCartButton];
    [self animateBadgeIcon];
}

@end
