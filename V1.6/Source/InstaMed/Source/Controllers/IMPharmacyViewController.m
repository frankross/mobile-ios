//
//  IMPharmacyViewController.m
//  InstaMed
//
//  Created by Suhail K on 04/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#define PHARMA_CATEGORY_ID 810
#define ALERT_FADE_DELAY 3

#import "IMPharmacyViewController.h"
#import "IMCategory.h"
#import "IMNotification.h"
#import "IMcategoryTableViewCell.h"
#import "IMPharmacyManager.h"
#import "IMPharmacySubCategoryViewController.h"
#import "IMProductListViewController.h"
#import "UITextField+IMSearchBar.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"


const NSInteger IMNonPharmaCategoryListRowHeight = 55;

@interface IMPharmacyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
//@property (nonatomic,strong) IMCategory* otcMedicines;
//@property (nonatomic,strong) IMCategory* medicalAids;
@property(nonatomic,strong) IMcategoryTableViewCell* prototypeCell;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottomConstraint;
@end

@implementation IMPharmacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Pharmacy_Landing";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IMFlurry logEvent:IMTimeSpendInPharmacy withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMCategoriesScreenVisited withParameters:@{}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMTimeSpendInPharmacy withParameters:@{}];
}

-(void)loadUI
{
//    [super loadUI];
    [self setUpNavigationBar];
    [self addCartButton];
    self.modelArray = [[NSMutableArray alloc] init];
    self.searchContainerView.backgroundColor = APP_THEME_COLOR;
    [self.searchField configureAsSearchBar];
//    self.tableViewToBottomConstraint.constant = self.tabBarController.tabBar.frame.size.height;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = APP_THEME_COLOR;
    [self downloadFeed];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
   
    [self downloadFeed];
}

/**
 @brief To download feeds
 @returns void
 */
-(void)downloadFeed
{
    
//    self.modelArray = [[NSMutableArray alloc] init];
    [self showActivityIndicatorView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [[IMPharmacyManager sharedManager] fetchCategoriesWithCompletion:^(NSMutableArray *categories,NSNumber *popularCount, NSError *error) {
        [self hideActivityIndicatorView];
        if(error)
        {
            [self handleError:error withRetryStatus:YES];
        }
        else
        {
//            for(IMCategory* category in categories)
//            {
//                if([[category.name lowercaseString] isEqualToString:IMOTCMedicins])
//                {
//                    self.otcMedicines = category;
//                }
//                else if([[category.name lowercaseString] isEqualToString:IMMedicalAidsAndDevices])
//                {
//                    self.medicalAids = category;
//                }
//                else if([[category.name lowercaseString] isEqualToString:IMNutritionalSuppliments])
//                {
//                    self.medicalAids = category;
//                }
//                else if(!category.isPharmaProduct)
//                {
//                    [self.modelArray addObject:category];
//                }
//            }
            self.modelArray = categories;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        }
    }];
    
}


/**
 @brief To update UI after downloding feed
 @returns void
 */
-(void)updateUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
//    CGFloat tableHeight = self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height;
//    
//    for(NSInteger index=0;index<[self.tableView numberOfRowsInSection:0];index++)
//    {
//        tableHeight += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    }
//    self.tableViewHeightConstraint.constant = tableHeight;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)pushToDetailWithNotification:(IMNotification *)notification
{
    NSString *notificationType = notification.notificationType;
    NSString *categoryID = notification.ID;
    NSString *couponCode = notification.couponCode;
//    UIAlertView *clipBoardAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"reached here" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [clipBoardAlert show];
    if([notificationType isEqualToString:NOTIFICATION_TYPE_ELEVEN])
    {
        
        //Push to subcategory vc
        IMCategory *model = [[IMCategory alloc] init];
        model.identifier = @([categoryID intValue]);
        IMPharmacySubCategoryViewController *subCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:IMSubCategoryViewControllerID];
        subCategoryVC.selectedModel = model;
        [self.navigationController pushViewController:subCategoryVC animated:NO];
    }
    else if ([notificationType isEqualToString:NOTIFICATION_TYPE_FOURTEEN])
    {
//        //Push to subcategory vc
        IMCategory *model = [[IMCategory alloc] init];
        model.identifier = @([categoryID intValue]);
        IMPharmacySubCategoryViewController *subCategoryVC = [self.storyboard instantiateViewControllerWithIdentifier:IMSubCategoryViewControllerID];
        subCategoryVC.selectedModel = model;
        [self.navigationController pushViewController:subCategoryVC animated:NO];
        
        if (couponCode != nil && ![couponCode isEqualToString:@""])
        {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:couponCode];
            NSString *alertMsg = [NSString stringWithFormat:IMCouponCodeCopiedToClipboardMessageFormat,couponCode];
            UIAlertView *clipBoardAlert = [[UIAlertView alloc] initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [clipBoardAlert show];
            [self performSelector:@selector(dissmissAlert:) withObject:clipBoardAlert afterDelay:ALERT_FADE_DELAY];
        }
    }
}
#pragma mark -TableView -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMcategoryTableViewCell *cell = (IMcategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IMCategoryCell" forIndexPath:indexPath];
    cell.model = [self.modelArray objectAtIndex:indexPath.row];
    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return IMNonPharmaCategoryListRowHeight;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMcategoryTableViewCell* cell = (IMcategoryTableViewCell* )[tableView cellForRowAtIndexPath:indexPath];
    IMCategory *model = [self.modelArray objectAtIndex:indexPath.row];
    if([model.identifier integerValue] == PHARMA_CATEGORY_ID)
    {
        [self performSegueWithIdentifier:@"IMPrescriptionMedicinsSegue" sender:cell];
    }
    else
    {
        [self performSegueWithIdentifier:@"IMNonPharmaCategorySegue" sender:cell];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(!self.prototypeCell)
        {
            self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"IMCategoryCell"];
        }
        
        //address.tag = @"Home";
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        
        self.prototypeCell.bounds = CGRectMake(0, 0, self.tableView.frame.size.width, self.prototypeCell.bounds.size.height);
        
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        
        CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"cell height = %lf",height);
        
        return height;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (void)configureCell:(IMcategoryTableViewCell *)catCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMCategory *model = [self.modelArray objectAtIndex:indexPath.row];
    catCell.title.attributedText = [self attributedStringForString:model.name];
    
    catCell.imgView.image = [UIImage imageNamed:IMProductPlaceholderName];
    
    NSLog(@"URL: %@",model.imageURL);
    if(model.imageURL && model.imageURL != ((id)[NSNull null]) )
    {
        [catCell.imgView setImageWithURL:[NSURL URLWithString:model.imageURL]
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if([segue.identifier isEqualToString:@"IMNonPharmaCategorySegue"])
    {
        IMCategory* selectedCategory = ((IMcategoryTableViewCell*)sender).model;

        NSString *event = selectedCategory.name;
        NSDictionary *categoryParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                       event, @"Category_Name",
                                       nil];
        [IMFlurry logEvent:IMCategories withParameters:categoryParams];
        
//        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).modelArray = selectedCategory.subCategories;

        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).selectedModel = selectedCategory;
    }
    else if([segue.identifier isEqualToString:@"IMSearchSegue"])
    {
        NSDictionary *Params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.screenName, @"Screen_Name",
                                nil];
        [IMFlurry logEvent:IMSearchBarTapped withParameters:Params];
    }
    
//    else if([segue.identifier isEqualToString:@"IMOTCategorySegue"])
//    {
//        [IMFlurry logEvent:self.otcMedicines.name withParameters:@{}];
//
//        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).modelArray = self.otcMedicines.subCategories;
//        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).selectedModel = self.otcMedicines;
//    }
//    else if([segue.identifier isEqualToString:@"IMMedicalAidsSegue"])
//    {
//        [IMFlurry logEvent:self.medicalAids.name withParameters:@{}];
//
//        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).modelArray = self.medicalAids.subCategories;
//        ((IMPharmacySubCategoryViewController*)segue.destinationViewController).selectedModel = self.medicalAids;
//    }
}

-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

@end
