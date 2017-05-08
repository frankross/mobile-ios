//
//  IMPharmacyManager.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPharmacyManager.h"
#import "ASAPIClient.h"
#import "IMServerManager.h"
#import "IMLocationManager.h"
#import "IMSortType.h"
#import "IMSettingsUtility.h"

NSString* const  IMCategoryIdKey = @"category_id";
NSString* const IMBrandNameKey  = @"brand_name";
NSString* const IMSortTypeKey = @"sortType";
NSString* const IMDiscountMinKey = @"discountPriceMin";
NSString* const IMDiscountMaxKey = @"discountPriceMax";
NSString* const IMSalesPriceMaxKey = @"salesPriceMax";
NSString* const IMSalesPriceMinKey = @"salesPriceMin";
NSString* const IMAlgoliaPrefix = @"Variant_Mobile";
NSString* const IMFeaturedKey = @"featured";
NSString* const IMFilterKey = @"filters";
//need to check the key in algolia
NSString* const IMPromotionIDKey  = @"promotion_id";


NSString* const IMPrimaryCategoryKey  = @"category_details.primary_category.name";

const NSInteger IMProductsPerPage = 10;

@interface IMPharmacyManager()

@property (strong, nonatomic) ASAPIClient *apiClient;
@property (strong, nonatomic) ASRemoteIndex *index ;

@end
@implementation IMPharmacyManager


+(IMPharmacyManager*)sharedManager
{
    static IMPharmacyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.apiClient =
//        [ASAPIClient apiClientWithApplicationID:@"XFSXDN69NU" apiKey:@"8318d99e32b79b4936d2028e75a99382"];
        [ASAPIClient apiClientWithApplicationID:@"T63QHGRW33" apiKey:@"483dd0e5c6d5165b830187abcad40394"];

        NSString* algoliaIndex  = [NSString stringWithFormat:@"%@_%@",IMAlgoliaPrefix,[IMSettingsUtility algoliaIndexSuffix]];

        sharedManager.index = [sharedManager.apiClient getIndex:algoliaIndex];

    });
    return sharedManager;
}


-(void)fetchOffersWithCompletion:(void(^)(NSArray* offerBanners,NSArray* offerStores,NSError* error))completion
{
    
//    [[IMServerManager sharedManager] fetchOffersWithCompletion:^(NSDictionary *offers, NSError *error) {
//      
//        NSArray *offerArray = offers[@"banners"];
//        NSMutableArray *offerList = [[NSMutableArray alloc] init];
//        for(NSDictionary *dict in offerArray)
//        {
//           IMOffer* offer = [[IMOffer alloc] initWithDictionary:dict];
//            [offerList addObject:offer];
//        }
//        completion(offerList,nil,error);
//
//    }];
    
    [[IMServerManager sharedManager] fetchOffersWithCompletion:^(NSDictionary *offers, NSError *error) {

        NSArray *offerBannerArray = offers[@"home_banners"];
        NSMutableArray *offerBannerList = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in offerBannerArray)
        {
            IMOffer* offer = [[IMOffer alloc] initWithDictionary:dict];
            [offerBannerList addObject:offer];
        }
        
        NSArray *offerStoreArray = offers[@"home_store_banners"];
        NSMutableArray *offerStoreList = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in offerStoreArray)
        {
            IMOffer* offer = [[IMOffer alloc] initWithDictionary:dict];
            [offerStoreList addObject:offer];
        }
        
        completion(offerBannerList,offerStoreList,error);

    }];

}

-(void) fetchOffersForListingPageWithCompletion:(void (^)(NSDictionary *offers,NSError *error))completion
{
    [[IMServerManager sharedManager] fetchOffersForListingPageWithCompletion:^(NSDictionary *offers, NSError *error) {
        
        completion(offers,error);
        
    }];
}

-(void)fetchAutoSuggestionsForSearchTerm:(NSString*)searchTerm withCompletion:(void (^)(NSArray *pharmaProducts,NSArray *nonPharmaProducts,NSError * error))completion
{
    __block NSMutableArray *pharma = [[NSMutableArray alloc]init];
    __block NSMutableArray *nonPharma= [[NSMutableArray alloc]init];
    
    
    ASQuery* query = [ASQuery queryWithFullTextQuery:searchTerm];
//    query.attributesToHighlight = @[@""];
    query.attributesToRetrieve = @[@"id",@"name",@"category_details",@"manufacturer",@"icon_image_url"];
//    query.facetFilters = [NSArray arrayWithObjects:nil];
    NSString* currentCity  = [NSString stringWithFormat:@"city_%@",[IMLocationManager sharedManager].currentLocation.identifier ];

    query.numericFilters = [NSString stringWithFormat:@"cities_mapping.%@.active=1",currentCity];
    [self.index cancelPreviousSearches];
    [self.index search:query
          success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *answer) {
              NSLog(@"%@",answer);
              NSArray *resultArray = [answer objectForKey:@"hits"];
              
              for (NSDictionary *productInfo in resultArray)
              {
                  IMProduct *product = [[IMProduct alloc] init];
                  product.name = [productInfo valueForKey:@"name"];
                  product.identifier = [productInfo valueForKey:@"id"];
                  product.category = [productInfo valueForKeyPath:@"category_details.primary_category.name"];
                  product.isPharma = [[productInfo valueForKeyPath:@"category_details.pharma"] boolValue];
                  product.manufacturer = [productInfo valueForKey:@"manufacturer"];
                  product.thumbnailImageURL = [productInfo valueForKey:@"icon_image_url"];
                  if(product.isPharma)
                  {
                      [pharma addObject:product];
                      
                  }
                  else
                  {
                      [nonPharma addObject:product];
                  }
              }
              
              completion(pharma,nonPharma,nil);
          } failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage)
     {
        // NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Operation couldn't be compleated",IMError, nil];
        // NSError *error = [[NSError alloc] initWithDomain:IMError code:1012 userInfo:errorDict];
//         completion(nil,nil,error);
         //TODO:Check what is the error here from algolia
         completion(nil,nil,nil);
     }];

}

-(void)fetchProductsForParametrs:(NSDictionary*)parameters  inPage:(NSInteger)page productsPerPage:(NSUInteger)productsPerPage withCompletion:(void(^)(NSArray* products , NSInteger totalPageCount,NSInteger totalProductCount,NSDictionary* facetInfo, NSError* error))completion
{
    
    NSString* currentCity  = [NSString stringWithFormat:@"city_%@",[IMLocationManager sharedManager].currentLocation.identifier ];

    
    NSString* indexName = @"";
    NSString* suffix = [IMSettingsUtility algoliaIndexSuffix];
   
    
    switch ( ((IMSortType*)parameters[IMSortTypeKey]).option) {
        case IMSalesPriceHighToLow:
        {
            indexName = [NSString stringWithFormat:@"%@_%@_promotional_price_desc_%@",IMAlgoliaPrefix,[IMLocationManager sharedManager].currentLocation.identifier,suffix];
              break;
        }
        case IMSalesPriceLowToHigh:
        {
            indexName = [NSString stringWithFormat:@"%@_%@_promotional_price_asc_%@",IMAlgoliaPrefix,[IMLocationManager sharedManager].currentLocation.identifier,suffix];
            break;
        }
            
        default:
            indexName =  [NSString stringWithFormat:@"%@_%@",IMAlgoliaPrefix,suffix];
//            [indexName stringByAppendingString:suffix];
    }
    
    ASRemoteIndex *index = [self.apiClient getIndex:indexName];
    
    ASQuery* query = [ASQuery queryWithFullTextQuery:parameters[@"search_term"]];
    query.attributesToHighlight = @[@""];
    
//    if(parameters[@"category_name"])
//    {
//        query.facetFilters = @[[NSString stringWithFormat:@"%@:%@",@"category_details.name",parameters[@"category_name"]]];
//    }
    
    query.facets = @[@"*"];
    
//    query.facetFilters = @[[NSString stringWithFormat:@"%@:%@",@"category_details.name",@"pharmacy"]];

    
    
    query.numericFilters = [NSString stringWithFormat:@"cities_mapping.%@.active=1",currentCity];//[IMLocationManager sharedManager].currentLocation.identifier];
    
    NSString *facetFiltersRaw = nil;
    
    if(parameters[IMBrandNameKey])
    {
        NSArray* brands = parameters[IMBrandNameKey];
        
        NSMutableString* brandFacetString = [NSMutableString string];
        
        for(NSString* brandName in brands)
        {
            [brandFacetString appendFormat:@"%@:%@,",IMBrandNameKey,brandName];
        }
        if(![brandFacetString isEqualToString:@""])
        {
           facetFiltersRaw = [NSString stringWithFormat:@"(%@)", brandFacetString];
        }
    }
    
    if(parameters[IMPrimaryCategoryKey])
    {
        NSArray* categories = parameters[IMPrimaryCategoryKey];
        
        NSMutableString* categoryFacetString = [NSMutableString string];
        
        for(NSString* catName in categories)
        {
            [categoryFacetString appendFormat:@"%@:%@,",IMPrimaryCategoryKey,catName];
        }
        
        if(![categoryFacetString isEqualToString:@""])
        {
            if (facetFiltersRaw)
            {
                facetFiltersRaw = [facetFiltersRaw stringByAppendingFormat:@",(%@)",categoryFacetString];
            }
            else
            {
                facetFiltersRaw = [NSString stringWithFormat:@"(%@)", categoryFacetString];
            }
        }
    }
    if(parameters[IMPromotionIDKey])
    {

        query.numericFilters = query.numericFilters = [query.numericFilters stringByAppendingFormat:@",cities_mapping.%@.promotions.promotion_id=%@",currentCity,parameters[IMPromotionIDKey]];

    }
    
    if(parameters[@"salesPriceMin"])
    {
        //code for filtering w r t sales_price_f
//        query.numericFilters = [query.numericFilters stringByAppendingFormat:@",cities_mapping.%@.sales_price_f:%@ to %@",currentCity,parameters[IMSalesPriceMinKey],parameters[IMSalesPriceMaxKey]];
        
         //code for filtering w r t promotional_price_f
         query.numericFilters = [query.numericFilters stringByAppendingFormat:@",cities_mapping.%@.promotional_price_f:%@ to %@",currentCity,parameters[IMSalesPriceMinKey],parameters[IMSalesPriceMaxKey]];
    }
    
    if(parameters[IMDiscountMinKey])
    {
        query.numericFilters = [query.numericFilters stringByAppendingFormat:@",cities_mapping.%@.discount_percent_f:%@ to %@",currentCity,parameters[IMDiscountMinKey],parameters[IMDiscountMaxKey]];
    }
    
    if(parameters[IMCategoryIdKey])
    {
        query.numericFilters = [query.numericFilters stringByAppendingFormat:@",(category_details.base_category.id=%@,category_details.primary_category.id=%@,category_details.secondary_category.id=%@)",parameters[IMCategoryIdKey],parameters[IMCategoryIdKey],parameters[IMCategoryIdKey]];
        
//        query.numericFilters = [query.numericFilters stringByAppendingFormat:@",(category_details.primary_category.id=%@)",parameters[IMCategoryIdKey]];
    }

    // featured product filtering
    if(parameters[IMFilterKey] && [parameters[IMFilterKey] isEqualToString:IMFeaturedKey])
    {
        if (facetFiltersRaw) {
            facetFiltersRaw = [facetFiltersRaw stringByAppendingFormat:@",%@:true",IMFeaturedKey];
        }
        else{
            facetFiltersRaw = [NSString stringWithFormat:@"%@:true",IMFeaturedKey];
        }
    }
    if (facetFiltersRaw) {
        query.facetFiltersRaw = facetFiltersRaw;
    }
    query.hitsPerPage = productsPerPage;
    query.page = page;
    
    [index cancelPreviousSearches];
    [index search:query
          success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *answer) {
              NSLog(@"%@",answer);
              NSArray *resultArray = [answer objectForKey:@"hits"];
              
              NSMutableArray* products = [NSMutableArray array];
              
              for (NSDictionary *productInfo in resultArray)
              {
                  IMProduct *product = [[IMProduct alloc] init];
                  product.name = [productInfo valueForKey:@"name"];
                  product.identifier = [productInfo valueForKey:@"id"];
                  product.category = [productInfo valueForKeyPath:@"category_details.name"];
                  product.isPharma = [[productInfo valueForKeyPath:@"category_details.pharma"] boolValue];
                  product.manufacturer = [productInfo valueForKey:@"manufacturer"];
                  product.brand = [productInfo valueForKey:IMBrandNameKey];
                  
                  if( [productInfo valueForKey:@"main_image_url"])
                  {
                      product.thumbnailImageURL = [productInfo valueForKey:@"main_image_url"];

                  }
                   product.innerPackageQuantity = productInfo[@"inner_package_quantity"];
                  product.unitOfSale = productInfo[@"unit_of_sale"];
                  for(NSDictionary* cityDict in productInfo[@"cities_mapping"])
                  {
                      if([cityDict.allKeys[0] isEqualToString:currentCity])
                      {
                          product.sellingPrice = cityDict[currentCity][@"sales_price"];
                          product.mrp =  cityDict[currentCity][@"mrp"];
                          product.promotionalPrice = cityDict[currentCity][@"promotional_price"];
                          product.discountPercent = cityDict[currentCity][@"discount_percent"];
                          product.discountPercentDouble = cityDict[currentCity][@"discount_percent_f"];
                          
                          //newly added attribute for add to cart from list.
                          
                          product.maxOrderQuantity = cityDict[currentCity][@"max_orderable_quantity"];
                          NSArray *allKeys = [cityDict[currentCity] allKeys];
                          product.isAvailablePresent = [allKeys containsObject:@"available"];
                          product.available = [cityDict[currentCity][@"available"] boolValue];
                          
                          product.cashback = [cityDict[currentCity][@"cash_back"] boolValue];
                          product.cashbackDescription = cityDict[currentCity][@"cash_back_desc"];

                          break;
                      }
                  }
                  [products addObject:product];
              }
              
              NSInteger totalPages = [answer[@"nbPages"] integerValue];
              NSInteger totalProducts = [answer[@"nbHits"] integerValue];
              
              completion(products,totalPages,totalProducts,answer,nil);
          } failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage)
     {
         NSDictionary *errorDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Operation couldn't be compleated",@"error", nil];
         NSError *error = [[NSError alloc] initWithDomain:@"error" code:1012 userInfo:errorDict];
         completion(nil,0,0,nil,error);
         //TODO:Check what is the error here from algolia
         //completion(nil,0,0,nil,nil);
     }];

}

- (void)cancelAutoSuggestionRequest
{
    [self.index cancelPreviousSearches];
}

-(void)fetchCategoriesWithCompletion:(void(^)(NSMutableArray* categories,NSNumber *popularCount,NSError* error))completion
{
    [[IMServerManager sharedManager] fetchCategoriesWithCompletion:^(NSDictionary* categoriesDictionary, NSError *error) {
        
        NSMutableArray* categories = nil;
        
        if([categoriesDictionary[@"categories"] count])
        {
            categories = [NSMutableArray array];
            for (NSDictionary* categoryDictionary in categoriesDictionary[@"categories"])
            {
                [categories addObject:[[IMCategory alloc] initWithDictionary:categoryDictionary]];
            }
        }
        NSNumber *popularCount = categoriesDictionary[@"popular_display_count"];
        
        completion(categories,popularCount,error);
    }];
}

-(void)fetchSubCategoriesWithCategoryId:(NSNumber *)catId Completion:(void(^)(NSMutableArray* categories,NSMutableArray* offers,NSMutableArray* popularBrands, NSNumber *popularCount,NSString *categoryName, NSError* error))completion
{
    [[IMServerManager sharedManager] fetchCategoriesWithId:catId Completion:^(NSDictionary *categoriesDictionary, NSError *error) {
                
        NSMutableArray* categories = nil;
        NSMutableArray* offers = nil;
        NSMutableArray* popularBrands = nil;

        if([categoriesDictionary[@"category"] count])
        {
            categories = [NSMutableArray array];
            for (NSDictionary* categoryDictionary in categoriesDictionary[@"category"][@"children"])
            {
                [categories addObject:[[IMCategory alloc] initWithDictionary:categoryDictionary]];
            }
        }
        
        if([categoriesDictionary[@"category"][@"banners"] count])
        {
            offers = [NSMutableArray array];
            for (NSDictionary* offerDictionary in categoriesDictionary[@"category"][@"banners"])
            {
                [offers addObject:[[IMOffer alloc] initWithDictionary:offerDictionary]];
            }
        }
        
        if([categoriesDictionary[@"category"][@"popular_brands"] count])
        {
            popularBrands = [NSMutableArray array];
            for (NSDictionary* brandDictionary in categoriesDictionary[@"category"][@"popular_brands"])
            {
                [popularBrands addObject:[[IMBrand alloc] initWithDictionary:brandDictionary]];
            }
        }
        NSNumber *popularCount = categoriesDictionary[@"category"][@"popular_display_count"];
        NSString *categoryName = categoriesDictionary[@"category"][@"name"];
        
        completion(categories,offers,popularBrands,popularCount,categoryName,error);
    }];
}

-(void)fetchFeaturedCategoriesWithCompletion:(void(^)(NSMutableArray* categories,NSMutableArray* promotions, NSError* error))completion
{
    [[IMServerManager sharedManager] fetchFeaturedCategoriesWithCompletion:^(NSDictionary *dictionary, NSError *error)
    {
        NSMutableArray* categories = nil;
        NSMutableArray* promotions = nil;

        if([dictionary[@"categories"] count])
        {
            categories = [NSMutableArray array];
            for (NSDictionary* categoryDictionary in dictionary[@"categories"])
            {
                [categories addObject:[[IMCategory alloc] initWithDictionary:categoryDictionary]];
            }
        }
        
        if([dictionary[@"promotions"] count])
        {
            categories = [NSMutableArray array];
            for (NSDictionary* promotionDictionary in dictionary[@"promotions"])
            {
                [promotions addObject:[[IMCategory alloc] initWithDictionary:promotionDictionary]];
            }
        }
        completion(categories,promotions,error);
    }];
}


-(void)fetchRecentlyOrderedPharmaProductsWithCount:(NSInteger)count completion:(void (^)(NSArray *pharmaProducts,NSError * error))completion
{
    NSString* queryString = @"";
    
    if(count)
    {
        queryString = [NSString stringWithFormat:@"?count=%ld",(long)count];
    }
    
    [[IMServerManager sharedManager] fetchRecentlyOrderedPharmaProductsWithQueryString:queryString withCompletion:^(NSDictionary *productsDict, NSError *error)
    {
        NSMutableArray* products = [NSMutableArray array];
        if(!error)
        {
            for (NSDictionary* productDict in productsDict[@"recent_pharma_items"])
            {
                IMProduct* product  = [[IMProduct alloc] init];
                product.name = productDict[@"name"];
                product.identifier = productDict[@"id"];
                product.manufacturer = productDict[@"manufacturer_name"];
                product.thumbnailImageURL = productDict[@"main_image_url"];
                product.isPharma = YES;
                product.category = @"pharmacy";
                product.mrp = productDict[@"mrp"];
                product.sellingPrice = productDict[@"sales_price"];
                product.discountPercent = productDict[@"discount_percent"];
                product.promotionalPrice = productDict[@"promotional_price"];
                //Support for newly added attributes
                product.maxOrderQuantity =  productDict[@"max_orderable_quantity"];
                product.unitOfSale = productDict[@"unit_of_sale"];
                product.innerPackageQuantity = productDict[@"inner_package_quantity"];
                
                NSArray *allKeys = [productDict allKeys];
                product.isAvailablePresent = [allKeys containsObject:@"available"];
                product.available = [productDict[@"available"] boolValue];
                [products addObject:product];
            
            }
        }
        completion(products,error);
    }];
}

-(void)fetchProductDetailWithId:(NSNumber*)productId withCompletion:(void(^)(IMProduct* product,NSError* error))completion

{
    [[IMServerManager sharedManager] fetchProductDetailWithId:productId withCompletion:^(NSDictionary *productDict, NSError *error) {
        
        IMProduct* product = nil;
        if(!error)
        {
            product = [[IMProduct alloc] initWithDictionary:productDict];
        }
        completion(product,error);
    }];
    
}

-(void) notifyUserForProductWithID:(NSNumber*)productId andUserDictionary:(NSDictionary*)userDictionary withCompletion:(void(^)(NSError* error))completion
{
    [[IMServerManager sharedManager] notifyUserForProductWithID:productId andUserDictionary:userDictionary withCompletion:^(NSError *error) {
        completion(error);
    }];
}



@end
