//
//  IMProduct.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMProduct.h"
#import "IMVariationTheme.h"
#import "IMVarientValue.h"

NSString* const IMVariantIdKey = @"variantId";
NSString* const IMVariantName = @"name";
NSString* const IMSKUKey = @"sku";
NSString* const IMActiveIngredientKey = @"active_ingredient";


@implementation IMProduct

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    dictionary = dictionary [@"variant"];
    self = [super initWithDictionary:dictionary];
    self.name = dictionary[IMVariantName];
    self.mrp = dictionary[@"mrp"];
    self.sellingPrice = dictionary[@"sales_price"];
    self.discountPercent = dictionary[@"discount_percent"];
    self.discountPercentDouble = dictionary[@"discount_percent_f"];
    self.promotionalPrice = dictionary[@"promotional_price"];
    self.manufacturer = dictionary[@"manufacturer"];
    self.availableQuantity = [dictionary[@"availableQuantity"] integerValue];
    self.inventoryLabel = dictionary[@"inventory_label"];
    self.categoryId = dictionary[@"primary_category_id"];
    self.imageURRLs = dictionary[@"images"];
    self.maxOrderQuantity = dictionary[@"max_orderable_quantity"];
    self.thumbnailImageURL = dictionary[@"icon_image_url"];
    
    self.cashback = [dictionary[@"cash_back"] boolValue];
    self.cashbackDescription = dictionary[@"cash_back_desc"];
    
    NSDictionary* variantProperties = dictionary[@"properties"];
    
    self.unitOfSale = variantProperties[@"unit_of_sale"][@"value"];
    self.innerPackageQuantity = variantProperties[@"inner_package_quantity"][@"value"];
    self.outerPackageQuantity = variantProperties[@"outer_package_quantity"][@"value"];
    
    NSArray *allKeys = [dictionary allKeys];
    self.isAvailablePresent = [allKeys containsObject:@"available"];
    self.available = [dictionary[@"available"] boolValue];
    self.isNotifyMe = [dictionary[@"notify_me"] boolValue];
    
    
    //Pharma
    self.manufacturer = dictionary[@"manufacturer_name"];
    
    self.schedule = variantProperties[@"schedule"][@"value"];
    [self setupActiveIngredients:variantProperties];
    self.flavour =  variantProperties[@"flavour"][@"value"];
    self.form = variantProperties[@"item_form"][@"value"];
    self.routeOfAdmin = variantProperties[@"route_of_administration"][@"value"];
    
    self.whyPrescribe = variantProperties[@"why_prescribe"][@"value"];
    self.howShoubBeTaken = variantProperties[@"directions_usage"][@"value"];
    self.recommendedDosage = variantProperties[@"recommended_dosage"][@"value"];
    
    self.whenNotTake =  variantProperties[@"when_is_it_not_to_be_taken"][@"value"];
    self.warningsAndPrecautions = variantProperties[@"warnings_and_precaution"][@"value"];
    self.sideEffects = variantProperties[@"side_effects"][@"value"];
    self.otherPrecautions = variantProperties[@"other_precautions"][@"value"];
    
    self.prescriptionRequired= [variantProperties[@"prescription_required"][@"value"] boolValue] ;
    
    
    
    //Non pharma
    self.keyFeatures = [NSMutableArray array];
    self.variantDescription = dictionary[@"product_description"];
    if(variantProperties[@"product_feature1"][@"value"] )
    {
        [self.keyFeatures addObject:variantProperties[@"product_feature1"][@"value"] ];
    }
    
    if(variantProperties[@"product_feature2"][@"value"])
    {
        [self.keyFeatures addObject:variantProperties[@"product_feature2"][@"value"] ];
    }
    
    if(variantProperties[@"product_feature3"][@"value"])
    {
        [self.keyFeatures addObject:variantProperties[@"product_feature3"][@"value"] ];
    }
    
    self.varients = [NSMutableArray array];
    
    self.variationThemes = [NSMutableArray array];
    
    for(NSString* variantThemeName in dictionary[@"variation_theme"])
    {
        IMVarient* varient = [[IMVarient alloc] init];
        varient.attribute = variantProperties[variantThemeName][@"display_name"];
        varient.value = variantProperties[variantThemeName][@"value"];
        [self.varients addObject:varient];
        
        IMVariationTheme* variationtheme = [[IMVariationTheme alloc] init];
        variationtheme.name = variantThemeName;
        variationtheme.displayName = variantProperties[variantThemeName][@"display_name"];
        [self.variationThemes addObject:variationtheme];
    }
    
    self.brand = dictionary[@"brand_name"];
    
    // populate other varients dictionary
    self.otherVarients = [NSMutableDictionary dictionary];
    IMVariationTheme *primaryVariantTheme = nil;
    IMVariationTheme *secondaryVariantTheme = nil;
    NSString *productPrimaryVariantValue = nil;
    NSString *productSecondaryVariantValue = nil;
    
    if (self.variationThemes != nil &&  self.variationThemes.count > 0) {
        primaryVariantTheme = self.variationThemes[0];
        productPrimaryVariantValue = variantProperties[primaryVariantTheme.name][@"value"];
        if (self.variationThemes.count > 1) {
            secondaryVariantTheme = self.variationThemes[1];
            productSecondaryVariantValue = variantProperties[secondaryVariantTheme.name][@"value"];
        }
    }
    NSArray* otherVariants = dictionary[@"other_variants"];
    NSLog(@"otherVariants= %@",otherVariants);
    NSLog(@"productPrimaryVariantValue= %@",productPrimaryVariantValue);
    NSLog(@"productSecondaryVariantValue= %@",productSecondaryVariantValue);
    
    // store other variants like this
    /*
     if size and max_order_quantity are two variation themes
     where size -> L, M, S
     Order quantity -> 50, 60, 70
     variant ids are -> 123456, etc
     
     then the "self.otherVarients" will have following structure
     
     {
     L= ({50, 123456}, {60, 12357} )
     M= ({50, 123456}, )
     S= ({60, 123456})
     }
     
     // if no secondary theme then
     {
     L= ({123456}, {12357} )
     M= ({123478}, )
     S= ({123489})
     }
     */
    // add product varient info to varients list
    // update theme supported values also
    IMVarientValue *varientValue = [[IMVarientValue alloc] init];
    if (productPrimaryVariantValue != nil) {
        varientValue.primaryValue = productPrimaryVariantValue;
        // add primary variant value to supported values in variation theme
        NSMutableArray *primaryVariantSupportedValues = primaryVariantTheme.supportedValues;
        primaryVariantSupportedValues = [NSMutableArray array];
        primaryVariantTheme.supportedValues = primaryVariantSupportedValues;
        [primaryVariantSupportedValues addObject:productPrimaryVariantValue];
        
        if (productSecondaryVariantValue != nil) {
            varientValue.secondaryValue = productSecondaryVariantValue;
            // add secondary variant value to supported values in variation theme
            NSMutableArray *secondaryVariantSupportedValues = secondaryVariantTheme.supportedValues;
            secondaryVariantSupportedValues = [NSMutableArray array];
            secondaryVariantTheme.supportedValues = secondaryVariantSupportedValues;
            [secondaryVariantSupportedValues addObject:productSecondaryVariantValue];
        }
        varientValue.varientProductId = dictionary[@"id"];
        varientValue.isSelected = YES;
        varientValue.isSupported = YES;
        
        NSMutableArray* secondaryVariantInfoList = [NSMutableArray array];
        [secondaryVariantInfoList addObject:varientValue];
        [self.otherVarients setValue:secondaryVariantInfoList forKey:productPrimaryVariantValue];
    }
    NSLog(@"otherVarients before= %@",self.otherVarients);
    
    // till here
    
    for (NSDictionary *varient in otherVariants) {
        NSLog(@"varient details= %@",varient);
        IMVarientValue *varientValue = [[IMVarientValue alloc] init];
        varientValue.isSupported = NO;
        varientValue.isSelected = NO;
        NSNumber *maxOrderableQuantity = varient[@"max_orderable_quantity"];
        NSLog(@"maxOrderableQuantity= %@",maxOrderableQuantity);
		// if variant is not supported for the city then "max_orderable_quantity" 
        if (maxOrderableQuantity != nil && maxOrderableQuantity.intValue > 0 ){
            varientValue.isSupported = YES;
        }
        else{
            continue;
        }
        // get variant properties
        NSDictionary *otherVariantPoperties = varient[@"properties"];
        if (otherVariantPoperties == nil) {
            continue;
        }
        NSLog(@"varient properties= %@",otherVariantPoperties);
        
        // get primary and secondary variation theme info from variant
        NSDictionary *primaryVariantInfo = otherVariantPoperties[primaryVariantTheme.name];
        if (primaryVariantInfo == nil) {
            continue;
        }
        
        NSString *primaryVariantValue = primaryVariantInfo[@"value"];
        // add primary variant value to supported values in variation theme
        NSMutableArray *primaryVariantSupportedValues = primaryVariantTheme.supportedValues;
        if (primaryVariantSupportedValues == nil) {
            primaryVariantSupportedValues = [NSMutableArray array];
            primaryVariantTheme.supportedValues = primaryVariantSupportedValues;
        }
        if (![primaryVariantSupportedValues containsObject:primaryVariantValue]) {
            [primaryVariantSupportedValues addObject:primaryVariantValue];
        }
        varientValue.primaryValue = primaryVariantValue;
        // till here
        
        NSDictionary *secondaryVariantInfo = otherVariantPoperties[secondaryVariantTheme.name];
        NSLog(@"primaryVariantInfo= %@",primaryVariantInfo);
        NSLog(@"secondaryVariantInfo= %@",secondaryVariantInfo);
        
        // store secondary variant values associated with a primary variant in a dictionary
        NSMutableArray *secondaryVariantInfoList = self.otherVarients[primaryVariantValue];
        if (secondaryVariantInfoList == nil) {
            secondaryVariantInfoList = [NSMutableArray array];
            [self.otherVarients setValue:secondaryVariantInfoList forKey:primaryVariantValue];
        }
        NSLog(@"secondaryVariantInfoList= %@",secondaryVariantInfoList);
        
        // seconday variant may or may not be present
        // if not present et only variant id in the dictionary
        // form secondary varient info to be associated with primary one
        //        NSMutableDictionary* secondaryVariantDetail = [NSMutableDictionary dictionary];
        //        secondaryVariantDetail[@"id"] = varient[@"id"];
        varientValue.varientProductId = varient[@"id"];
        
        if (secondaryVariantInfo != nil) {
            NSString *secondaryVariantValue = secondaryVariantInfo[@"value"];
            
            // add secondary variant value to supported values in variation theme
            NSMutableArray *secondaryVariantSupportedValues = secondaryVariantTheme.supportedValues;
            if (secondaryVariantSupportedValues == nil) {
                secondaryVariantSupportedValues = [NSMutableArray array];
                secondaryVariantTheme.supportedValues = secondaryVariantSupportedValues;
            }
            if (![secondaryVariantSupportedValues containsObject:secondaryVariantValue]) {
                [secondaryVariantSupportedValues addObject:secondaryVariantValue];
            }
            // till here
            //            secondaryVariantDetail[@"value"] = secondaryVariantValue;
            varientValue.secondaryValue = secondaryVariantValue;
        }
        [secondaryVariantInfoList addObject:varientValue];
        NSLog(@"secondaryVariantInfoList= %@",secondaryVariantInfoList);
        NSLog(@"secondaryVariantInfoList= %@",self.otherVarients );
    }
    NSLog(@"otherVarients dict= %@",self.otherVarients );
    NSLog(@"primaryVariantTheme.supportedValues= %@",primaryVariantTheme.supportedValues );
    NSLog(@"secondaryVariantTheme.supportedValues = %@",secondaryVariantTheme.supportedValues  );
    self.hasExtraPrimaryVarients = NO;
    self.hasExtraSecondaryVarients = NO;
    // if only one primary varient
    if (primaryVariantTheme.supportedValues != nil) {
        if (primaryVariantTheme.supportedValues.count > 1) {
            self.hasExtraPrimaryVarients = YES;
        }
        // secondary varient present but only one
        if (secondaryVariantTheme.supportedValues != nil && secondaryVariantTheme.supportedValues.count > 1) {
            self.hasExtraSecondaryVarients = YES;
        }
    }
    
    return self;
}

//ka returns the discount percent in required format Eg: either 25 or 25.78
- (NSString*) formattedDiscountPercent{
    NSString *formattedDiscount = @"";
    
    if (_discountPercentDouble != nil) {
        if (_discountPercentDouble.doubleValue - floor(_discountPercentDouble.doubleValue) == 0.0) {
            formattedDiscount = [NSString stringWithFormat:@"%@",_discountPercentDouble];
        }
        else{
            formattedDiscount = [NSString stringWithFormat:@"%.02f",_discountPercentDouble.doubleValue];

            // to show 2 decimal points without rounding off
//            NSNumberFormatter *formatter = [NSNumberFormatter new];
//            [formatter setRoundingMode:NSNumberFormatterRoundFloor];
//            [formatter setMaximumFractionDigits:2];
//            formattedDiscount = [formatter stringFromNumber:@(_discountPercentDouble.doubleValue)];
//            NSLog(@"numberString: %@", formattedDiscount);
        }
    }
    else if(_discountPercent != nil){
        double discountPErcentDouble = _discountPercent.doubleValue;
        if (discountPErcentDouble - floor(discountPErcentDouble) == 0.0) {
            formattedDiscount = [NSString stringWithFormat:@"%ld",(long)_discountPercent.integerValue];
        }
        else{
            formattedDiscount = [NSString stringWithFormat:@"%.02f",discountPErcentDouble];
//            NSNumberFormatter *formatter = [NSNumberFormatter new];
//            [formatter setRoundingMode:NSNumberFormatterRoundFloor];
//            [formatter setMaximumFractionDigits:2];
//            formattedDiscount = [formatter stringFromNumber:@(discountPErcentDouble)];
//            NSLog(@"numberString: %@", formattedDiscount);
        }
    }
    
    return formattedDiscount;
}

/**
 @brief Appends all active ingredients Eg: active_ingredient1, active_ingredient2, active_ingredient3, active_ingredient4
 @brief Max 4 active_ingredient may come from the server
 */
- (void) setupActiveIngredients:(NSDictionary *)variantProperties
{
    if (!variantProperties) {
        return;
    }
    self.activeIngredient = [NSString string];
    self.activeIngredients = [NSString string];
    NSInteger maxIngredients = 4;
    for (NSInteger index = 1; index <= maxIngredients; index++) {
        NSString *activeIngredientKey = [NSString stringWithFormat:@"%@%ld",IMActiveIngredientKey,(long)index];
        // check if active ingredient key present or not
        if (variantProperties[activeIngredientKey])
        {
            // ignore empty active ingredients
            if(variantProperties[activeIngredientKey][@"value"] &&
               ![variantProperties[activeIngredientKey][@"value"] isEqualToString:@""])
            {
                if (self.activeIngredients.length > 0) {
                    self.activeIngredients = [self.activeIngredients stringByAppendingString:@"\n"];
                }
                self.activeIngredients = [self.activeIngredients stringByAppendingFormat:@"•  %@",variantProperties[activeIngredientKey][@"value"]];
                
                // first ingrdient
                if (index == 1) {
                    self.activeIngredient = [self.activeIngredient stringByAppendingString:variantProperties[activeIngredientKey][@"value"]];
                }
                // indicates multiple ingrdients present
                if (index > 1) {
                    self.hasMultipleIngredients = YES;
                }
            }
        }
        else{
            break;
        }
    }
}

@end
