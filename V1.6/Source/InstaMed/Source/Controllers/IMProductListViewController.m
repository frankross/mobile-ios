//
//  IMProductListViewController.m
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProductListViewController.h"
#import "IMProduct.h"
#import "IMProductTableViewCell.h"
#import "IMPharmacyManager.h"
#import "IMFacebookManager.h"
#import "IMPharmaDetailViewController.h"
#import "IMNonPharmaDetailViewController.h"
#import "IMAccountsManager.h"
#import "IMCartManager.h"
#import "IMQuantitySelectionViewController.h"

#define PRODUCT_LIST_ROW_HEIGHT 145
#define ALERT_FADE_DELAY 1



@interface IMProductListViewController ()<UITableViewDelegate,UITableViewDataSource,IMQuantitySelectionViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;

@property(nonatomic,assign) NSInteger nbPages;
@property(nonatomic,assign) NSInteger currentPage;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UIView *strockLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreButton;
@property (nonatomic,strong) NSDictionary* facetInfo;
@property (nonatomic) BOOL shouldReoladProductList;
@property (nonatomic, assign) BOOL isFirstVisit;

@property (assign, nonatomic) CGPoint lastContentOffset;
@property (assign, nonatomic) NSInteger testcount;


@end

@implementation IMProductListViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadUI
{
    [super loadUI];
    self.screenName = @"Product_List";

    self.dataSource = [[NSMutableArray alloc] init];
//    self.tableView.tableFooterView.backgroundColor = [UIColor redColor];
    //self.parameters = [NSMutableDictionary dictionary];

 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReloadProductListFromServer:) name:IMReoladProductListNotificationName object:nil];
    
    self.currentPage = 0;
    
    //[self downloadFeed];
    

    if(self.productListType != IMTopSellingHomeScreen && self.productListType != IMYouMayScreen)
    {
           self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
       
    }
    
    switch (self.productListType) {
        case IMTopSellingListScreen:
            self.title = IMTopSelling;
            break;
        case IMTopSellingHomeScreen:
            self.tableView.scrollEnabled = NO;
            break;
        case IMOfferProductListScreen:
            self.title = IMOffersText;
            break;
        case IMRecentlyOrderedPharmacy:
            self.tableView.scrollEnabled = NO;
            break;
        case IMrecentlyOrderd:
            self.title = IMrecentlyOrderdtext;
            break;
        case IMYouMayScreen:
            self.tableView.scrollEnabled = NO;
            break;
        case IMFeaturedFromHome:
            self.title = IMFeaturedProductScreenTitle;
            break;
        case IMFeaturedFromCategory:
            self.title = IMFeaturedProductScreenTitle;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SET_FOR_YOU_CELL_BORDER(self.viewMoreButton,APP_THEME_COLOR, 8.0f);
    self.isFirstVisit =  YES;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

-(void)handleReloadProductListFromServer:(NSNotification*)notification
{
    self.shouldReoladProductList = YES;
    [self reloadProductListFromServer];
}

-(void)reloadProductListFromServer
{
    self.currentPage = 0;
    //ka if not updated app crashes when switching back to products list screen after applying the filter/sort with network turned off or on log out
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
        [self updateUI];
    }
    
    [self downloadFeed];
    self.shouldReoladProductList = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
//    [IMFlurry logEvent:IMProductListVisit withParameters:@{}];
//    [IMFlurry logEvent:IMTimeSpendInProductList withParameters:@{} timed:YES];
    [IMFlurry logEvent:IMProductListScreenVisited withParameters:@{}];

    if(self.isFirstVisit  || self.shouldReoladProductList)
    {
        [self reloadProductListFromServer];
       
    }
    self.isFirstVisit = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//   [IMFlurry endTimedEvent:IMTimeSpendInProductList withParameters:@{}];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleProducts:(NSArray*)products totalCount:(NSInteger)totalProductCount error:(NSError*)error
{
    self.totalProductCount = totalProductCount;
    if(products)
    {
        [self.dataSource addObjectsFromArray:products];
    }
    [self updateUI];

}

- (void)downloadFeed
{
//    IMProduct *product1 = [[IMProduct alloc] init];
//    product1.productID = @"1";
//    product1.type = @"Pharma";
//    product1.name = @"Biotique Pineapple Fresh Foaming Cleansing Gel, 120 ml For Oily Skin";
//    product1.sellingPrice = @"1054";
//    product1.mrp = @"1998";
//    
//    
//    IMProduct *product2 = [[IMProduct alloc] init];
//    product2.productID = @"1";
//    product2.type = @"nonPharma";
//    product2.name = @"Biotique Pineapple Fresh Foaming Cleansing Gel, 120 ml For Oily Skin";
//    product2.sellingPrice = @"1058";
//    product2.mrp = @"1998";
//
//    [self.dataSource addObject:product1];
//    [self.dataSource addObject:product1];
//    [self.dataSource addObject:product1];
//    [self.dataSource addObject:product1];
//    [self.dataSource addObject:product2];
//
    NSUInteger productsPerPage = 20;
    
    if (!self.parameters) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    switch (self.productListType)
    {
        case IMTopSellingListScreen:
        {
//            [self showActivityIndicatorView];
            self.parameters[@"filters"] = @"topSelling";
            
            break;
        }
            
        case IMTopSellingHomeScreen:
        {

            self.parameters[@"filters"] = @"topSelling";
            productsPerPage = 5;
            break;
            
        }
            
        case IMYouMayScreen:
        {
            self.parameters[@"filters"] = @"youMay";
            productsPerPage = 5;
            break;

        }
            
        case IMrecentlyOrderd:
        {
            self.parameters[@"filters"] = @"recentlyOrdered";
            productsPerPage = 100;
            break;
            
        }
            
        case IMRecentlyOrderedPharmacy:
        {
            productsPerPage = 10;
            break;
        }
        case IMFeaturedFromHome:
        {
            //            [self showActivityIndicatorView];
            self.parameters[IMFilterKey] = IMFeaturedKey;
            
            break;
        }
        case IMFeaturedFromCategory:
        {
            //            [self showActivityIndicatorView];
            self.parameters[IMFilterKey] = IMFeaturedKey;
            
            break;
        }

        default:
            break;

            
//        case IMProductListScreen:
//        {
//                break;
//            
//        }
//            
//        case IMOfferProductListScreen:
//        {
//                break;
//
//        }
//            
//        case IMSearcResulthScreen:
//        {
//            break;
//
//        }


    }
    
//    [[IMPharmacyManager sharedManager] fetchProductsForParametrs:self.parameters inRange:NSMakeRange(self.dataSource.count, self.batchSize) withCompletion:^(NSArray *products, NSInteger totalProductCount, NSError *error) {
//        [self hideActivityIndicatorView];
//        [self handleProducts:products totalCount:totalProductCount error:error];
//    }];
    
    
    
    if(self.productListType != IMRecentlyOrderedPharmacy && self.productListType != IMrecentlyOrderd)
    {
        
        if(self.currentPage  > self.nbPages)
        {
            return;
        }
        
        [self showActivityIndicatorView];
        
        [[IMPharmacyManager sharedManager] fetchProductsForParametrs:self.parameters inPage:self.currentPage productsPerPage:productsPerPage  withCompletion:^(NSArray *products, NSInteger totalPageCount,NSInteger totalProductCount, NSDictionary* facetInfo,  NSError *error) {
            
            [self hideActivityIndicatorView];
            
            if(!error)
            {
                self.nbPages = totalPageCount;
                self.totalProductCount = totalProductCount;
                [self.dataSource addObjectsFromArray:products];
                self.currentPage++;
                self.facetInfo = facetInfo;
                [self updateUI];
            }
            else
            {
                [self handleError:error withRetryStatus:YES];

            }
            
            if(totalProductCount)
            {
                [self setNoContentTitle:@""];
                self.tableView.hidden = NO;
            }
            else
            {
                // in case of filter apply, display no products found message
                if(self.filterApplied)
                {
                    [self setNoContentTitle:IMNoFilteredProduct];
                }
                else if(self.productListType != IMSearcResulthScreen)
                {
                    [self setNoContentTitle:IMproductComingSoon];
                }
            }
        }];
    }
    else
//    {
//        if(self.productListType == IMrecentlyOrderd)
//            productsPerPage = 0;
        
        if([[IMAccountsManager sharedManager] userToken])
        {
            
            [self showActivityIndicatorView];
            
            
            [[IMPharmacyManager sharedManager] fetchRecentlyOrderedPharmaProductsWithCount:productsPerPage completion:^(NSArray *pharmaProducts, NSError *error) {
                [self hideActivityIndicatorView];
                
                if(!error)
                {
                    [self.dataSource addObjectsFromArray:pharmaProducts];
                    [self updateUI];
                }
                else
                {
                    [self handleError:error withRetryStatus:YES];

                }
                
                if(pharmaProducts.count)
                {
                    self.tableView.hidden = NO;
                }
            }];
        }
        else
        {
            self.tableView.hidden = YES;
        }
    }

/**
 @brief To handle UI update after feed downloading
 @returns void
 */

- (void)updateUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    if([self.delegate respondsToSelector:@selector(didLoadTableViewWithTableViewHeight:andTotalProductCount:andFacetInfo:)])
    {

        CGFloat heightOfTableView = [self tableViewHeight];
        [self.delegate didLoadTableViewWithTableViewHeight:heightOfTableView andTotalProductCount:self.totalProductCount andFacetInfo:self.facetInfo];
    }
}



#pragma mark - Table view data source and delegate methods -

/**
 @brief To setup haeder view for table
 @returns void
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = PRODUCT_LIST_HEADER_HEIGHT;
    
    CGRect viewFrame = CGRectMake(0, 0, screenWidth , height);
    CGRect labelFrame = CGRectMake(0, 25, screenWidth , 20);
    
    UIView *headerView = [[UIView alloc] initWithFrame:viewFrame];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:labelFrame];
    if(self.productListType == IMYouMayScreen)
    {
        titleLabel.text =IMYouMayAlsoLikeProduct;
    }
    else if(self.productListType == IMTopSellingHomeScreen)
    {
        titleLabel.text = IMTopSellingProduct;
    }
    else if (self.productListType == IMRecentlyOrderedPharmacy)
    {
        titleLabel.text = IMrecentlyOrderdtext;
    }
 
    titleLabel.backgroundColor =  [UIColor clearColor];
    CGFloat fontSize = (IS_IPAD ? 22 : 17);
    
    titleLabel.font = [UIFont fontWithName:IMHelveticaMedium size:fontSize];
    titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    
    if(self.productListType == IMRecentlyOrderedPharmacy)
    {
        headerView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    }
    else
    {
        headerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    }

    
    UIView  *separator = [[UIImageView alloc]init];
    separator.frame = CGRectMake(0,height - 1,self.view.frame.size.width ,1);
    separator.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:220/255.0];

    [headerView addSubview:separator];
    return headerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = PRODUCT_LIST_HEADER_HEIGHT;
    if(self.productListType == IMTopSellingListScreen || self.productListType == IMOfferProductListScreen || self.productListType == IMProductListScreen|| self.productListType == IMSearcResulthScreen || self.productListType == IMFeaturedFromCategory || self.productListType == IMFeaturedFromHome || self.productListType == IMProductListCategoryScreen)
    {
        height = 0;
    }
    
    return height;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMProductTableViewCell *cell = (IMProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    IMProduct *selectedModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = selectedModel;
    cell.addToCartButton.tag = indexPath.row;

    if(indexPath.row >= self.dataSource.count-1 && self.dataSource.count < self.totalProductCount &&  self.productListType != IMTopSellingHomeScreen && self.productListType != IMYouMayScreen && self.productListType != IMrecentlyOrderd && self.productListType != IMRecentlyOrderedPharmacy)
    {
        [self downloadFeed];
    }
    if(self.productListType == IMRecentlyOrderedPharmacy)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    IMProductTableViewCell *cell = (IMProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    IMProduct *selectedModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = selectedModel;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMProduct* product = self.dataSource[indexPath.row];
    
    if(product.isPharma)
    {
        [self performSegueWithIdentifier:@"pharmaProductSegue" sender:product];
    }
    else
    {
        [self performSegueWithIdentifier:@"nonPharmaProductSegue" sender:product];
    }
}

#pragma mark  - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"topSellingProductListSegue"])
    {
      
        ((IMProductListViewController*)segue.destinationViewController).productListType = IMTopSellingListScreen;
          ((IMProductListViewController*)segue.destinationViewController).parameters = self.parameters;
    }
    else if([segue.identifier isEqualToString:@"pharmaProductSegue"])
    {
        ((IMPharmaDetailViewController*)segue.destinationViewController).product = (IMProduct*) sender;
    }
    else if([segue.identifier isEqualToString:@"nonPharmaProductSegue"])
    {
        ((IMNonPharmaDetailViewController*)segue.destinationViewController).selectedModel = (IMProduct*) sender;
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

/**
 @brief To handle add to cart button action
 @returns void
 */
- (IBAction)addToCartPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMAddToCartProductList withParameters:@{}];

    IMProduct *product = self.dataSource[sender.tag];
    
    if(product.isPharma)
    {
        //Pharma product add to cart
        [self pharmaAddToCartWithModel:product];
    }
    else
    {
        //NonPharma product add to cart
        [self nonPharmaAddtocartWithModel:product];
    }
}

- (void)pharmaAddToCartWithModel:(IMProduct *)product
{
    IMLineItem *lineItem = [[IMLineItem alloc] init];
    lineItem.identifier = product.identifier;
    lineItem.name = product.name;
    lineItem.quantity = [[IMCartManager sharedManager] quantityOfCartLineItemWithVariantId:product.identifier];
    
    if(!lineItem.quantity)
    {
        lineItem.quantity = 1;
    }
    lineItem.quantity = MIN([product.maxOrderQuantity integerValue], lineItem.quantity);
    
    //Algolia should return  inner package qty,unit of sale, max order quandity
    lineItem.innerPackingQuantity = product.innerPackageQuantity;
    lineItem.unitOfSales = product.unitOfSale;
    lineItem.maxOrderQuanitity = product.maxOrderQuantity;
    
    IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
    quantitySelectionViewController.delgate = self;
    quantitySelectionViewController.product = lineItem;
    quantitySelectionViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:quantitySelectionViewController animated:NO completion:nil];

    

}

- (void)nonPharmaAddtocartWithModel:(IMProduct *)product
{
    IMLineItem *cellModel = [[IMLineItem alloc] init];
    cellModel.identifier = product.identifier;
    cellModel.name = product.name;
    cellModel.quantity = [[IMCartManager sharedManager] quantityOfCartLineItemWithVariantId:product.identifier];
    //cellModel.quantity = cellModel.quantity + 1;
    if(!cellModel.quantity)
    {
        cellModel.quantity = 1;
    }
    cellModel.quantity = MIN([product.maxOrderQuantity integerValue], cellModel.quantity );
    cellModel.innerPackingQuantity = product.innerPackageQuantity;
    cellModel.unitOfSales = product.unitOfSale;
    cellModel.maxOrderQuanitity = product.maxOrderQuantity;
    
//    [self showActivityIndicatorView];
//    
//    [[IMCartManager sharedManager] updateCartItems:@[cellModel] withCompletion:^(IMCart* cart, NSError *error) {
//        [self hideActivityIndicatorView];
//        if(!error)
//        {
//            [IMCartManager sharedManager].currentCart = cart;
//          
//            if([self.delegate respondsToSelector:@selector(didUpdateCartButton)])
//            {
//                [self.delegate didUpdateCartButton];
//            }
//
//            UIAlertView *addCartAlert = [[UIAlertView alloc] initWithTitle:@"" message:IMCartAdditionMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//            [addCartAlert show];
//            [self performSelector:@selector(dissmissAlert:) withObject:addCartAlert afterDelay:ALERT_FADE_DELAY];
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
//    }];
//
    
    IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
    quantitySelectionViewController.delgate = self;
    quantitySelectionViewController.product = cellModel;
    quantitySelectionViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:quantitySelectionViewController animated:NO completion:nil];
}



- (void)quantitySelectionController:(IMQuantitySelectionViewController *)quantitySelectionController didFinishWithWithQuanity:(NSInteger)quanity
{
    IMLineItem* cartModel = quantitySelectionController.product;
    cartModel.quantity = quanity;
    
    [self showActivityIndicatorView];
    
    [[IMCartManager sharedManager] updateCartItems:@[cartModel] withCompletion:^(IMCart* cart, NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            [[IMFacebookManager sharedManager] logFacebookAddToCartEventWithContentType:cartModel.name contentID:[cartModel.identifier stringValue] andCurrency:@"INR"];
            [IMCartManager sharedManager].currentCart = cart;
            
            if([self.delegate respondsToSelector:@selector(didUpdateCartButton)])
            {
                [self.delegate didUpdateCartButton];
            }
            UIAlertView *addCartAlert = [[UIAlertView alloc] initWithTitle:@"" message:IMCartAdditionMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [addCartAlert show];
            [self performSelector:@selector(dissmissAlert:) withObject:addCartAlert afterDelay:ALERT_FADE_DELAY];
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

-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    [self animateBadgeIcon];
}


/**
 @brief To handle scroll up and down action for hiding product count label
 @returns void
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView.panGestureRecognizer translationInView:scrollView].y < 0) {
//        NSLog(@"Downward");
        if([self.delegate respondsToSelector:@selector(didScrollTableViewDown:)])
        {
            [self.delegate didScrollTableViewDown:YES];
        }
    } else {
        // up
//        NSLog(@"Upward");
        if([self.delegate respondsToSelector:@selector(didScrollTableViewDown:)])
        {
            [self.delegate didScrollTableViewDown:NO];
        }

    }
    
}

//Uncomment for showing count label after scrolling is finished, irespective of up or down

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if([self.delegate respondsToSelector:@selector(didScrollTableViewDown:)])
//    {
//        [self.delegate didScrollTableViewDown:NO];
//    }
//}


- (CGFloat)tableViewHeight
{
    [self.tableView layoutIfNeeded];
    return [self.tableView contentSize].height;
}
@end


