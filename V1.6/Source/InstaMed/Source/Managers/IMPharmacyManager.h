//
//  IMPharmacyManager.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "IMProduct.h"
#import "IMOffer.h"
#import "IMCategory.h"
#import "IMBrand.h"

extern NSString* const IMCategoryIdKey;
extern NSString* const IMBrandNameKey;
extern NSString* const IMSortTypeKey;
extern NSString* const IMDiscountMinKey ;
extern NSString* const IMDiscountMaxKey;
extern NSString* const IMSalesPriceMaxKey;
extern NSString* const IMSalesPriceMinKey;
extern NSString* const IMFeaturedKey;
extern NSString* const IMFilterKey;
extern NSString* const IMPrimaryCategoryKey;
extern NSString* const IMPromotionIDKey;

//Categories,Products and categories listing and search, filters
@interface IMPharmacyManager : NSObject

@property (nonatomic, assign) BOOL isCatOfferLaunchDone;
+(IMPharmacyManager*)sharedManager;

#pragma mark - Categories/Promotions -

-(void)fetchFeaturedCategoriesWithCompletion:(void(^)(NSMutableArray* categories,NSMutableArray* promotions, NSError* error))completion;


-(void)fetchCategoriesWithCompletion:(void(^)(NSMutableArray* categories,NSNumber *popularCount, NSError* error))completion;

-(void)fetchSubCategoriesWithCategoryId:(NSNumber *)catId Completion:(void(^)(NSMutableArray* categories,NSMutableArray* offers,NSMutableArray* popularBrands, NSNumber *popularCount, NSString *categoryname, NSError* error))completion;

#pragma mark - Products -

-(void)fetchProductsForParametrs:(NSDictionary*)parameters  inPage:(NSInteger)page productsPerPage:(NSUInteger)productsPerPage withCompletion:(void(^)(NSArray* products , NSInteger totalPageCount,NSInteger totalProductCount,NSDictionary* facetInfo, NSError* error))completion;

-(void)fetchProductDetailWithId:(NSNumber*)productId withCompletion:(void(^)(IMProduct* product,NSError* error))completion;

-(void)fetchAutoSuggestionsForSearchTerm:(NSString*)searchTerm withCompletion:(void (^)(NSArray *pharmaProducts,NSArray *nonPharmaProducts,NSError * error))completion;
- (void)cancelAutoSuggestionRequest;

-(void)fetchRecentlyOrderedPharmaProductsWithCount:(NSInteger)count completion:(void (^)(NSArray *pharmaProducts,NSError * error))completion;


#pragma mark - Offers -

-(void)fetchOffersWithCompletion:(void(^)(NSArray* offerBanners,NSArray* offerStores,NSError* error))completion;

-(void) fetchOffersForListingPageWithCompletion:(void (^)(NSDictionary *offers,NSError *error))completion;

-(void) notifyUserForProductWithID:(NSNumber*)productId andUserDictionary:(NSDictionary*)userDictionary withCompletion:(void(^)(NSError* error))completion;

@end
