//
//  IMFrankRossWalletViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 30/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFrankRossWalletViewController.h"
#import "IMRewardPointTableSectionHeader.h"
#import "IMServerManager.h"
#import "IMApptentiveManager.h"
#import "NSString+IMStringSupport.h"
#import "IMRewardPointTransaction.h"
#import "IMRewardPointTransactionTableViewCell.h"

@interface IMFrankRossWalletViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *rewardPointTableView;
@property (weak, nonatomic) IBOutlet UILabel *earnedAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *spendAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *amountLabelsContainerView;
@property (weak, nonatomic) IBOutlet UIView *rewardPointShareView;
@property (nonatomic, strong) UILabel *noContentLabel;
@property (nonatomic, strong) NSString *earnedAmount;
@property (nonatomic, strong) NSString *spendAmount;
@property (nonatomic, strong) NSString *availableAmount;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *transactionsArray;
@property (nonatomic, strong) IMRewardPointTransactionTableViewCell *prototypeCell;



@end

@implementation IMFrankRossWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *headerViewNib = [UINib nibWithNibName:@"RewardPointTableViewSectionHeader" bundle:nil];
    [self.rewardPointTableView registerNib:headerViewNib forHeaderFooterViewReuseIdentifier:@"rewardPointHeaderView"];
    self.rewardPointTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.amountLabelsContainerView.hidden = YES;
}


/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [self setUpNavigationBar];
    self.rewardPointTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.rewardPointTableView.scrollIndicatorInsets = UIEdgeInsetsMake(60,0, 0, 0);
    [self downloadFeed];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMFRwalletScreenVisited withParameters:@{}];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMApptentiveManager sharedManager] logFrankrossWalletScreenVisitedEventFromViewController:self];
}


/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
     __weak typeof(self) weakSelf = self;
    [self showActivityIndicatorView];
    [[IMServerManager sharedManager] getHealthWalletDetailsWithCompletion:^(NSNumber *earnedAmount, NSNumber *spendAmount, NSNumber *availableAmount, NSArray *transactions, NSString *message, NSError *error)
     {
         
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideActivityIndicatorView];
                if(!message)
                {
                    [weakSelf setNoContentTitle:@""];
                    weakSelf.earnedAmount = [NSString stringWithFormat:@"%.02f", earnedAmount.floatValue];//[earnedAmount description];
                    weakSelf.spendAmount = [NSString stringWithFormat:@"%.02f", spendAmount.floatValue];
                    weakSelf.availableAmount = [NSString stringWithFormat:@"%.02f", availableAmount.floatValue];
                    NSMutableArray *transactionsArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *transactionDict in transactions) {
                        IMRewardPointTransaction *transaction = [[IMRewardPointTransaction alloc] initWithDictionary:transactionDict];
                        [transactionsArray addObject:transaction];
                    }
                    self.transactionsArray = [NSArray arrayWithArray:transactionsArray];
                    [weakSelf updateUI];
                }
                else
                {
                    [weakSelf setNoContentTitle:message];
                }
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideActivityIndicatorView];
                [weakSelf handleError:error withRetryStatus:YES];
            });
            
        }
    }];
}

/**
 @brief To update ui after feed
 @returns void
 */
-(void)updateUI
{
    self.amountLabelsContainerView.hidden = NO;
    self.earnedAmountLabel.text = [self.earnedAmount rupeeSymbolPrefixedString];
     self.spendAmountLabel.text = [self.spendAmount rupeeSymbolPrefixedString];
     self.availableAmountLabel.text = [self.availableAmount rupeeSymbolPrefixedString];
    [self.rewardPointTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.transactionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     IMRewardPointTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rewardPointTransactionCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(IMRewardPointTransactionTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IMRewardPointTransaction *transaction = self.transactionsArray[indexPath.row];
    cell.transactionModel = transaction;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IMRewardPointTableSectionHeader *headerView = [self.rewardPointTableView dequeueReusableHeaderFooterViewWithIdentifier:@"rewardPointHeaderView"];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.transactionsArray.count)
    {
        return 60;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!self.prototypeCell)
    {
        self.prototypeCell = [tableView dequeueReusableCellWithIdentifier:@"rewardPointTransactionCell"];
    }
    
    
    IMRewardPointTransaction *transaction = self.transactionsArray[indexPath.row];
    self.prototypeCell.transactionModel = transaction;
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self.prototypeCell setNeedsUpdateConstraints];
    [self.prototypeCell updateConstraints];
    
    [self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];
    
    
    
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    NSLog(@"%lf",height);
    
    return height + 1;// 1 for separator;
}


/**
 @brief Finction to show no content label
 @returns void
 */
- (void)setNoContentTitle:(NSString *)title
{
    if([title isEqualToString:@""])
    {
        self.noContentLabel.hidden = YES;
        self.rewardPointTableView.hidden = NO;
        self.amountLabelsContainerView.hidden = NO;
        self.rewardPointShareView.hidden = NO;
    }
    else
    {
        self.noContentLabel.center = CGPointMake(self.view.bounds.size.width/2,  self.view.bounds.size.height/2);
        self.noContentLabel.hidden = NO;
        self.noContentLabel.text = title;
        self.rewardPointTableView.hidden = YES;
        self.amountLabelsContainerView.hidden = YES;
        self.rewardPointShareView.hidden = YES;
    }
}


@end
