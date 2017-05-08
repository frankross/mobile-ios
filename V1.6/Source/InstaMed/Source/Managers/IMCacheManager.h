//
//  IMCacheManager.h
//  InstaMed
//
//  Created by Suhail K on 23/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

//Tp manage caching like recent serach, non login cart
@interface IMCacheManager : NSObject

+ (IMCacheManager *)sharedManager;

- (void)saveActionWithDictionary:(NSDictionary *)dataDict;
- (NSDictionary *)retriveDataFromPlist;
- (void)clearCache;

-(void)saveCartItems:(NSArray*)items;
-(NSMutableArray*)getCartItems;
-(void)clearCartItems;

@end
