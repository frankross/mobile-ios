//
//  IMOffersViewController.m
//  InstaMed
//
//  Created by Yusuf Ansar on 06/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


#import "IMOffersViewController.h"
#import "IMCategoryProductListController.h"
#import "IMOfferDetailViewController.h"
#import "IMListingOffers.h"
#import "IMOfferTableViewCell.h"

#import "IMPharmacyManager.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"

#define ALERT_FADE_DELAY 2

@interface IMOffersViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IMOfferTableViewCell* prototypeCell;
@property (nonatomic, strong) UILabel *noContentLabel;


@end

@implementation IMOffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Offers";
    self.screenName = @"Offers";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMOfferScreenVisited withParameters:@{}];
}


/**
 @brief To setup initial ui elements
 @returns void
 */
-(void)loadUI
{
    [super loadUI];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self downloadFeed];
}



/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    self.modelArray = [[NSMutableArray alloc] init];
    [self showActivityIndicatorView];
    
    [[IMPharmacyManager sharedManager] fetchOffersForListingPageWithCompletion:^(NSDictionary *offersDictionary, NSError *error) {
        
        [self hideActivityIndicatorView];
        if(error)
        {
            [self handleError:error withRetryStatus:YES];
        }
        else
        {
            NSArray *offers = offersDictionary[@"offers"];

            for(NSDictionary *offerDictionary in offers)
            {
                IMListingOffers *offer = [[IMListingOffers alloc] initWithDictionary:offerDictionary];
                [self.modelArray addObject:offer];
            }
            [self updateUI];
        }

        
    }];

}



/**
 @brief To update ui after feed
 @returns void
 */
-(void)updateUI
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if(0 == self.modelArray.count )
    {
        [self setNoContentTitle:@"No offers found"];
    }
    else
    {
        [self setNoContentTitle:@""];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView Datasource and delegate Methods -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.modelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMOfferTableViewCell* offerCell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    [self configureCell:offerCell forRowAtIndexPath:indexPath];
   
    return offerCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [IMFlurry logEvent:IMOfferTappedEvent withParameters:@{}];
    IMListingOffers *offer = self.modelArray[indexPath.row];
    
    [self copyCouponCode:offer.couponCode];
    
    if (offer.promotionID != nil && offer.isListable)
    {
        [self performSegueWithIdentifier:@"OfferProductListSegue" sender:offer];
    }
    else
    {
        if (![offer.htmlURL isEqualToString:@""] && offer.htmlURL != nil) {
            [self performSegueWithIdentifier:@"IMOfferDetailSegue" sender:offer];
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat height = (7.0/18.0) * self.view.frame.size.width;
    return height + 8;
    
}

#pragma mark - Private


/**
 @brief To configure dynamic height cell
 @returns void
 */
- (void)configureCell:(IMOfferTableViewCell *)offerCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMListingOffers *offer = self.modelArray[indexPath.row];
    offerCell.offerImageview.image = [UIImage imageNamed:@"ProductPlaceHolderPDP"];
    
    if(offer.offerImageURL && ![offer.offerImageURL isEqualToString:@""])
    {
        [offerCell.offerImageview setImageWithURL:[NSURL URLWithString:offer.offerImageURL]
                      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }


    offerCell.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**
 @brief Function to copy coupon code to clipboard
 @returns void
 */
- (void)copyCouponCode:(NSString *) couponCode
{
    if(couponCode)
    {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:couponCode];
        NSString *alertMsg = [NSString stringWithFormat:IMCouponCodeCopiedToClipboardMessageFormat,couponCode];
        UIAlertView *clipBoardAlert = [[UIAlertView alloc] initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [clipBoardAlert show];
        [self performSelector:@selector(dissmissAlert:) withObject:clipBoardAlert afterDelay:ALERT_FADE_DELAY];
    }
}

/**
 @brief Function to dissmiss coupon code alert
 @returns void
 */
- (void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

/**
 @brief Function to set no content label
 @returns void
 */
- (void)setNoContentTitle:(NSString *)title
{
    if([title isEqualToString:@""])
    {
        self.noContentLabel.hidden = YES;
        self.tableView.hidden = NO;
    }
    else
    {
        self.noContentLabel.center = CGPointMake(self.view.bounds.size.width/2,  self.view.bounds.size.height/2);
        self.noContentLabel.hidden = NO;
        self.noContentLabel.text = title;
        self.tableView.hidden = YES;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    IMListingOffers *offer = self.modelArray[selectedIndex.row];
    
    if([segue.identifier isEqualToString:@"OfferProductListSegue"])
    {
        IMCategoryProductListController *productListVC = (IMCategoryProductListController*) segue.destinationViewController;
        productListVC.title =  @"Products";
        productListVC.productListType = IMProductListScreen;
        productListVC.promtionID = offer.promotionID;
    }
    else if([segue.identifier isEqualToString:@"IMOfferDetailSegue"])
    {
        IMOfferDetailViewController *offerDetailVC = (IMOfferDetailViewController*) segue.destinationViewController;
        offerDetailVC.htmlURL = offer.htmlURL;
    }
}


@end
