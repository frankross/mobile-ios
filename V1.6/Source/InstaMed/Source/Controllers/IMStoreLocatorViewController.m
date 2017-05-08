//
//  IMStoreLocatorViewController.m
//  InstaMed
//
//  Created by Suhail K on 09/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMStoreLocatorViewController.h"
#import "IMStore.h"
#import "IMStoreTableViewCell.h"
#import "IMServerManager.h"
#import "IMLocationManager.h"
#import "IMSupportUtility.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface IMStoreLocatorViewController ()<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IMStoreTableViewCell* prototypeCell;
@property(nonatomic,strong) CLLocation* userLocation;

@end

@implementation IMStoreLocatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Store_Locator";

    NSArray *vcArray = [self.navigationController viewControllers];
    if (vcArray.count > 2) {
        /*During login flow this view controller is second one in VC stack
         so we are modifying VC stack so that this VC is root view controller.
         */
        NSMutableArray *newVCArray = [vcArray mutableCopy];
        [newVCArray removeObjectAtIndex:1];
        self.navigationController.viewControllers = newVCArray;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMStoreLocatorVisited withParameters:@{}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUI
{
    [super loadUI];
    [self.tableView setHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self downloadFeed];
}

-(void)downloadFeed
{
    self.modelArray = [[NSMutableArray alloc] init];
    [self showActivityIndicatorView];
    [self setNoContentTitle:@""];
    [[IMLocationManager sharedManager]fetchGeoLocationWithHandler:^(CLLocation *location, NSError *error) {
        self.userLocation = location;
        
        if (error == nil)
        {
            NSDictionary *parameter = @{@"lat":@(location.coordinate.latitude), @"long":@(location.coordinate.longitude)};
            [[IMServerManager sharedManager]fetchNearbyStoresWithParameters:parameter withCompletion:^(NSArray *stores, NSError *error) {
                [self hideActivityIndicatorView];
                if (error == nil) {
                    self.modelArray = [stores mutableCopy];
                    if (self.modelArray.count > 0) {
                        [self.tableView setHidden:NO];
                        [self updateUI];
                    }
                    else
                    {
                        [self setNoContentTitle:@"No stores found"];
                    }
                    
                }
                else
                {
                    [self handleError:error withRetryStatus:YES];
                    //handle error
//                    [self showErrorPanelWithMessage:@"Failed to get stores" showRetryButton:YES];
                }
            }];
        }
        else
        {
            //location fetch error
            [self hideActivityIndicatorView];
            [self setNoContentTitle:error.localizedDescription];
            //[self showErrorPanelWithMessage:error.localizedDescription];
        }
    }];
    
    
//    self.modelArray = [[NSMutableArray alloc] init];
//     IMStore *store = [[IMStore alloc] init];
//     store.name = @"Anand Nagar";
//     IMAddress* address = [[IMAddress alloc] init];
//     address.name = @"Alok Banerjee";
//     address.addressLine1 = @"Andheri,West Block, Santhekatte, New Udupi, Santhekatte, New Udupi";
//     address.addressLine2 = @"Yashwant Pura";
//     IMCity* city  = [[IMCity alloc] init];
//     city.name = @"Mumbai";
//     address.city = city;
//     address.pinCode = @(576101);
//     address.phoneNumber = @"+918050108559";
//     
//     store.address = address;
//     store.timing = @"24 hrs (Sunday closed)";
//     store.kiloMeter = @"450";
//     
//     
//     IMStore *store1 = [[IMStore alloc] init];
//     store1.name = @"Udupi Store";
//     IMAddress* address1 = [[IMAddress alloc] init];
//     address1.name = @"Arjuna Acharya";
//     address1.addressLine1 = @"Mangalore,West Block, ";
//     address1.addressLine2 = @"Kalyan Pura, Santhekatte, New Udupi,Kalyan Pura, Santhekatte, New Udupi.";
//     IMCity* city1  = [[IMCity alloc] init];
//     city1.name = @"Udupi";
//     address1.city = city;
//     address1.pinCode = @(576101);
//     address1.phoneNumber = @"+918050108559";
//     
//     store1.address = address1;
//     store1.timing = @"12 hrs (Sunday closed)";
//     store1.kiloMeter = @"450";
//     [self.modelArray addObject:store];
//     [self.modelArray addObject:store1];
//     
//     [self updateUI];
}

-(void)updateUI
{
    [self.tableView setHidden:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - Table view data source and delegate methods -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMStoreTableViewCell *cell = (IMStoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IMStoreCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    if(!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMStoreCell"];
    }
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"cell height = %lf",height);
    
    return height;
    
}


- (void)configureCell:(IMStoreTableViewCell *)storeCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMStore* model = self.modelArray[indexPath.row];
    //address.tag = @"Home";
    storeCell.callButton.tag = indexPath.row;
    storeCell.directionButton.tag = indexPath.row;

    storeCell.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    NSString *labelText = [NSString stringWithFormat:@"%@",model.address.addressLine1];
    //    NSString *labelText = [NSString stringWithFormat:@"%@  %@ - %@",model.address.addressLine1,model.address.addressLine2,model.address.pinCode];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    storeCell.addressLabel.attributedText =  attributedString;
    storeCell.timingLabel.text = model.timing;
    if(model.kiloMeter) {
        storeCell.KMLabel.text = [NSString stringWithFormat:@"%@ away",model.kiloMeter];
    }
}

#pragma mark -
#pragma mark Action Methods
#pragma mark -
/**
 @brief Method invoked on tapping the "Get directions" button in the stores list. Loads Google map to show the direction to store from user's current location.
 @param sender: UIButton
 @returns IBAction
 */
- (IBAction)directionsButtonTapped:(UIButton*)sender {
    self.selectedModel = self.modelArray[sender.tag];

    IMStore *selectedStore = (IMStore*) self.selectedModel;
    CLLocation *storeLocation = [IMSupportUtility locationFromLatitude:selectedStore.latitude longitude:selectedStore.longitude];
    
    [IMSupportUtility loadDirectionsMap:self.userLocation  destination:storeLocation];
}

/**
 @brief Method invoked on tapping the "Call us" button in the stores list. Loads Phone app to facilitate calling the store.
 @param sender: UIButton
 @returns IBAction
 */
- (IBAction)callusButtonTapped:(UIButton*)sender {
    self.selectedModel = self.modelArray[sender.tag];
    IMStore *selectedStore = (IMStore*) self.selectedModel;

    if (selectedStore.phoneNumbers.count > 0) {
        // if only one phone number present then directly load the Phone app
        if (selectedStore.phoneNumbers.count == 1) {
            if (![IMSupportUtility callNumber:selectedStore.phoneNumbers[0]]) {
                [self showAlertWithTitle:@"" andMessage:IMCallNotAvailableMessage];
            }
        }
        // if multiple phone number present then let the user pick the number
        else{
            if (IS_IOS8_OR_ABOVE)
            {
                [self showPickNumberControllerSheet];
            }
            else{
                [self showPickNumberSheet];
            }
        }
    }
    else
    {
        [self showAlertWithTitle:@"" andMessage:IMCallNotAvailableMessage];
    }
}

/**
 @brief Allows user to pick the number between the store contact numbers available (iOS 8 and above)
 */
- (void) showPickNumberControllerSheet
{
    IMStore *selectedStore = (IMStore*) self.selectedModel;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:IMCallUsOn  message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // add all store phone numbers
    for (NSString* phonenumber in selectedStore.phoneNumbers) {
        // add action for each button associated with phone number
        UIAlertAction *buttonAction = [UIAlertAction
                                       actionWithTitle:phonenumber
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (![IMSupportUtility callNumber:phonenumber]) {
                                               [self showAlertWithTitle:@"" andMessage:IMCallNotAvailableMessage];
                                           }
                                       }];
        [actionSheet addAction:buttonAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:IMCancel
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [actionSheet addAction:cancelAction];
    actionSheet.view.tintColor = APP_THEME_COLOR;
    [self presentViewController:actionSheet animated:YES completion:nil];
    //To change color of buttons displayed in the action sheet
    actionSheet.view.tintColor = APP_THEME_COLOR;
 }

/**
 @brief Allows user to pick the number between the store contact numbers available (iOS 7 and below)
 */
- (void) showPickNumberSheet
{
    IMStore *selectedStore = (IMStore*) self.selectedModel;
    
    NSString *actionSheetTitle = IMCallUsOn; //Action Sheet Title
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:IMCancel
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    // add all store phone numbers
    for (NSString* phonenumber in selectedStore.phoneNumbers) {
        [actionSheet addButtonWithTitle:phonenumber];
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods
#pragma mark -
/**
 @brief Delegate invoked on tapping a button in the contact number picker action sheet (iOS 7 and below)
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:IMCancel] && ![IMSupportUtility callNumber:buttonTitle]) {
        [self showAlertWithTitle:@"" andMessage:IMCallNotAvailableMessage];
    }
}

/**
 @brief To change color of buttons displayed in the action sheet
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
        }
    }
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
