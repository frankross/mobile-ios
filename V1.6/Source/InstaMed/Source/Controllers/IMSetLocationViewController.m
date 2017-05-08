//
//  IMSetLocationViewController.m
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMSetLocationViewController.h"
#import "IMSetLocationCell.h"
#import "IMLocationManager.h"

#define CITY_LIST_ROW_HEIGHT 50
NSString* const IMRadioButtonSelectedImageName = @"SummaryRadioBtnActive";
NSString* const IMRadioButtonUnselectedImageName = @"SummaryRadioBtnInActive";


@interface IMSetLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;

@end

@implementation IMSetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    IMCity* currentLocation = [IMLocationManager sharedManager].currentLocation;
    
    if(currentLocation) //Changing his current location
    {
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.leftBarButtonItem.title = IMCancel;
    }
    else //First time launch
    {
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.tabBarController.tabBar.hidden = YES;
    }
    [self downloadFeed];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)loadUI
{
    [super setUpNavigationBar];
}

-(void)downloadFeed
{
        [self showActivityIndicatorView];
        [[IMLocationManager sharedManager] fetchDeliverySupportedLocationsWithCompletion:^(NSArray *deliveryLocations,IMCity* currentCity, NSError *error)
         {
             if (!error)
             {
                 [self hideActivityIndicatorView];
                 self.modelArray = [deliveryLocations mutableCopy];
                 self.selectedModel = currentCity;
                 [self updateUI];
             }
             else
             {
                 [self handleError:error withRetryStatus:YES];
             }
        }];
}

-(void)updateUI
{
    self.locationTableView.dataSource = self;
    self.locationTableView.delegate = self;
    [self.locationTableView reloadData];
}


#pragma mark - Table view data source and delegate methods -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSetLocationCell *cell = (IMSetLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    IMCity *selectedModel = [self.modelArray objectAtIndex:indexPath.row];
    cell.nameLabel.text =  selectedModel.name;
    
    if(self.selectedModel == self.modelArray[indexPath.row])
    {
        cell.selectionIndicatorImageView.image = [UIImage imageNamed:IMRadioButtonSelectedImageName];
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.selectionIndicatorImageView.image = [UIImage imageNamed:IMRadioButtonUnselectedImageName];
        cell.nameLabel.textColor = [UIColor blackColor];

    }
    
    return cell;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CITY_LIST_ROW_HEIGHT;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.selectedModel)
    {
        NSInteger index = [self.modelArray indexOfObjectIdenticalTo:self.selectedModel];
         IMSetLocationCell *cell = (IMSetLocationCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.selectionIndicatorImageView.image = [UIImage imageNamed:IMRadioButtonUnselectedImageName];
        cell.nameLabel.textColor = [UIColor blackColor];
     
    }
    
    self.selectedModel = self.modelArray[indexPath.row];
    
    IMSetLocationCell *cell = (IMSetLocationCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionIndicatorImageView.image = [UIImage imageNamed:IMRadioButtonSelectedImageName];
    cell.nameLabel.textColor = [UIColor blackColor];

    
}

- (IBAction)donePressed:(id)sender
{

    [IMFlurry logEvent:IMLocationChangeEvent withParameters:@{}];

    [IMLocationManager sharedManager].currentLocation = (IMCity*)self.selectedModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:IMReoladProductListNotificationName object:self];

       [[NSNotificationCenter defaultCenter] postNotificationName:IMLocationChangedNotification object:self];
    


    [self.navigationController popViewControllerAnimated:NO];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishSettingLocation)])
    {
        [self.delegate didFinishSettingLocation];
    }

}

- (IBAction)cancelPressed:(id)sender
{
    
}
@end
