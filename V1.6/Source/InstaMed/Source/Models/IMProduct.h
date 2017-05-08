//
//  IMProduct.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMVarient.h"

@interface IMProduct : IMBaseModel

@property (nonatomic, strong) NSString *productID;
//@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString* brand;
@property (nonatomic, strong) NSMutableArray *imageURRLs;
@property (nonatomic, strong) NSString *category;
@property (nonatomic,strong) NSNumber* categoryId;


@property (nonatomic,strong) NSString* unitOfSale;
@property (nonatomic) NSString* innerPackageQuantity;
@property (nonatomic,strong) NSString* outerPackageQuantity;
@property (nonatomic,strong) NSString* sizeName;

@property (nonatomic) BOOL isPharma;
@property (nonatomic) BOOL available;
@property (nonatomic, assign) BOOL isNotifyMe;
@property (nonatomic) BOOL isAvailablePresent;

@property (nonatomic, assign,getter=isCashBackAvailable) BOOL cashback;
@property (nonatomic, strong) NSString *cashbackDescription;


@property (nonatomic, strong) NSString *sellingPrice;
@property (nonatomic, strong) NSString *mrp;
@property (nonatomic,strong) NSString* promotionalPrice;
@property (nonatomic,strong) NSString* discountPercent;
@property (nonatomic,strong) NSNumber* discountPercentDouble;

@property (nonatomic) NSInteger availableQuantity;
@property (nonatomic,strong) NSNumber* maxOrderQuantity;
@property (nonatomic,strong) NSString* inventoryLabel;

//Pharma

@property(strong,nonatomic) NSString* schedule;
@property (nonatomic) BOOL prescriptionRequired;


    //Attributes
@property (nonatomic, strong) NSString *activeIngredient;
@property (nonatomic, strong) NSString *activeIngredients;
@property (nonatomic, strong) NSString *flavour;
@property (nonatomic, strong) NSString *form;
@property (nonatomic, strong) NSString *routeOfAdmin;
@property (nonatomic,strong) NSString* manufacturer;

    //Basic Info
@property (nonatomic, strong) NSString *whyPrescribe;
@property (nonatomic, strong) NSString *howShoubBeTaken;
@property (nonatomic, strong) NSString *recommendedDosage;

    //More Info
@property (nonatomic,strong) NSString* whenNotTake;
@property (nonatomic, strong) NSString *warningsAndPrecautions;
@property (nonatomic, strong) NSString *sideEffects;
@property (nonatomic, strong) NSString *otherPrecautions;


//Non-pharma
@property (nonatomic, strong) NSMutableArray *keyFeatures;
@property (nonatomic, strong) NSMutableArray *specifications;
@property (nonatomic,strong) NSMutableArray* variations;

@property (nonatomic,strong) NSMutableDictionary* variantDictionary;


//@property (nonatomic,strong) NSString* specifications;
@property (nonatomic,strong) NSString* variantDescription;
@property (nonatomic, strong) NSMutableArray *varients;
@property (nonatomic, strong) NSMutableArray *variationThemes;
@property (nonatomic, strong) NSMutableDictionary  *otherVarients;
@property (nonatomic, strong) NSMutableDictionary  *productVarient;

//thumbnail image url
@property (nonatomic,strong) NSString* thumbnailImageURL;
//ka determines whether varient selection should be enabled or not
@property (nonatomic) BOOL hasExtraPrimaryVarients;
@property (nonatomic) BOOL hasExtraSecondaryVarients;
@property (nonatomic) BOOL hasMultipleIngredients;


- (NSString*) formattedDiscountPercent;

@end
