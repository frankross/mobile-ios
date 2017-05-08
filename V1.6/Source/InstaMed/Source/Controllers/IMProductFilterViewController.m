//
//  IMProductFilterViewController.m
//  InstaMed
//
//  Created by Suhail K on 30/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProductFilterViewController.h"
#import "NMRangeSlider.h"
#import "IMOptionsViewController.h"
#import "IMLocationManager.h"
#import "IMPharmacyManager.h"

#define SLIDER_MOVEMENT_START_LIMIT 10

@interface IMProductFilterViewController ()
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *discountSlider;

@property (weak, nonatomic) IBOutlet UILabel *minDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minPriceLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mxPricerightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minDiscountLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxDiscountRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *menButton;

@property (weak, nonatomic) IBOutlet UIButton *womenButton;

@property (nonatomic,strong) NSMutableArray* brands;
@property(nonatomic,strong) NSMutableArray* selectedBrands;
@property(nonatomic,strong) NSArray* offers;
@property (weak, nonatomic) IBOutlet UILabel *offerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesPriceHeightConstraint;


@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (weak, nonatomic) IBOutlet UILabel *categoryCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryCotainerHeightConstraint;
@property(nonatomic,strong) NSMutableArray* selectedCategories;
@property (nonatomic,strong) NSMutableArray* categories;

- (IBAction)resetPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)applyPressed:(UIButton *)sender;
@end

@implementation IMProductFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLabelSlider];
    [self configureSliders];
    if([self.view respondsToSelector:@selector(setTintColor:)])
    {
        self.view.tintColor = APP_THEME_COLOR;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpFilterData
{
    if(!self.brands)
    {
        NSMutableArray* brands = [NSMutableArray array];
        for(NSString* brandName in [self.facetInfo[@"facets"][IMBrandNameKey] allKeys])
        {
            IMBrand* brand = [[IMBrand alloc] init];
            brand.name = brandName;
            [brands addObject:brand];
        }
        NSArray *sortedArray;
        sortedArray = [brands sortedArrayUsingComparator:^NSComparisonResult(IMBrand *a, IMBrand *b) {
            NSString *first = [a name];
            NSString *second = [b name];
            return [first compare:second];
        }];
        
        self.brands = [sortedArray mutableCopy];;
    }
    
    self.selectedBrands = [NSMutableArray array];
    
    for(NSString* brandName in self.filterDictionary[IMBrandNameKey])
    {
        IMBrand* brand = [[IMBrand alloc] init];
        brand.name = brandName;
        [self.selectedBrands addObject:brand];
    }
    //hiding if only one brand
    if(self.brands.count <= 1)
    {
        self.brandContainerHeightConstraint.constant = 0;
    }
    else
    {
        self.brandContainerHeightConstraint.constant = 53;
    }
    if(!self.categories)
    {
        NSMutableArray* categories = [NSMutableArray array];
//        NSArray *hits = self.facetInfo[@"hits"];
//        for(NSDictionary *catDict in hits)
//        {
//            IMCategory* category = [[IMCategory alloc] init];
//            category.identifier = catDict[@"category_details"][@"primary_category"][@"id"];
//            category.name = catDict[@"category_details"][@"primary_category"][@"name"];
//            if(![categories containsObject:category])
//            {
//                [categories addObject:category];
//            }
//        }
//        self.categories = categories;
        for(NSString* catName in [self.facetInfo[@"facets"][IMPrimaryCategoryKey] allKeys])
        {
            IMCategory* category = [[IMCategory alloc] init];
            category.name = catName ;
            [categories addObject:category];
        }
        NSArray *sortedArray;
        sortedArray = [categories sortedArrayUsingComparator:^NSComparisonResult(IMCategory *a, IMCategory *b) {
            NSString *first = [a name];
            NSString *second = [b name];
            return [first compare:second];
        }];
        self.categories = [sortedArray mutableCopy];
        //hiding if only one category
        if(self.categories.count <= 1 || self.filterType == IMFromCategory)
        {
            self.categoryCotainerHeightConstraint.constant = 0;
        }
        else
        {
            self.categoryCotainerHeightConstraint.constant = 53;
        }
    }

    self.selectedCategories = [NSMutableArray array];
    
    for(NSString* catName in self.filterDictionary[IMPrimaryCategoryKey])
    {
        IMCategory* category = [[IMCategory alloc] init];
        category.name = catName;
        [self.selectedCategories addObject:category];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateDiscountSliderLabels];
    [self updatePriceSliderLabels];
    
}

-(void)loadUI
{
    [self setUpNavigationBar];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                   initWithTitle:IMCancel
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.brandCountLabel.text = @"";
    self.offerCountLabel.text = @"";
    self.categoryCountLabel.text = @"";
    
    [self setUpFilterData];
    
    
    if(self.selectedBrands.count >= 1)
    {
        self.brandCountLabel.text = [NSString stringWithFormat:@"%ld selected",(unsigned long)self.selectedBrands.count];
    }
    else // No selection
    {
        self.brandCountLabel.text = @"";
    }
    if(self.selectedCategories.count >= 1)
    {
        self.categoryCountLabel.text = [NSString stringWithFormat:@"%ld selected",(unsigned long)self.selectedCategories.count];
    }
    else // No selection
    {
        self.categoryCountLabel.text = @"";
    }
}

- (void) configureLabelSlider
{
    NSString* currentCityString = [NSString stringWithFormat:@"cities_mapping.city_%@",[IMLocationManager sharedManager].currentLocation.identifier];
    
    //code for price filter w r t sales_price
    
//    NSNumber* minSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.sales_price",currentCityString] ][@"min"];
//     NSNumber* maxSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.sales_price",currentCityString] ][@"max"];
    
    
    NSNumber* minSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.promotional_price_f",currentCityString] ][@"min"];
    NSNumber* maxSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.promotional_price_f",currentCityString] ][@"max"];
    
    
    NSNumber* minDiscountPercent = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.discount_percent_f",currentCityString] ][@"min"];
    NSNumber* maxDicountPercent = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.discount_percent_f",currentCityString] ][@"max"];
    
    
    
    if(minDiscountPercent == nil || maxDicountPercent == nil ||
       [minDiscountPercent isEqualToNumber:maxDicountPercent])
    {
        self.discountContainerHeightConstraint.constant = 0;
    }
    else
    {
        
        self.discountSlider.maximumValue = ceilf(maxDicountPercent.floatValue);
        if(self.filterDictionary[IMDiscountMaxKey])
        {
          self.discountSlider.upperValue = ceilf([self.filterDictionary[IMDiscountMaxKey] floatValue]);
        }
        else
        {
            self.discountSlider.upperValue = ceilf(maxDicountPercent.floatValue);
        }
        
        
        self.discountSlider.minimumValue = minDiscountPercent.floatValue;
        if(self.filterDictionary[IMDiscountMinKey])
        {
            self.discountSlider.lowerValue = [self.filterDictionary[IMDiscountMinKey] floatValue];
        }
        else
        {
            self.discountSlider.lowerValue = minDiscountPercent.floatValue;
        }

    }
    
    if(minSalesPrice == nil || maxSalesPrice == nil ||
       [minSalesPrice isEqualToNumber:maxSalesPrice])
    {
        self.salesPriceHeightConstraint.constant = 0;
    }
    else
    {
        self.priceSlider.maximumValue = ceilf(maxSalesPrice.floatValue);
        
        if(self.filterDictionary[IMSalesPriceMaxKey])
        {
            self.priceSlider.upperValue = ceilf([self.filterDictionary[IMSalesPriceMaxKey] floatValue]);
        }
        else
        {
            self.priceSlider.upperValue = ceilf(maxSalesPrice.floatValue);
        }
        
        
        self.priceSlider.minimumValue = minSalesPrice.floatValue;
        
        if(self.filterDictionary[IMSalesPriceMinKey])
        {
            self.priceSlider.lowerValue = [self.filterDictionary[IMSalesPriceMinKey] floatValue];
        }
        else
        {
            self.priceSlider.lowerValue = minSalesPrice.floatValue;
        }
    }

   
    
}

- (void)configureSliders
{
    UIImage *background = [UIImage imageNamed:@"main_slider"];
   // UIImage *handle = [UIImage imageNamed:@"handle"];
    UIImage *track = [UIImage imageNamed:@"green_slider"];
//    self.priceSlider.lowerTouchEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//    self.priceSlider.upperTouchEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);

//    self.priceSlider.lowerHandleImageNormal = handle;
//    self.priceSlider.upperHandleImageNormal = handle;
//    self.priceSlider.lowerHandleImageHighlighted = handle;
//    self.priceSlider.upperHandleImageHighlighted = handle;
    
//    if(IS_PRE_IOS7())
//    {
//        UIImage* image = background;
//        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
//        background = image;
//    }
//    else
//    {
      UIImage *image =background;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
        background = image;
 //   }

    
    self.priceSlider.trackBackgroundImage = background;
    self.priceSlider.trackImage = track;
    
//    self.discountSlider.lowerHandleImageNormal = handle;
//    self.discountSlider.upperHandleImageNormal = handle;
//    self.discountSlider.lowerHandleImageHighlighted = handle;
//    self.discountSlider.upperHandleImageHighlighted = handle;
//    self.discountSlider.lowerTouchEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//    self.discountSlider.upperTouchEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    
    self.discountSlider.trackBackgroundImage = background;
    self.discountSlider.trackImage = track;
}

- (IBAction)priceSliderChanged:(NMRangeSlider *)sender
{
    [self updatePriceSliderLabels];
}

- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateDiscountSliderLabels];
}

- (void) updatePriceSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.priceSlider.lowerCenter.x + self.priceSlider.frame.origin.x);
    lowerCenter.y = (self.priceSlider.center.y - 30.0f);
//    self.minPriceLabel.center = lowerCenter;
    NSLog(@"%f",(self.priceSlider.maximumValue));

    NSLog(@"%f",((self.priceSlider.maximumValue/100) *10)+self.priceSlider.minimumValue);
    NSLog(@"%f",(self.priceSlider.lowerValue));

    if((int)self.priceSlider.lowerValue <= (((self.priceSlider.maximumValue - self.priceSlider.minimumValue)/100) *SLIDER_MOVEMENT_START_LIMIT)+self.priceSlider.minimumValue)
    {
        self.minPriceLeftConstraint.constant = lowerCenter.x - 12.0f;

    }
    else
    {
        self.minPriceLeftConstraint.constant = lowerCenter.x - 48.0f;

    }
    self.minPriceLabel.text = [NSString stringWithFormat:@"₹%d", (int)self.priceSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.priceSlider.upperCenter.x + self.priceSlider.frame.origin.x);
    upperCenter.y = (self.priceSlider.center.y - 30.0f);
//    self.maxPriceLabel.center = upperCenter;
    
    if((int)self.priceSlider.upperValue >= (self.priceSlider.maximumValue - ((self.priceSlider.maximumValue - self.priceSlider.minimumValue)/100) *SLIDER_MOVEMENT_START_LIMIT))
    {
        self.mxPricerightConstraint.constant = (self.view.frame.size.width - upperCenter.x ) - 16;
    }
    else
    {
        self.mxPricerightConstraint.constant = (self.view.frame.size.width - upperCenter.x ) - 55;
    }

    self.maxPriceLabel.text = [NSString stringWithFormat:@"₹%d", (int)self.priceSlider.upperValue];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) updateDiscountSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.discountSlider.lowerCenter.x + self.discountSlider.frame.origin.x);
    lowerCenter.y = (self.discountSlider.center.y - 30.0f);
//    self.minDiscountLabel.center = lowerCenter;
    self.minDiscountLeftConstraint.constant = lowerCenter.x - 2.0f;

    if((int)self.discountSlider.lowerValue <= (((self.discountSlider.maximumValue - self.discountSlider.minimumValue)/100) *SLIDER_MOVEMENT_START_LIMIT)+self.discountSlider.minimumValue)
    {
        self.minDiscountLeftConstraint.constant = lowerCenter.x - 12.0f;
    }
    else
    {
        self.minDiscountLeftConstraint.constant = lowerCenter.x - 48.0f;
        
    }
    self.minDiscountLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.discountSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.discountSlider.upperCenter.x + self.discountSlider.frame.origin.x);
    upperCenter.y = (self.discountSlider.center.y - 30.0f);
//    self.maxDiscountLabel.center = upperCenter;
    
    if((int)self.discountSlider.upperValue >= (self.discountSlider.maximumValue - ((self.discountSlider.maximumValue - self.discountSlider.minimumValue)/100) *SLIDER_MOVEMENT_START_LIMIT))
    {
        self.maxDiscountRightConstraint.constant = (self.view.frame.size.width - upperCenter.x ) - 16;
    }
    else
    {
        self.maxDiscountRightConstraint.constant = (self.view.frame.size.width - upperCenter.x ) - 55;
    }


    self.maxDiscountLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.discountSlider.upperValue];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setNeedsLayout];
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyPressed:(UIButton *)sender
{
    [IMFlurry logEvent:IMFilterEvent withParameters:@{}];

    NSMutableArray* brandArray = [NSMutableArray array];
    NSMutableArray* categoryNameArray = [NSMutableArray array];

    for (IMBrand* brand  in self.selectedBrands)
    {
        [brandArray addObject:brand.name];
    }
    
    for (IMCategory* category  in self.selectedCategories)
    {
        [categoryNameArray addObject:category.name];
    }
    self.filterDictionary[IMPrimaryCategoryKey] = categoryNameArray;

    self.filterDictionary[IMBrandNameKey] = brandArray;
    
    
    if(self.priceSlider.maximumValue != self.priceSlider.upperValue ||   self.priceSlider.minimumValue != self.priceSlider.lowerValue)
    {
        self.filterDictionary[IMSalesPriceMinKey] = @(floorf(self.priceSlider.lowerValue));
        self.filterDictionary[IMSalesPriceMaxKey] = @(floorf(self.priceSlider.upperValue));
    }
    else
    {
        [self.filterDictionary removeObjectForKey:IMSalesPriceMinKey];
        [self.filterDictionary removeObjectForKey:IMSalesPriceMaxKey];
    }
    
    if(self.discountContainerHeightConstraint.constant && (self.discountSlider.maximumValue != self.discountSlider.upperValue ||   self.discountSlider.minimumValue != self.discountSlider.lowerValue))
    {
        self.filterDictionary[IMDiscountMinKey] = @(floorf(self.discountSlider.lowerValue));
        self.filterDictionary[IMDiscountMaxKey] = @(floorf(self.discountSlider.upperValue));
    }
    else
    {
        [self.filterDictionary removeObjectForKey:IMDiscountMinKey];
        [self.filterDictionary removeObjectForKey:IMDiscountMaxKey];
    }
    
    if([self.delegate respondsToSelector:@selector(filtersApplied)])
    {
        [self.delegate filtersApplied];
    }

    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)resetPressed:(id)sender {
    
    //[self configureLabelSlider];
    
    NSString* currentCityString = [NSString stringWithFormat:@"cities_mapping.city_%@",[IMLocationManager sharedManager].currentLocation.identifier];
    
//    NSNumber* minSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.sales_price",currentCityString] ][@"min"];
//    NSNumber* maxSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.sales_price",currentCityString] ][@"max"];
    
    NSNumber* minSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.promotional_price_f",currentCityString] ][@"min"];
    NSNumber* maxSalesPrice = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.promotional_price_f",currentCityString] ][@"max"];
    
    
    NSNumber* minDiscountPercent = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.discount_percent_f",currentCityString] ][@"min"];
    NSNumber* maxDicountPercent = self.facetInfo[@"facets_stats"][[NSString stringWithFormat:@"%@.discount_percent_f",currentCityString] ][@"max"];
    
    
    self.priceSlider.upperValue = ceilf([maxSalesPrice floatValue]);
    self.priceSlider.lowerValue = [minSalesPrice floatValue];
    
    if(self.discountContainerHeightConstraint.constant)
    {
        self.discountSlider.upperValue = ceilf( [maxDicountPercent floatValue]);
        self.discountSlider.lowerValue = [minDiscountPercent floatValue];
    }

    [self performSelector:@selector(updatePriceSliderLabels) withObject:nil afterDelay:0.01];
    [self performSelector:@selector(updateDiscountSliderLabels) withObject:nil afterDelay:0.01];
    self.menButton.selected = NO;
    self.womenButton.selected = NO;
    self.brandCountLabel.text = @"";
    self.offerCountLabel.text = @"";
    self.categoryCountLabel.text = @"";
    self.selectedBrands = nil;
    self.offers = nil;
    self.selectedCategories = nil;
    
    if([self.delegate respondsToSelector:@selector(filterReset)])
    {
        [self.delegate filterReset];
    }
}

- (IBAction)menPressed:(UIButton *)sender {
    self.menButton.selected = !self.menButton.selected;
    
}
- (IBAction)womenPressed:(UIButton *)sender {
    self.womenButton.selected = !self.womenButton.selected;

}
#pragma mark - Navigation -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"IMBrandsSegue"])
    {
        IMOptionsViewController* optionsViewController = segue.destinationViewController;
        optionsViewController.optionType = IMBrands;
        optionsViewController.selectedOptions = self.selectedBrands;
        optionsViewController.modelArray = self.brands;
        optionsViewController.completionBlock = ^(NSMutableArray* options){
        
            self.selectedBrands = options;
            
            if(self.selectedBrands.count >= 1)
            {
                self.brandCountLabel.text = [NSString stringWithFormat:@"%ld selected",(unsigned long)self.selectedBrands.count];
            }
            else // No selection
            {
                self.brandCountLabel.text = @"";
            }
            
            for (IMBrand* brand in options) {
                NSLog(@"%@",brand.name);
            }
        };
    }
    else if([segue.identifier isEqualToString:@"IMOffersSegue"])
    {
        IMOptionsViewController* optionsViewController = segue.destinationViewController;
        optionsViewController.optionType = IMOffers;
        optionsViewController.selectedOptions = self.offers;
        optionsViewController.completionBlock = ^(NSMutableArray* options){
            self.offers = options;
            
            if(self.offers.count >= 1)
            {
                self.offerCountLabel.text = [NSString stringWithFormat:@"%ld selected",(unsigned long)self.offers.count];
            }
            else // No selection
            {
                self.offerCountLabel.text = @"";
            }

            
            for (IMOffer* offer in options) {
                NSLog(@"%@",offer.name);
            }
            
        };

    }
    else if([segue.identifier isEqualToString:@"IMCategorySegue"])
    {
        IMOptionsViewController* optionsViewController = segue.destinationViewController;
        optionsViewController.optionType = IMCat;
        optionsViewController.selectedOptions = self.selectedCategories;
        optionsViewController.modelArray = self.categories;
        optionsViewController.completionBlock = ^(NSMutableArray* options){
            
            self.selectedCategories = options;
            
            if(self.selectedCategories.count >= 1)
            {
                self.categoryCountLabel.text = [NSString stringWithFormat:@"%ld selected",(unsigned long)self.selectedCategories.count];
            }
            else // No selection
            {
                self.categoryCountLabel.text = @"";
            }
            
            for (IMCategory* category in options) {
                NSLog(@"%@",category.name);
            }
        };
    }


}
@end
