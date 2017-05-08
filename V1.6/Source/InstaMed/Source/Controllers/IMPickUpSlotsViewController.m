//
//  IMPickUpSlotsViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 05/08/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPickUpSlotsViewController.h"
#import "IMDeliverySlotTableViewCell.h"

#import "IMCartManager.h"
#import "IMDeliverySlot.h"


@interface IMPickUpSlotsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pickUpSlotsTableView;

@property (strong,nonatomic) NSMutableDictionary* dataDictionary;
@property(strong,nonatomic) NSArray* sortedDatesArray;

@end

@implementation IMPickUpSlotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void)loadUI
{
    self.title = @"Pickup slot";
    [self setUpNavigationBar];
    
    self.pickUpSlotsTableView.hidden = YES;
    
    [self downloadFeed];
}


-(void)downloadFeed
{
//    [self showActivityIndicatorView];
//    
//    [[IMCartManager sharedManager] fetchDeliverySlotsForAreaId:@16 withPrescription:NO withCompletion:^(NSMutableArray *deliverySlots, NSError *error) {
//        
//        [self hideActivityIndicatorView];
//        
//        self.dataDictionary = [NSMutableDictionary dictionary];
//        if(!error)
//        {
//            if(deliverySlots.count)
//            {
//                for (IMDeliverySlot* deliverySlot in deliverySlots)
//                {
//                    if(!self.dataDictionary[deliverySlot.slotDate])
//                    {
//                        self.dataDictionary[deliverySlot.slotDate] = [NSMutableArray array];
//                    }
//                    
//                    [self.dataDictionary[deliverySlot.slotDate] addObject:deliverySlot];
//                }
//                self.sortedDatesArray = [[self.dataDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj2, id obj1) {
//                    return [obj2 compare:obj1];
//                }];
//                
//                [self updateUI];
//            }
//            else
//            {
//                self.pickUpSlotsTableView.hidden = YES;
//                [self setNoContentTitle:IMNoDeliverySlotsAvailable];
//            }
//        }
//        else
//        {
//            if(error.userInfo[IMMessage])
//            {
//                [self showAlertWithTitle:@"" andMessage:[error.userInfo valueForKey:IMMessage]];
//            }
//            else
//            {
//                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
//            }
//        }
//        
//    }];
}

-(void)updateUI
{
    self.pickUpSlotsTableView.hidden = NO;

    [self.pickUpSlotsTableView reloadData];
    
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.dataDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDictionary[self.sortedDatesArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMDeliverySlotTableViewCell* deliverySlotCell = (IMDeliverySlotTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"IMDeliverySlotCell" forIndexPath:indexPath];
    
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

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [IMFlurry logEvent:IMDeleverySlotEvent withParameters:@{}];
//    NSDate* deliveryDate = self.sortedDatesArray[indexPath.section];
//    //IMDeliverySlot* deliverySlot =  (IMDeliverySlot*)self.dataDictionary[deliveryDate][indexPath.row];
//    //[self.delegate didSelectDeliverySlot:deliverySlot];
//    [self.navigationController popViewControllerAnimated:YES];
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
    CGFloat height = PRODUCT_LIST_HEADER_HEIGHT - 10;
    
    CGRect frame = CGRectMake(0,0, screenWidth , height);
    CGRect Lframe = CGRectMake(15,25, screenWidth , 30);
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];

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





@end
