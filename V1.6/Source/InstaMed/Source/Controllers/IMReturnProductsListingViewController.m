//
//  IMReturnProductsListingViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 29/07/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMReturnProductsListingViewController.h"
#import "IMFAQViewController.h"

@interface IMReturnProductsListingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *returnProductsTableView;

@end

@implementation IMReturnProductsListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Return products";
    self.returnProductsTableView.tableFooterView = [UIView new];
//    self.returnProductsTableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length,
//                                                                                       0.0,
//                                                                                       -self.bottomLayoutGuide.length,
//                                                                                       0.0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadUI
{
    [self setUpNavigationBar];
    
    
    
}


-(void)setUpNavigationBar
{
    [super setUpNavigationBar];
    UIBarButtonItem *returnPolicyButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Return policy"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(gotoReturnPolicyScreen)];
    self.navigationItem.rightBarButtonItem = returnPolicyButton;
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row % 2 == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"returnProductInactiveCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"returnProductActiveCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - IBAction

- (IBAction)clickedProceedButton:(UIButton *)sender
{
    
}


#pragma mark - Private functions

-(void) gotoReturnPolicyScreen
{
    UIStoryboard *moreStoryboard = [UIStoryboard storyboardWithName:@"Support&More" bundle:nil];
    if(moreStoryboard)
    {
        IMFAQViewController *FAQViewController = [moreStoryboard instantiateViewControllerWithIdentifier:@"FAQDetailScene"];
        FAQViewController.identifier = @3;
        FAQViewController.title = @"Return policy";
        [self.navigationController pushViewController:FAQViewController animated:YES];
    }
}


@end
