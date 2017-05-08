//
//  IMDeliverySlotViewController.m
//  InstaMed
//
//  Created by Arjuna on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMDeliverySlotViewController.h"
#import "IMDeliverySlotTableViewCell.h"
#import "IMCartManager.h"
#import "IMCartUtility.h"


@interface IMDeliverySlotViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deliverySlotsTableView;

@property (strong,nonatomic) NSMutableDictionary* dataDictionary;
@property(strong,nonatomic) NSArray* sortedDatesArray;

@end



@implementation IMDeliverySlotViewController

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
    [IMFlurry logEvent:IMDeliverySlotScreenVisit withParameters:@{}];
}

-(void)loadUI
{
    [super setUpNavigationBar];
    self.deliverySlotsTableView.hidden = YES;

    [self downloadFeed];
}

-(void)downloadFeed
{
    [self showActivityIndicatorView];
    [[IMCartManager sharedManager] fetchDeliverySlotsForAreaId:self.deliveryAreaId withFullfillmentCenterID:self.fullfillmentCenterID withPrescription:self.cart.isPrescriptionPresent withCompletion:^(NSMutableArray *deliverySlots, NSError *error)
    {
        [self hideActivityIndicatorView];
        
        self.dataDictionary = [NSMutableDictionary dictionary];
        if(!error)
        {
            if(deliverySlots.count)
            {
                for (IMDeliverySlot* deliverySlot in deliverySlots)
                {
                    if(!self.dataDictionary[deliverySlot.slotDate])
                    {
                        self.dataDictionary[deliverySlot.slotDate] = [NSMutableArray array];
                    }
                    
                    [self.dataDictionary[deliverySlot.slotDate] addObject:deliverySlot];
                }
                self.sortedDatesArray = [[self.dataDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj2, id obj1) {
                    return [obj2 compare:obj1];
                }];
                
                [self updateUI];
            }
            else
            {
                self.deliverySlotsTableView.hidden = YES;
                [self setNoContentTitle:IMNoDeliverySlotsAvailable];
            }
        }
        else
        {
            if(error.userInfo[IMMessage])
            {
                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
            }
            else
            {
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
            }
        }
       
    }];
}


-(void)updateUI
{
    self.deliverySlotsTableView.hidden = NO;

    self.deliverySlotsTableView.dataSource =  self;
    self.deliverySlotsTableView.delegate = self;
    [self.deliverySlotsTableView reloadData];
    
}

#pragma mark - TableView Datasource and Delegate Methods -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDictionary.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDictionary[self.sortedDatesArray[section]] count];//((IMDeliverySlot*)self.modelArray[section])..count;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMDeliverySlotTableViewCell* deliverySlotCell = (IMDeliverySlotTableViewCell*)[self.deliverySlotsTableView dequeueReusableCellWithIdentifier:@"IMDeliverySlotCell" forIndexPath:indexPath];
    
    deliverySlotCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IMDeliverySlot* selectedSlot = (IMDeliverySlot*)self.selectedModel;
    
    NSDate* deliveryDate = self.sortedDatesArray[indexPath.section];
    
    IMDeliverySlot* deliverySlot = (IMDeliverySlot*)self.dataDictionary[deliveryDate][indexPath.row];
    
    deliverySlotCell.slotTitleLable.text =   deliverySlot.slotDescription;
    
    if([selectedSlot.identifier isEqual:deliverySlot.identifier])
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
   return deliverySlotCell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 63.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = PRODUCT_LIST_HEADER_HEIGHT;
    
    CGRect frame = CGRectMake(0,0, screenWidth , height);
    CGRect Lframe = CGRectMake(15,25, screenWidth , 30);

    UIView *headerView = [[UIView alloc] initWithFrame:frame];
//    headerView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:Lframe];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    NSDate* deliveryDate = self.sortedDatesArray[section];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE, dd MMM yyyy";
    titleLabel.text =  [dateFormatter stringFromDate:deliveryDate];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    CGFloat fontSize = (IS_IPAD ? 18 : 18);
    
    titleLabel.font = [UIFont fontWithName:IMHelveticaMedium size:fontSize];
//    titleLabel.textColor = [UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0];
    titleLabel.textColor = [UIColor lightGrayColor];

    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [IMFlurry logEvent:IMDeleverySlotEvent withParameters:@{}];
    NSDate* deliveryDate = self.sortedDatesArray[indexPath.section];
    IMDeliverySlot* deliverySlot =  (IMDeliverySlot*)self.dataDictionary[deliveryDate][indexPath.row];
    [self.delegate didSelectDeliverySlot:deliverySlot];
    [self.navigationController popViewControllerAnimated:YES];
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
