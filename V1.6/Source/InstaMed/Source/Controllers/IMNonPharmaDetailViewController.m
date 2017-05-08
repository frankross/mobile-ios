 //
//  IMNonPharmaDetailViewController.m
//  InstaMed
//
//  Created by Suhail K on 28/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMNonPharmaDetailViewController.h"
#import "IMProductListViewController.h"
#import "IMKeyFeatureTableViewCell.h"
#import "IMRatingView.h"
#import "IMProduct.h"
#import "IMImageCollectionViewCell.h"
#import "IMPDPTextDetailViewController.h"
#import "IMVarient.h"
#import "IMMoreTableViewCell.h"
#import "IMPharmacyManager.h"
#import "IMCartManager.h"
#import "IMFacebookManager.h"
#import "IMAccountsManager.h"
#import "IMServerManager.h"
#import "IMBranchServiceManager.h"
#import "IMAppSettingsManager.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import "IMVarientSelectionViewController.h"
#import "IMQuantitySelectionViewController.h"
#import "IMNotifyMePhoneNumberViewController.h"
#import "IMNotifyMeSuccessViewController.h"

#import "IMConstants.h"

#define IM_VARIENT_CELL_HEIGHT 55
#define ALERT_FADE_DELAY 1
typedef enum
{
    IMVariantPrimary,
    IMVariantSecondary
}IMVariantType;

@interface IMNonPharmaDetailViewController ()<UIActionSheetDelegate,IMProductListViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate, IMVarientSelectionDelegate,IMQuantitySelectionViewControllerDelegate,IMNotifyMePhoneNumberViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *buttonPanelView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet UILabel *unitOfsaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *reorderDurationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *KeyFeatureTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *KeyFeatureTblHeightConstraint;
@property (weak, nonatomic) IBOutlet IMRatingView *ratingView1;
@property (weak, nonatomic) IBOutlet IMRatingView *ratingView2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageController;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
@property (weak, nonatomic) IBOutlet UITableView *varientTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *varientTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UITableView *specificationsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specificationsTableViewHeightConstraints;
@property (weak, nonatomic) IBOutlet UILabel *variantName;
@property (weak, nonatomic) IBOutlet UILabel *mrpLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *specifications;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manufacturerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitsTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *cashbackDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconBottomConstraint;



@property(nonatomic,strong) IMKeyFeatureTableViewCell* prototypeCell;
@property (strong, nonatomic) NSMutableArray *keyFeatureDataSource;
@property (strong, nonatomic) NSMutableArray *specificationsDataSource;
@property (strong, nonatomic) NSMutableArray *varientDataSource;
@property(nonatomic,strong) IMProductListViewController* productListViewController;
//ka added to keep track of currently loaded variant type
@property (strong, nonatomic) NSMutableArray *selectedVarients;
@property IMVariantType variantType;

@property(nonatomic) BOOL needToLoadDefaultProductImage;

- (IBAction)supportPressed:(id)sender;
- (IBAction)reorderDurationButtonPressed:(UIButton *)sender;
- (IBAction)informationPressed:(UITapGestureRecognizer *)sender;
- (IBAction)specificationPredded:(UITapGestureRecognizer *)sender;
- (IBAction)summaryPressed:(UITapGestureRecognizer *)sender;
- (IBAction)seeAllReviewPressed:(UITapGestureRecognizer *)sender;
- (IBAction)buyNowPressed:(id)sender;

@end

@implementation IMNonPharmaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Non_Pharma_Detail";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IMFlurry logEvent:IMNonPharMaVisitedEvent withParameters:@{}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IMFlurry endTimedEvent:IMNonPharMaVisitedEvent withParameters:@{}];
}


-(void)loadUI
{
    [super loadUI];
    self.scrollView.hidden = YES;
    self.buttonPanelView.hidden = YES;
    self.separatorView.hidden = YES;
    self.containerViewHeightConstraint.constant = 0;
    self.keyFeatureDataSource = [[NSMutableArray alloc] init];
    self.varientDataSource = [[NSMutableArray alloc] init];
    self.specificationsDataSource = [[NSMutableArray alloc] init];

    self.modelArray = [[NSMutableArray alloc] init];
    SET_CELL_CORER(self.buyNowButton, 8.0);
    [IMFunctionUtilities setBackgroundImage:self.buyNowButton withImageColor:APP_THEME_COLOR];
    
//    SET_FOR_YOU_CELL_BORDER(self.addToCartButton,[UIColor colorWithRed:9/255.0 green:47/255.0 blue:24/255.0 alpha:1],8.0);
    [IMFunctionUtilities setBackgroundImage:self.addToCartButton withImageColor:APP_THEME_COLOR];
    SET_CELL_CORER(self.addToCartButton, 8);

    [self updateCartButton];
    [self downloadFeed];
}

/**
 @brief To download feed
 @returns void
 */
-(void)downloadFeed
{
    
    [self showActivityIndicatorView];
    
    [[IMPharmacyManager sharedManager] fetchProductDetailWithId:self.selectedModel.identifier withCompletion:^(IMProduct *product, NSError *error) {
        if(!error)
        {
            [self hideActivityIndicatorView];
            if(product)
            {
                self.selectedModel = product;
                [self.modelArray addObject:product];
                [self updateUI];
            }
        }
        else
        {
            [self handleError:error withRetryStatus:NO];
        }
    }];
}

/**
 @brief To update UI after feed downloding
 @returns void
 */
- (void)updateUI
{
    self.scrollView.hidden = NO;
    self.buttonPanelView.hidden = NO;
    self.separatorView.hidden = NO;
    self.imageCollectionViewHeightConstraint.constant =  (11.0/17.0)*self.view.frame.size.width;
    self.KeyFeatureTableView.delegate = self;
    self.KeyFeatureTableView.dataSource = self;
    self.varientTableView.dataSource = self;
    self.varientTableView.delegate = self;
    self.specificationsTableView.dataSource = self;
    self.specificationsTableView.delegate = self;
     IMProduct* product = (IMProduct*)self.selectedModel;
    //ka initalize currently shown primary and secondary variants
    [self initlizeSelectedVarients];
    
    self.availableLabel.text = product.inventoryLabel;
    if(product.variantDescription != nil)
    {
        NSAttributedString *string = [self attributedStringForString:product.variantDescription];
        self.descriptionsLabel.attributedText = string;
    }
    else
    {
        NSAttributedString *string = [self attributedStringForString:@""];
        self.descriptionsLabel.attributedText = string;
    }
  
    //product.brand = @"manufacturer";
    self.manufacturerLabel.text =[NSString stringWithFormat:@"By %@",product.brand];
    
    if ([product.brand isEqualToString:@""] || !product.brand)
    {
        self.manufacturerTopConstraint.constant = 0.0f;
    }
    else
    {
        self.manufacturerTopConstraint.constant = 3.0f;
    }
    
    self.variantName.text = product.name;

    self.salesPriceLabel.text = [NSString  stringWithFormat:@"₹ %@", product.sellingPrice];
    self.unitOfsaleLabel.text = product.innerPackageQuantity;
    
    if (!product.innerPackageQuantity || [product.innerPackageQuantity isEqualToString:@""])
    {
        self.unitsTopConstraint.constant = 0.0f;
    }
    else
    {
        self.unitsTopConstraint.constant = 8.0f;
    }

    self.salesPriceLabel.text = [NSString  stringWithFormat:@"₹ %@", product.sellingPrice];
    
//    if(product.discountPercentDouble.doubleValue != 0.0)
    if([product.discountPercent isEqualToString:@"0.0"]|| [product.discountPercent isEqualToString:@"0"])
    {
        self.discountLabel.text = @"";
        self.mrpLabel.text = @"";
    }
    else
    {
        self.discountLabel.text =  [NSString stringWithFormat:@"%@%% off", product.formattedDiscountPercent];
        self.mrpLabel.text = [NSString  stringWithFormat:@"₹ %@", product.mrp];
        self.salesPriceLabel.text = [NSString  stringWithFormat:@"₹ %@", product.promotionalPrice];
    }
    
    if(product.isCashBackAvailable && product.cashbackDescription)
    {
        self.cashbackDescriptionLabel.text = product.cashbackDescription;
        
    }
    else
    {
        self.cashbackDescriptionLabel.text = @"";
        self.cashbackIconBottomConstraint.constant = 0;
        self.cashbackIconHeightConstraint.constant = 0;
    }

    self.varientDataSource = self.selectedVarients;;
    self.keyFeatureDataSource = product.keyFeatures;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    
    [self.KeyFeatureTableView reloadData];
    [self.varientTableView reloadData];
    [self.specificationsTableView reloadData];
    
    CGFloat heightKeyFeature = self.KeyFeatureTableView.tableHeaderView.frame.size.height + self.KeyFeatureTableView.tableFooterView.frame.size.height + 21;
    
    for(NSInteger index=0;index<[self.KeyFeatureTableView numberOfRowsInSection:0];index++)
    {
        heightKeyFeature += [self tableView:self.KeyFeatureTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    if(self.keyFeatureDataSource.count == 0)
    {
        heightKeyFeature = 0;
    }
    self.KeyFeatureTblHeightConstraint.constant = heightKeyFeature ;
    
    CGFloat heightSpecifications = self.KeyFeatureTableView.tableHeaderView.frame.size.height + self.KeyFeatureTableView.tableFooterView.frame.size.height + 21;
    
    for(NSInteger index=0;index<[self.specificationsTableView numberOfRowsInSection:0];index++)
    {
        heightSpecifications += [self tableView:self.specificationsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    if(self.specificationsDataSource.count == 0)
    {
        heightSpecifications = 0;
    }
    self.specificationsTableViewHeightConstraints.constant = heightSpecifications ;
    
    self.varientTableViewHeightConstraint.constant = ((IMProduct *)self.selectedModel).varients.count * IM_VARIENT_CELL_HEIGHT;

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    if(((IMProduct *)self.selectedModel).imageURRLs.count <= 1 || ((IMProduct *)self.selectedModel).imageURRLs == nil)
    {
        self.imagePageController.hidden = YES;
    }
    else
    {
        self.imagePageController.numberOfPages = ((IMProduct *)self.selectedModel).imageURRLs.count;
        self.imagePageController.hidden = NO;
    }
    
    self.addToCartButton.enabled = product.available;
    if(product.isNotifyMe && !product.available)
    {
        
        self.addToCartButton.enabled = true;
        [self.addToCartButton setTitle:@"Notify me" forState:UIControlStateNormal];
    }

}


#pragma mark - CollectionView - 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // if no images then return 1 and display placeholder image
    if (((IMProduct *) self.selectedModel).imageURRLs.count == 0) {
        self.needToLoadDefaultProductImage = YES;
        return 1;
    }
    return ((IMProduct *) self.selectedModel).imageURRLs.count;
}

 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMImageCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDPImageCell" forIndexPath:indexPath];

    
    UIImage *placeHolderImage = [UIImage imageNamed:IMProductPlaceholderPDPName];
    if (self.needToLoadDefaultProductImage) {
        [collectionViewCell.imgView setImage:placeHolderImage];
    }
    else{
        NSURL *imageUrl = [NSURL URLWithString:[((IMProduct *) self.selectedModel).imageURRLs objectAtIndex:indexPath.row]];
        [collectionViewCell.imgView setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:placeHolderImage usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:nil failure:nil];
    }
    return collectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size = CGSizeMake(self.view.frame.size.width, (11.0/17.0)*self.view.frame.size.width);
    return size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.imagePageController.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
}

#pragma mark -TableView -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.varientTableView)
    {
        return ((IMProduct *)self.selectedModel).varients.count;

    }
    else if(tableView == self.KeyFeatureTableView)
    {
        return ((IMProduct *)self.selectedModel).keyFeatures.count;
    }
    else
    {
        return ((IMProduct *)self.selectedModel).specifications.count;

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.KeyFeatureTableView)
    {
        IMKeyFeatureTableViewCell *cell = (IMKeyFeatureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"KeyFeatureTableCell" forIndexPath:indexPath];
        cell.titleLabel.text = [((IMProduct *) self.selectedModel).keyFeatures objectAtIndex:indexPath.row];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
    else if(tableView == self.specificationsTableView)
    {
        IMKeyFeatureTableViewCell *cell = (IMKeyFeatureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"KeyFeatureTableCell" forIndexPath:indexPath];
        cell.titleLabel.text = [((IMProduct *) self.selectedModel).specifications objectAtIndex:indexPath.row];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
    else
    {
        IMMoreTableViewCell *cell = (IMMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IMVarientCell" forIndexPath:indexPath];
        IMVarientValue *varient = [self.selectedVarients objectAtIndex:indexPath.row];
        
        cell.titleLAbel.text = varient.attribute;
        cell.subTitleLabel.text = varient.valueName;
        cell.disclosure.hidden = YES;
        // hide disclosure icon if no extra variants
        IMProduct* product = (IMProduct*)self.selectedModel;
        BOOL hasExtraVariants = NO;
        switch (indexPath.row) {
            case 0:
                hasExtraVariants = product.hasExtraPrimaryVarients;
                break;
            case 1:
                hasExtraVariants = product.hasExtraSecondaryVarients;
                break;
            default:
                break;
        }
        if (hasExtraVariants) {
            cell.disclosure.hidden = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.varientTableView)
    {
        IMProduct* product = (IMProduct*)self.selectedModel;
        BOOL canLoadVariantSelectionPopup = NO;
        
        switch (indexPath.row) {
            case 0:
                canLoadVariantSelectionPopup = product.hasExtraPrimaryVarients;
                break;
            case 1:
                canLoadVariantSelectionPopup = product.hasExtraSecondaryVarients;
                break;
            default:
                break;
        }
        if (canLoadVariantSelectionPopup) {
            [self loadVariantSelectionPopupForIndex:indexPath.row];
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == self.KeyFeatureTableView) || (tableView == self.specificationsTableView)) {
        if(!self.prototypeCell)
        {
            self.prototypeCell = [self.KeyFeatureTableView dequeueReusableCellWithIdentifier:@"KeyFeatureTableCell"];
        }
        
        
        //address.tag = @"Home";
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
      
        self.prototypeCell.bounds = CGRectMake(0, 0, self.KeyFeatureTableView.frame.size.width, self.prototypeCell.bounds.size.height);
        
        [self.prototypeCell setNeedsLayout];
        [self.prototypeCell layoutIfNeeded];
        
        CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"cell height = %lf",height);
        
        return height;
    }
    else
    {
        return IM_VARIENT_CELL_HEIGHT;
    }
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (void)configureCell:(IMKeyFeatureTableViewCell *)keyCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *keyFeature = [((IMProduct *) self.selectedModel).keyFeatures objectAtIndex:indexPath.row];
    //address.tag = @"Home";
    keyCell.titleLabel.attributedText = [self attributedStringForString:keyFeature];
}
#pragma mark - Actions -

- (IBAction)reorderDurationButtonPressed:(UIButton *)sender
{
    UIActionSheet *reOrderDurationActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"One time only",@"Now & every 30 days",@"Now & every 60 days", nil];
    [reOrderDurationActionSheet showInView:self.view];
}

- (IBAction)informationPressed:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"InformationDetailSegue" sender:nil];
}

- (IBAction)specificationPredded:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"SpecificationDetailSegue" sender:nil];

}

- (IBAction)summaryPressed:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"SummaryDetailSegue" sender:nil];

}

- (IBAction)seeAllReviewPressed:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"AllReviewDetailSegue" sender:nil];

}

#pragma mark - Action sheet delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    switch (buttonIndex) {
//        case 0:
//            [self.reorderDurationButton setTitle:@"One time only" forState:UIControlStateNormal];
//            break;
//        case 1:
//            [self.reorderDurationButton setTitle:@"Now & every 30 days" forState:UIControlStateNormal];
//            break;
//        case 2:
//            [self.reorderDurationButton setTitle:@"Now & every 60 days" forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
}

#pragma mark - IMVarientSelctionDelegate methods -

- (void)didSelectVarient:(IMVarientSelction *)varient
{
    NSLog(@"selected varient %@= %@",varient,varient.selectedVarient);
    if (self.variantType == IMVariantPrimary) {
        [self hanldePrimaryVariantselection:varient];
    }
    else{
        [self hanldeSecondaryVariantselection:varient];
    }
}

- (void)hanldePrimaryVariantselection:(IMVarientSelction *)varient
{
    /*
     on primary variant selection
     1) Check if currently selected secondary variant is present in the primary variants's supported values
     2) if present fetch the variant info for the combination
     3) if not present mark first item in the secondary list as selected and display overlay popup to select secondary variant
     */
    IMProduct* product = (IMProduct*)self.selectedModel;
    NSArray *secondayVarientsForselectedPrimary = product.otherVarients[varient.selectedVarient.valueName];
    NSMutableArray *productVarientvalues = self.selectedVarients;
    NSLog(@"productVarientvalues = %@",productVarientvalues);
    NSLog(@"secondayVarientsForselectedPrimary = %@",secondayVarientsForselectedPrimary);
    IMVarientValue* primaryVarientValue = nil;
    IMVarientValue* secondaryVarientValue = nil;
    IMVarientValue* selectedPrimaryVariant = varient.selectedVarient;
    
    if (productVarientvalues != nil && productVarientvalues.count > 0) {
        primaryVarientValue = productVarientvalues[0];
        
        if (productVarientvalues.count > 1) {
            secondaryVarientValue = productVarientvalues[1];
        }
    }
    // user has not changed the selection
    if ([selectedPrimaryVariant.valueName isEqualToString:primaryVarientValue.valueName]) {
        return;
    }
    else{
        // change the value of product primary variant to selected variant value
        primaryVarientValue.valueName = selectedPrimaryVariant.valueName;
    }
    NSLog(@"newly selected variant = %@",primaryVarientValue);
    // product may or may not have secondary variant
    if (secondaryVarientValue != nil) {
        IMVarientValue *matchingSecondaryvariant = nil;
        IMVarientValue *firstSecondaryvariant = nil;
        for (IMVarientValue *secVarValue in secondayVarientsForselectedPrimary) {
            if ([secondaryVarientValue.valueName isEqualToString:secVarValue.secondaryValue]) {
                matchingSecondaryvariant = secVarValue;
                break;
            }
            // kep track of first item in the list
            NSUInteger index = [secondayVarientsForselectedPrimary indexOfObject:secVarValue];
            if (index == 0) {
                firstSecondaryvariant = secVarValue;
            }
        }
        // currently selected secondary varient is supported for the primary so just reload product info
        if (matchingSecondaryvariant != nil) {
            // reload variant table view
            [self.varientTableView reloadData];
            NSLog(@"matching primary %@",matchingSecondaryvariant);
            
            [self reloadProductInfoForVariant:matchingSecondaryvariant];
        }
        // remove the currently selected secondary variant from the table cell and display secondary variant selection popup
        else{
            // mark first item as selected
            secondaryVarientValue.isSelected = YES;
            secondaryVarientValue.isSupported = YES;
            secondaryVarientValue.valueName = firstSecondaryvariant.secondaryValue;
            [productVarientvalues replaceObjectAtIndex:1 withObject:secondaryVarientValue];
            // reload variant table view
            [self.varientTableView reloadData];
//            [self showAlertWithTitle:[NSString stringWithFormat:IMSelectSecondaryMessage,secondaryVarientValue.attribute] andMessage:@""];
                        [self loadVariantSelectionPopupForIndex:1];
        }
    }
    else{
        // reload variant table view
        [self.varientTableView reloadData];
        IMVarientValue *matchingPrimaryvariant = nil;
        NSLog(@"secondayVarientsForselectedPrimary %@",secondayVarientsForselectedPrimary);
        
        for (IMVarientValue *primaryVarValue in secondayVarientsForselectedPrimary) {
            if ([primaryVarientValue.valueName isEqualToString:primaryVarValue.primaryValue]) {
                matchingPrimaryvariant = primaryVarValue;
                break;
            }
        }
        NSLog(@"matching primary %@",matchingPrimaryvariant);
        // reload product info
        [self reloadProductInfoForVariant:matchingPrimaryvariant];
    }
    
}

- (void)hanldeSecondaryVariantselection:(IMVarientSelction *)varient
{
    /*
     on secondary variant selection
     1) reload product info
     */
    NSArray *productVarientvalues = self.selectedVarients;
    NSLog(@"productVarientvalues = %@",productVarientvalues);
    IMVarientValue* primaryVarientValue = nil;
    IMVarientValue* secondaryVarientValue = nil;
    IMVarientValue* selectedSecondaryVariant = varient.selectedVarient;
    
    if (productVarientvalues != nil && productVarientvalues.count > 0) {
        primaryVarientValue = productVarientvalues[0];
        if (productVarientvalues.count > 1) {
            secondaryVarientValue = productVarientvalues[1];
            // change the value of product primary variant to selected variant value
            secondaryVarientValue.valueName = selectedSecondaryVariant.valueName;
            // get variant id
            IMProduct* product = (IMProduct*)self.selectedModel;
            NSArray *secondayVarientsForSelectedPrimary = product.otherVarients[primaryVarientValue.valueName];
            
            IMVarientValue *matchingSecondaryvariant = nil;
            for (IMVarientValue *secVarValue in secondayVarientsForSelectedPrimary) {
                if ([secondaryVarientValue.valueName isEqualToString:secVarValue.secondaryValue]) {
                    matchingSecondaryvariant = secVarValue;
                    break;
                }
            }
            NSLog(@"matching primary %@",matchingSecondaryvariant);
            // reload variant table view
            [self.varientTableView reloadData];
            [self reloadProductInfoForVariant:matchingSecondaryvariant];
        }
    }
    
    NSLog(@"newly selected variant = %@",selectedSecondaryVariant);
    
}

- (void)reloadProductInfoForVariant:(IMVarientValue *)varient
{
    NSLog(@"mreloadProductInfoForVariant %@",varient);
    NSLog(@"mreloadProductInfoForVariant id = %@",varient.varientProductId);
    NSLog(@"current product id id = %@",self.selectedModel.identifier);
    // if same variant is reselected, then do not reload the product info
    if (varient.varientProductId != nil &&
        varient.varientProductId ==  self.selectedModel.identifier) {
        return;
    }
    [self showActivityIndicatorView];

    [[IMPharmacyManager sharedManager] fetchProductDetailWithId:varient.varientProductId withCompletion:^(IMProduct *product, NSError *error) {
        if(!error)
        {
            [self hideActivityIndicatorView];
            if(product)
            {
                self.selectedModel = product;
                [self.modelArray addObject:product];
                //product.imageURRLs = images;
                [self updateUI];
            }
        }
        else
        {
            [self handleError:error withRetryStatus:NO];
        }
    }];
}

- (void)loadVariantSelectionPopupForIndex:(NSInteger) index
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IMVarientSelectionViewController* varientSelectionVC = [storyboard instantiateViewControllerWithIdentifier:@"IMVarientSelectionVC"];
    IMProduct* product  = (IMProduct*)self.selectedModel;
    varientSelectionVC.product = product;
    varientSelectionVC.delegate = self;
    varientSelectionVC.selectedVariants = self.selectedVarients;
    
    // first cell display primary variation theme values
    if (index == 0) {
        varientSelectionVC.isPrimary = YES;
        self.variantType = IMVariantPrimary;
    }
    else if (index == 1){
        self.variantType = IMVariantSecondary;
    }
    
    varientSelectionVC.product = product;
    
    [self.navigationController addChildViewController:varientSelectionVC];
    [self.navigationController.view addSubview:varientSelectionVC.view];
    [self didMoveToParentViewController:self.navigationController];
    
}

- (void)initlizeSelectedVarients
{
    [self.selectedVarients removeAllObjects];
    self.selectedVarients = [[NSMutableArray alloc]init];
    IMProduct* product  = (IMProduct*)self.selectedModel;
    NSArray *productVarientvalues = product.varients;
    NSLog(@"productVarientvalues = %@",productVarientvalues);
    IMVarient *productPrimaryVarient = nil;
    IMVarient *productSecondaryVarient = nil;
    IMVarientValue* primaryVarientValue = nil;
    IMVarientValue* secondaryVarientValue = nil;
    
    if (productVarientvalues != nil && productVarientvalues.count > 0) {
        productPrimaryVarient = productVarientvalues[0];
        
        if (productVarientvalues.count > 1) {
            productSecondaryVarient = productVarientvalues[1];
        }
    }
    if (productPrimaryVarient != nil) {
        primaryVarientValue = [[IMVarientValue alloc]init];
        primaryVarientValue.valueName = productPrimaryVarient.value;
        primaryVarientValue.attribute = productPrimaryVarient.attribute;
        primaryVarientValue.isSelected = YES;
        primaryVarientValue.isSupported = YES;
        [self.selectedVarients addObject:primaryVarientValue];
    }
    if (productSecondaryVarient != nil) {
        secondaryVarientValue = [[IMVarientValue alloc]init];
        secondaryVarientValue.valueName = productSecondaryVarient.value;
        secondaryVarientValue.attribute = productSecondaryVarient.attribute;
        secondaryVarientValue.isSelected = YES;
        secondaryVarientValue.isSupported = YES;
        [self.selectedVarients addObject:secondaryVarientValue];
    }
}


#pragma mark - Navigation -

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    IMProduct* product  = (IMProduct*)self.selectedModel;
    
    if([segue.identifier isEqualToString:@"YouMayLikeSegue"])
    {
        IMProductListViewController *productListVC = (IMProductListViewController *) segue.destinationViewController;
        productListVC.delegate = self;
//        productListVC.dontLoadProductListOnScreenVisit = YES;
        productListVC.productListType = IMTopSellingHomeScreen;
        self.productListViewController = productListVC;
    }
    if([segue.identifier isEqualToString:@"IMInformationSegue"])
    {
        IMPDPTextDetailViewController *PDPTextVC = (IMPDPTextDetailViewController *) segue.destinationViewController;
        PDPTextVC.title =IMDescriptions;
        PDPTextVC.information = product.variantDescription;
        PDPTextVC.infoType = IMOtherInfo;
    }
    if([segue.identifier isEqualToString:@"IMSpecificationSegue"])
    {
        IMPDPTextDetailViewController *PDPTextVC = (IMPDPTextDetailViewController *) segue.destinationViewController;
        PDPTextVC.title = IMSpecifications;
        PDPTextVC.information = product.specifications.firstObject;
        PDPTextVC.infoType = IMOtherInfo;

    }
//    if([segue.identifier isEqualToString:@"IMSummarySegue"])
//    {
//        IMPDPTextDetailViewController *PDPTextVC = (IMPDPTextDetailViewController *) segue.destinationViewController;
//        PDPTextVC.title = @"SUMMARY";
//    }
//
}


#pragma mark - IMProductListViewControllerDelegate


-(void)didLoadTableViewWithTableViewHeight:(CGFloat)height andTotalProductCount:(NSInteger)totalProductCount andFacetInfo:(NSDictionary *)facetInfo
{
    self.containerViewHeightConstraint.constant = 0;
}

- (IBAction)addtoCartPressed:(id)sender {
    
    
    IMProduct* product = (IMProduct*)self.selectedModel;
    
    if(product.available)
    {
        [IMFlurry logEvent:IMAddToCartEvent withParameters:@{}];
        
        //IMProduct* product = (IMProduct*)self.selectedModel;
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
        
        
        IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
        quantitySelectionViewController.delgate = self;
        quantitySelectionViewController.product = cellModel;
        quantitySelectionViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:quantitySelectionViewController animated:NO completion:nil];
    }
    else
    {
        
        if([[IMAccountsManager sharedManager] userID])
        {
            [IMFlurry logEvent:IMNotifyMeTapped withParameters:@{@"user_type": @"Registered user"}];
            [self notifytheCurrentLoggedInUser];
        }
        else
        {
            [IMFlurry logEvent:IMNotifyMeTapped withParameters:@{@"user_type": @"Unregistered user"}];
            IMNotifyMePhoneNumberViewController *notifyMePhoneNumberViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IMNotifyMePhoneNumberViewController"];
            notifyMePhoneNumberViewController.delgate = self;
            notifyMePhoneNumberViewController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:notifyMePhoneNumberViewController animated:YES completion:nil];
        }

    }

    
    

}

- (void) notifytheCurrentLoggedInUser
{
    NSString  *userID = [[IMAccountsManager sharedManager] userID];
    NSDictionary *userDictionary = @{@"user_id" : userID};
    
    [self showActivityIndicatorView];
    [[IMPharmacyManager sharedManager] notifyUserForProductWithID:self.selectedModel.identifier andUserDictionary:userDictionary withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            [IMFlurry logEvent:IMNotifyMeConfirmationTapped withParameters:@{}];
            [self showNotifyThankYouScreen];
        }
    }];
    
}

- (void)showNotifyThankYouScreen
{
    IMNotifyMeSuccessViewController *thankYouScreen =  [self.storyboard instantiateViewControllerWithIdentifier:@"IMNotifyMeSuccessViewController"];

    thankYouScreen.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:thankYouScreen animated:YES completion:nil];
}

-(void)notifyTheUserWithPhoneNumber:(NSString *)phoneNumber
{
   
    NSDictionary *userDictionary = @{@"phone_number" : phoneNumber};
    
    [self showActivityIndicatorView];
    [[IMPharmacyManager sharedManager] notifyUserForProductWithID:self.selectedModel.identifier andUserDictionary:userDictionary withCompletion:^(NSError *error) {
        [self hideActivityIndicatorView];
        if(!error)
        {
            [IMFlurry logEvent:IMNotifyMeConfirmationTapped withParameters:@{}];
            [self showNotifyThankYouScreen];
        }
        else if(error.userInfo[IMMessage])
        {
            [self showAlertWithTitle:@"" andMessage:error.userInfo[IMMessage]];
        }
        else
        {
            [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
    }];
}

-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    [self animateBadgeIcon];

}

- (IBAction)buyNowPressed:(id)sender
{
    
}
/**
 @brief To handle support button action (change tab to support)
 @returns void
 */
- (IBAction)supportPressed:(id)sender
{
    [self.tabBarController setSelectedIndex:3];
}

- (IBAction)pressedShareButton:(UIButton *)sender
{
    IMProduct* product = (IMProduct*)self.selectedModel;
    
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMPDPShareButtonTapped withParameters:@{}];

        [IMBranchServiceManager shareProduct:product ofType:@"Non pharma" withCompletion:nil];
    }
    else
    {
        [self showNoNetworkAlert];
    }

}


-(void)didUpdateCartButton
{
    [self updateCartButton];
    [self animateBadgeIcon];
}

-(void)quantitySelectionController:(IMQuantitySelectionViewController *)quantitySelectionController didFinishWithWithQuanity:(NSInteger)quanity
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
            [self updateCartButton];
            //If animation required
            //            [self animateBadgeIcon];
            
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
                [self showAlertWithTitle:IMError andMessage:IMNoNetworkErrorMessage];
        }
        
    }];
}

@end
