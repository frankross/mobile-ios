//
//  IMPharmaDetailViewController.m
//  InstaMed
//
//  Created by Arjuna on 09/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#define ALERT_FADE_DELAY 1

#import "IMPharmaDetailViewController.h"
#import "IMImageCollectionViewCell.h"
#import "IMFacebookManager.h"
#import "IMQuantitySelectionViewController.h"
#import "IMNotifyMePhoneNumberViewController.h"
#import "IMNotifyMeSuccessViewController.h"
#import "IMPharmacyManager.h"
#import "IMPDPTextDetailViewController.h"
#import "IMCartManager.h"
#import "IMAppSettingsManager.h"
#import "IMBranchServiceManager.h"

#import "IMAccountsManager.h"
#import "IMServerManager.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"



#define IPhoneBasicInfoContainerHeight 674
#define IPhoneMoreInfoContainerHeight 605
#define IPhoneCOllectionViewCellHeight 240


@interface IMPharmaDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIActionSheetDelegate,IMQuantitySelectionViewControllerDelegate,IMNotifyMePhoneNumberViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *buttonPanelView;
@property (weak,nonatomic) UIViewController* selectedViewController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (weak, nonatomic) IBOutlet UIButton *reorderDurationButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manufacturerTopConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Main detail
@property (weak, nonatomic) IBOutlet UILabel *variantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *packingUnitQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mrpLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicineTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIButton *attributesButton;
@property (weak, nonatomic) IBOutlet UIButton *basicInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackIconBottomConstraint;

//Attributes
@property (weak, nonatomic) IBOutlet UILabel *activeIngridientLabel;
@property (weak, nonatomic) IBOutlet UILabel *flavourNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *formLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeOfAdminLabel;
@property (weak, nonatomic) IBOutlet UILabel *innerPackingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *innerPackingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitOfSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *minSaleQtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prescriptionRequiredLabel;

//Basic Info
@property (weak, nonatomic) IBOutlet UILabel *whyPrescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *howItShouldBeTakenLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendedDosageLabel;

//More Info
@property (weak, nonatomic) IBOutlet UILabel *whenNotToTakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningAndPrecautionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sideEffectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherPrecautionsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rxImageView;
@property(nonatomic) BOOL needToLoadDefaultProductImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeingredientsDisclosureImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *activeIncridientDisclosureButton;

- (IBAction)supportPressed:(id)sender;

@end

@implementation IMPharmaDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Pharma_Detail";

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self updateUI];
    [IMFlurry logEvent:IMPharMaVisitedEvent withParameters:@{}];
}

-(void)loadUI
{
    [super loadUI];
    self.scrollView.hidden = YES;
    self.buttonPanelView.hidden = YES;
   // [self.availableLabel setHidden:YES];
    
    if(self.detailType == IMProductDetail)
    {
        SET_CELL_CORER(self.buyNowButton, 8);
        [IMFunctionUtilities setBackgroundImage:self.buyNowButton withImageColor:APP_THEME_COLOR];
        
//        SET_FOR_YOU_CELL_BORDER(self.addToCartButton,[UIColor colorWithRed:9/255.0 green:47/255.0 blue:24/255.0 alpha:1],8.0);
        
        SET_CELL_CORER(self.addToCartButton, 8);
        
        [IMFunctionUtilities setBackgroundImage:self.addToCartButton withImageColor:APP_THEME_COLOR];        

        [self downloadFeed];
    }
    else
    {
        [self updateUI];
    }
    
}

-(void)downloadFeed
{
  
//    NSMutableArray *images = [[NSMutableArray alloc] initWithObjects:@"PDPImg1",@"PDPImg2",@"PDPImg3",@"PDPImg2", nil];
//    IMProduct *product = [[IMProduct alloc]init];
//    product.imageURRLs = images;

    [self showActivityIndicatorView];
    
    [[IMPharmacyManager sharedManager] fetchProductDetailWithId:self.product.identifier withCompletion:^(IMProduct *product, NSError *error) {
         [self hideActivityIndicatorView];
        if(!error)
        {
            self.product = product;
            //product.imageURRLs = images;
            [self updateUI];
        }
        else
        {
            [self handleError:error withRetryStatus:NO];

        }
    }];
}


//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    //self.activeIngridientLabel.preferredMaxLayoutWidth = self.activeIngridientLabel.bounds.size.width;
//   // [self.containerView layoutIfNeeded];
//    
//}


- (void)updateUI
{
    self.scrollView.hidden = NO;
    self.buttonPanelView.hidden = NO;

    self.variantNameLabel.text = self.product.name;
    self.manufacturerLabel.text = self.product.manufacturer;
    if ([self.product.manufacturer isEqualToString:@""] || !self.product.manufacturer)
    {
        self.manufacturerTopConstraint.constant = 0.0f;
    }
    else
    {
         self.manufacturerTopConstraint.constant = 5.0f;
    }
    if(self.product.thumbnailImageURL != ((id)[NSNull null]))
    {
        [self.iconImageView setImageWithURL:[NSURL URLWithString:self.product.thumbnailImageURL]
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }

    self.prescriptionRequiredLabel.hidden = !self.product.prescriptionRequired;
    self.rxImageView.hidden = !self.product.prescriptionRequired;
    
    self.salesPriceLabel.text = [NSString  stringWithFormat:@"₹ %@",self.product.sellingPrice];
    self.packingUnitQuantityLabel.text = [NSString stringWithFormat:@"%@ of %@",self.product.outerPackageQuantity,self.product.innerPackageQuantity];
   
    self.availableLabel.text = self.product.inventoryLabel;
    
//    if(self.product.discountPercentDouble.doubleValue != 0.0)
    if([self.product.discountPercent isEqualToString:@"0.0"] ||[self.product.discountPercent isEqualToString:@"0"] )
    {
        self.discountLabel.text = @"";
        self.mrpLabel.text = @"";
    }
    else
    {
        self.discountLabel.text =  [NSString stringWithFormat:@"%@%% off", self.product.formattedDiscountPercent];
        self.mrpLabel.text = [NSString  stringWithFormat:@"₹ %@", self.product.mrp];
        self.salesPriceLabel.text = [NSString  stringWithFormat:@"₹ %@", self.product.promotionalPrice];
    }
    
    if(self.product.isCashBackAvailable && self.product.cashbackDescription)
    {
        self.cashbackDescriptionLabel.text = self.product.cashbackDescription;
        
    }
    else
    {
        self.cashbackDescriptionLabel.text = @"";
        self.cashbackIconBottomConstraint.constant = 0;
        self.cashbackIconHeightConstraint.constant = 0;
    }

    if(self.detailType == IMProductDetail)
    {
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        self.imageCollectionViewHeightConstraint.constant =  (11.0/17.0)*self.view.frame.size.width;

        
        if(self.product.imageURRLs.count <= 1 || self.product.imageURRLs == nil)
        {
            self.imagePageControl.hidden = YES;
        }
        else
        {
            self.imagePageControl.numberOfPages = self.product.imageURRLs.count;
            self.imagePageControl.hidden = NO;
        }
        [self.collectionView reloadData];
        self.basicInfoButton.selected = YES;
        
        self.addToCartButton.enabled = self.product.available;
        if(self.product.isNotifyMe && !self.product.available)
        {

            self.addToCartButton.enabled = true;
            [self.addToCartButton setTitle:@"Notify me" forState:UIControlStateNormal];
        }
        
        
        [self performSegueWithIdentifier:@"basicInfoSegue" sender:nil];
    }
    else if(self.detailType == IMAttrbutes)
    {
       [self updateUIForAttrbutes];
        [self.view layoutIfNeeded];
        //((IMPharmaDetailViewController*)self.parentViewController).containerViewHeightConstraint.constant = self.containerView.bounds.size.height;
        [((IMPharmaDetailViewController*)self.parentViewController).containerView layoutIfNeeded];
        
    }
    else if(self.detailType == IMBasicInfo)
    {
         [self updateUIForBasicInfo];
//        [self.view layoutIfNeeded];

//        ((IMPharmaDetailViewController*)self.parentViewController).containerViewHeightConstraint.constant = IPhoneBasicInfoContainerHeight;
        [((IMPharmaDetailViewController*)self.parentViewController).containerView layoutIfNeeded];

    }
    else if(self.detailType == IMMoreInfo)
    {
        [self updateUIForMoreInfo];
        [self.view layoutIfNeeded];
        //((IMPharmaDetailViewController*)self.parentViewController).containerViewHeightConstraint.constant = IPhoneMoreInfoContainerHeight;
        [((IMPharmaDetailViewController*)self.parentViewController).containerView layoutIfNeeded];
    }
    if(self.product.hasMultipleIngredients)
    {
        self.activeingredientsDisclosureImageWidthConstraint.constant = 44;
        self.activeIncridientDisclosureButton.hidden = NO;
    }
    else
    {
        self.activeingredientsDisclosureImageWidthConstraint.constant = 0;
        self.activeIncridientDisclosureButton.hidden = YES;

    }
}

#pragma mark - CollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // if no images then return 1 and display placeholder image
    if (self.product.imageURRLs.count == 0) {
        self.needToLoadDefaultProductImage = YES;
        return 1;
    }
    return self.product.imageURRLs.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMImageCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDPImageCell" forIndexPath:indexPath];
   // collectionViewCell.imgView.image = [UIImage imageNamed:[self.product.imageURRLs objectAtIndex:indexPath.row]];
    
//    [collectionViewCell.imgView setImageWithURL:[NSURL URLWithString:[self.product.imageURRLs objectAtIndex:indexPath.row]]
//   usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIImage *placeHolderImage = [UIImage imageNamed:IMProductPlaceholderPDPName];
    if (self.needToLoadDefaultProductImage) {
        [collectionViewCell.imgView setImage:placeHolderImage];
    }
    else{
        NSURL *imageUrl = [NSURL URLWithString:[self.product.imageURRLs objectAtIndex:indexPath.row]];
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
    self.imagePageControl.currentPage = [[[self.collectionView indexPathsForVisibleItems] firstObject] row];
}

#pragma mark - Actions -

- (IBAction)reorderDurationButtonPressed:(UIButton *)sender
{
//    UIActionSheet *reOrderDurationActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"One time only",@"Now & every 30 days",@"Now & every 60 days", nil];
//    [reOrderDurationActionSheet showInView:self.view];
}

- (IBAction)segmentControlClicked:(UIButton*)sender
{
    
    self.attributesButton.selected = NO;
    self.basicInfoButton.selected = NO;
    self.moreInfoButton.selected = NO;
    
    sender.selected = YES;
    
        if( sender.tag == 0)
        {
            [self performSegueWithIdentifier:@"attributeSegue" sender:nil];
        }
        else if(sender.tag == 1)
        {
            [self performSegueWithIdentifier:@"basicInfoSegue" sender:nil];
            
        }
        else
        {
            [self performSegueWithIdentifier:@"moreInfoSegue" sender:nil];
        }
    
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


#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"attributeSegue"] || [segue.identifier isEqualToString:@"basicInfoSegue"] || [segue.identifier isEqualToString:@"moreInfoSegue"])
    {
        
        if([segue.identifier isEqualToString:@"attributeSegue"])
        {
            ((IMPharmaDetailViewController*)segue.destinationViewController).detailType = IMAttrbutes;
            ((IMPharmaDetailViewController*)segue.destinationViewController).product = self.product;
            
        }
        else if([segue.identifier isEqualToString:@"basicInfoSegue"])
        {
            ((IMPharmaDetailViewController*)segue.destinationViewController).detailType = IMBasicInfo;
            ((IMPharmaDetailViewController*)segue.destinationViewController).product = self.product;
        }
        else if([segue.identifier isEqualToString:@"moreInfoSegue"])
        {
            ((IMPharmaDetailViewController*)segue.destinationViewController).detailType = IMMoreInfo;
            ((IMPharmaDetailViewController*)segue.destinationViewController).product = self.product;
        }
        
        [self addChildViewController:segue.destinationViewController];
        UIView* destView = ((UIViewController *)segue.destinationViewController).view;
        destView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.containerView addSubview:destView];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:destView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1
                                                                        constant:0.0]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:destView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1
                                                                        constant:0.0]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:destView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:0.0]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:destView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:0.0]];
   
        [segue.destinationViewController didMoveToParentViewController:self];
        
        if(self.selectedViewController)
        {
             UIViewController* previousController =  self.selectedViewController;
            
           
                [UIView transitionFromView:previousController.view toView: ((UIViewController*)segue.destinationViewController).view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                    [previousController.view removeFromSuperview];
                    [previousController removeFromParentViewController];
                    

                }];
            
        }
        self.selectedViewController = segue.destinationViewController;
    }
    else if([segue.identifier isEqualToString:@"whyPrescribeSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMWhyPrescribe;
        
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.whyPrescribe ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"howShouldBeTakenSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMHowToTake;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.howShoubBeTaken ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"recommendedDosageSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMRecommendedDosage;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information =self.product.recommendedDosage;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"whenNotToTakeSeugue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMWhenNotToTake;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.whenNotTake ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"warningsSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMWarningPrecations;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.warningsAndPrecautions ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"sideEffectsSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMSideEffects;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.sideEffects ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"otherPrecautionsSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = IMOtherPrecations;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.otherPrecautions ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMOtherInfo;

    }
    else if([segue.identifier isEqualToString:@"IMActiveIngridientSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = @"Active ingredients";
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.activeIngredients ;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMActiveIngridients;

    }
    else if([segue.identifier isEqualToString:@"IMTapActiveIncridientSegue"])
    {
        ((UIViewController*)segue.destinationViewController).title = @"Active ingredients";
        ((IMPDPTextDetailViewController*)segue.destinationViewController).information = self.product.activeIngredients;
        ((IMPDPTextDetailViewController*)segue.destinationViewController).infoType = IMActiveIngridients;

    }
    
}

-(void)updateUIForAttrbutes
{
    if(![self.product.activeIngredient isEqualToString:@""])
    {
        self.activeIngridientLabel.text = self.product.activeIngredient;

    }
    else
    {
        self.activeIngridientLabel.text = @"-";

    }
    
    if(self.product.flavour)
       self.flavourNameLabel.text = self.product.flavour;
    else
        self.flavourNameLabel.text = IMNone;
    
    self.formLabel.text = self.product.form;
    self.innerPackingTypeLabel.text = self.product.unitOfSale;
}

-(void)updateUIForBasicInfo
{
    if(![self.product.activeIngredient isEqualToString:@""])
    {
        self.activeIngridientLabel.text = self.product.activeIngredient;
        
    }
    else
    {
        self.activeIngridientLabel.text = @"-";
        
    }
    if(self.product.flavour)
        self.flavourNameLabel.text = self.product.flavour;
    else
        self.flavourNameLabel.text = IMNone;
    
    self.formLabel.text = self.product.form;
    self.routeOfAdminLabel.text = self.product.routeOfAdmin;
    
    if(self.product.whyPrescribe && self.product.whyPrescribe.length)
        self.whyPrescribeLabel.attributedText = [self attributedStringForString:self.product.whyPrescribe];
    else
        self.whyPrescribeLabel.text = IMNone;
    if(self.product.howShoubBeTaken && self.product.howShoubBeTaken.length)
        self.howItShouldBeTakenLabel.attributedText = [self attributedStringForString:self.product.howShoubBeTaken];
    else
        self.howItShouldBeTakenLabel.text = IMNone;
    if(self.product.recommendedDosage && self.product.recommendedDosage.length)
        self.recommendedDosageLabel.attributedText = [self attributedStringForString:self.product.recommendedDosage];
    else
        self.recommendedDosageLabel.text = IMNone;
}

//- (NSMutableAttributedString *)attributedStringForString:(NSString *)string
//{
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    return attributedString;
//
//}
-(void)updateUIForMoreInfo
{
    if(self.product.whenNotTake && self.product.whenNotTake.length)
        self.whenNotToTakeLabel.attributedText = [self attributedStringForString:self.product.whenNotTake];
    else
        self.whenNotToTakeLabel.text = IMNone;
    if(self.product.warningsAndPrecautions && self.product.warningsAndPrecautions.length)
        self.warningAndPrecautionsLabel.attributedText = [self attributedStringForString:self.product.warningsAndPrecautions];
    else
        self.warningAndPrecautionsLabel.text = IMNone;
    if(self.product.sideEffects && self.product.sideEffects.length)
        self.sideEffectsLabel.attributedText = [self attributedStringForString:self.product.sideEffects];
    else
        self.sideEffectsLabel.text = IMNone;
    if(self.product.otherPrecautions && self.product.otherPrecautions.length)
        self.otherPrecautionsLabel.attributedText = [self attributedStringForString:self.product.otherPrecautions];
    else
        self.otherPrecautionsLabel.text = IMNone;
}

- (IBAction)addToCartPressed:(id)sender

{
    if(self.product.available)
    {
        [IMFlurry logEvent:IMAddToCartEvent withParameters:@{}];
        
        IMLineItem *lineItem = [[IMLineItem alloc] init];
        lineItem.identifier = self.product.identifier;
        lineItem.name = self.product.name;
        lineItem.quantity = [[IMCartManager sharedManager] quantityOfCartLineItemWithVariantId:self.product.identifier];
        
        if(!lineItem.quantity)
        {
            lineItem.quantity = 1;
        }
        lineItem.quantity = MIN([self.product.maxOrderQuantity integerValue], lineItem.quantity);
        
        lineItem.innerPackingQuantity = self.product.innerPackageQuantity;
        lineItem.unitOfSales = self.product.unitOfSale;
        lineItem.maxOrderQuanitity = self.product.maxOrderQuantity;
        
        IMQuantitySelectionViewController* quantitySelectionViewController = [[IMQuantitySelectionViewController alloc] initWithNibName:nil bundle:nil];
        quantitySelectionViewController.delgate = self;
        quantitySelectionViewController.product = lineItem;

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
    [[IMPharmacyManager sharedManager] notifyUserForProductWithID:self.product.identifier andUserDictionary:userDictionary withCompletion:^(NSError *error) {
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
    [[IMPharmacyManager sharedManager] notifyUserForProductWithID:self.product.identifier andUserDictionary:userDictionary withCompletion:^(NSError *error) {
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

-(void)dissmissAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    [self animateBadgeIcon];

}

- (IBAction)activeIngridientPressed:(UITapGestureRecognizer *)sender
{
    
    if(self.product.hasMultipleIngredients)
    {
        [self performSegueWithIdentifier:@"IMActiveIngridientSegue" sender:nil];
    }
    else
    {
        
    }
}

- (IBAction)supportPressed:(id)sender
{
    [self.tabBarController setSelectedIndex:3];
}
- (IBAction)pressedShareButton:(UIButton *)sender
{
    if([[IMServerManager sharedManager] isNetworkAvailable])
    {
        [IMFlurry logEvent:IMPDPShareButtonTapped withParameters:@{}];
        NSString *sharingSubject = [[IMAppSettingsManager sharedManager] productShareSubject];
        NSString *sharingMessage  = [[IMAppSettingsManager sharedManager] productShareMessage];
        sharingSubject = [sharingSubject stringByReplacingOccurrencesOfString:IMProductNamePlaceHolder withString:self.product.name];
        sharingMessage = [sharingMessage stringByReplacingOccurrencesOfString:IMProductNamePlaceHolder withString:self.product.name];
        sharingMessage = [sharingMessage stringByReplacingOccurrencesOfString:IMProductLinkPlaceHolder withString:@""];
        [IMBranchServiceManager shareProduct:self.product ofType:@"Pharma" withCompletion:nil];
    }
    else
    {
        [self showNoNetworkAlert];
    }
    

}

@end
