//
//  IMPrescriptionPendingViewController.m
//  InstaMed
//
//  Created by Suhail K on 24/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescriptionPendingViewController.h"
#import "IMPrescriptionPendingTableViewCell.h"
#import "IMDeliveryAddressViewController.h"
#import "IMUploadPrescriptionViewController.h"

@interface IMPrescriptionPendingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadPrescriptionButton;
- (IBAction)uploadPrescriptionPressed:(UIButton *)sender;
- (IBAction)callHelpCenterPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *callHelpCenterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IMPrescriptionPendingTableViewCell *prototypeCell;

@end

@implementation IMPrescriptionPendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)loadUI
{
    [self setUpNavigationBar];

    SET_CELL_CORER(self.uploadPrescriptionButton, 5.0);
    SET_FOR_YOU_CELL_BORDER(self.callHelpCenterButton, APP_THEME_COLOR,8.0);
    [IMFunctionUtilities setBackgroundImage:self.uploadPrescriptionButton withImageColor:APP_THEME_COLOR];
    [self updateUI];
}

- (void)updateUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - TableView Datasource and delegate Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.modelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMPrescriptionPendingTableViewCell* pendingCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMPendingCellIdentifier" forIndexPath:indexPath];
    IMLineItem *model = [self.modelArray objectAtIndex:indexPath.row];
    pendingCell.model = model;
    return pendingCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMLineItem *model = [self.modelArray objectAtIndex:indexPath.row];
    self.prototypeCell.model = model;
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)uploadDone:(NSNotification *)notification
{
//    [self.navigationController popToViewController:self animated:NO];
//    [self performSegueWithIdentifier:@"IMUploadCompleteSegue" sender:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"IMUploadCompleteSegue"])
    {
        IMDeliveryAddressViewController* deliveryAddressController = segue.destinationViewController;
        deliveryAddressController.cart = self.cart;
        deliveryAddressController.order = self.order;
    }
}


- (IBAction)uploadPrescriptionPressed:(UIButton *)sender {
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"PrescriptionUpload" bundle:nil];
    
    IMUploadPrescriptionViewController* prescriptionVC = [storyboard instantiateInitialViewController];
    prescriptionVC.prescriptionType = IMFromOrder;
    prescriptionVC.cart = self.cart;
    [self.navigationController pushViewController:prescriptionVC animated:YES];
}

- (IBAction)callHelpCenterPressed:(id)sender {
    NSString *phNo = @"033-66666666";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:@"Call facility is not available!!!"];
        
    }

}

- (IMPrescriptionPendingTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMPendingCellIdentifier"];
    }
    return _prototypeCell;
}
@end
