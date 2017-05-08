//
//  IMOrderListViewController.m
//  InstaMed
//
//  Created by Arjuna on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMOrderListViewController.h"
#import "IMOrder.h"
#import "IMOrderTableViewCell.h"
#import "IMOrderDetailViewController.h"
#import "IMAccountsManager.h"
#import "IMCartManager.h"
#import "IMCartViewController.h"
#import "IMCartUtility.h"

#import "PaymentsSDK.h"

const CGFloat IMSectionHeaderHeightIphone = 75;

@interface IMOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (nonatomic, strong) IMOrderTableViewCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalOrders;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger perPageCount;


@end

@implementation IMOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)loadUI
{
    [self setUpNavigationBar];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [IMFlurry logEvent:IMOrderHistoryScreenVisited withParameters:@{}];
    self.ordersTableView.hidden = YES;
    if (self.isDeepLinkingPush)
    {
        [self performSegueWithIdentifier:@"IMOrderDetailSegue" sender:nil];
        self.isDeepLinkingPush = NO;
    }
    else
    {
        self.modelArray = [NSMutableArray array];
        [self.ordersTableView reloadData];
        self.currentPage = 1;
        self.perPageCount = 20;
        [self downloadFeed];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

-(void)downloadFeed
{
    
    [self showActivityIndicatorView];
    
    [[IMAccountsManager sharedManager] fetchOrdersForPage:self.currentPage withProductsPerPage:self.perPageCount withCompletion:^(NSArray *orders, NSInteger totalPageCount, NSInteger totalOrderCount, NSError *error)
    {
        [self hideActivityIndicatorView];
        if(!error)
        {
            self.totalPages = totalPageCount;
            self.totalOrders = totalOrderCount;
            [self.modelArray addObjectsFromArray:orders];
            self.currentPage++;
            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:NO];
            
        }

    }];
}

-(void)updateUI
{
    //[self setUpDataSource];
    self.ordersTableView.hidden = NO;

    if(self.modelArray.count == 0)
    {
        [self setNoContentTitle:@"No order found"];
        self.topView.hidden = YES;
    }
    else
    {
        [self setNoContentTitle:@""];
        self.topView.hidden = NO;
    }
    self.ordersTableView.dataSource = self;
    self.ordersTableView.delegate = self;
    [self.ordersTableView reloadData];
}


#pragma mark - Table View Datasource and Delegate Methods - 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.model = self.modelArray[indexPath.row];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOrderTableViewCell* cell = [self.ordersTableView dequeueReusableCellWithIdentifier:@"IMOrderCell" forIndexPath:indexPath];
    
    cell.model = self.modelArray[indexPath.row];
    cell.reorderButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

   
    if(indexPath.row == self.modelArray.count-1 && self.currentPage <= self.totalPages)
    {
        [self downloadFeed];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [IMFlurry logEvent:IMOrderTapped withParameters:@{}];
}

- (void)updateOrderPressed:(UIButton*)sender
{
    IMOrder* order = self.modelArray[sender.tag];
    order.isCompleteDetailPresent = NO;
    IMCart *cart = [IMCartUtility getCartFromOrder:order  forType:IMUpdateOrder];
    [self loadCartFor:cart order:order];
}

- (IBAction)reorderPressed:(UIButton*)sender
{
    [IMFlurry logEvent:IMReorderfromListEvent withParameters:@{}];
    
    IMOrder* order = self.modelArray[sender.tag];
    if(order.doctorName && ![order.doctorName isEqualToString:@""])
    {
        [IMCartManager sharedManager].doctorName = order.doctorName;
        
    }
    if(order.patientName && ![order.patientName isEqualToString:@""])
    {
        [IMCartManager sharedManager].patientName = order.patientName;
        
    }
    //  order revise
    if (order.isMismatched) {
        [self updateOrderPressed:sender];
    }
    else{
        [self showActivityIndicatorView];
        
        [[IMCartManager sharedManager] reorderFromOrder:order withCompletion:^(NSError *error) {
            [self hideActivityIndicatorView];
            if(error)
            {
                if(error.userInfo[IMMessage])
                {
                    [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
                }
                else
                {
                    [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
                }
            }
            else
            {
                [self loadCart:self];
            }
        }];
    }
}

-(void)showActivityIndicatorView
{
    if(self.activityIndicator == nil)
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.center = self.view.center;
        [self.activityIndicator hidesWhenStopped];
        self.activityIndicator.color = APP_THEME_COLOR;
    }
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
}

-(void)hideActivityIndicatorView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [self.activityIndicator removeFromSuperview];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"IMOrderDetailSegue"])
    {
        ((IMOrderDetailViewController*)segue.destinationViewController).orderId = ((IMOrderTableViewCell*)sender).model.identifier;
        if(self.isDeepLinkingPush)
        {
            ((IMOrderDetailViewController*)segue.destinationViewController).orderId = self.identifier;
        }
    }
}

- (IMOrderTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.ordersTableView dequeueReusableCellWithIdentifier:@"IMOrderCell"];
    }
    return _prototypeCell;
}




//to fix the crash when user taps ok in paytm SDK's cancellation dialog
#pragma mark PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response
{
    
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    

    
}


- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    

}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{

}

@end
