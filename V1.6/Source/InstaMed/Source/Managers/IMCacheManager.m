//
//  IMCacheManager.m
//  InstaMed
//
//  Created by Suhail K on 23/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCacheManager.h"

#define AUTO_SUGGESTION_LIMIT 10
@implementation IMCacheManager


+(IMCacheManager*)sharedManager
{
    static IMCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}


- (void)saveActionWithDictionary:(NSDictionary *)dataDict
{
    NSString *plistPath = [self filePath];
    NSDictionary *dict = [self retriveDataFromPlist];
    NSMutableArray *pharmaArray;
    NSMutableArray *nonPharmaArray;
    pharmaArray = dict[@"pharma"];
    nonPharmaArray = dict[@"nonPharma"];
    
    if([dataDict[IMIsPharma] isEqualToNumber:@(1)])
    {
        if(dict.count)
        {
            if(pharmaArray.count)
            {
                if([pharmaArray containsObject:dataDict])
                {
                    [pharmaArray removeObject:dataDict];
                }
                if(pharmaArray.count == AUTO_SUGGESTION_LIMIT)
                {
                    [pharmaArray removeObjectAtIndex:0];
                }
                [pharmaArray addObject:dataDict];
            }
            else
            {
                pharmaArray = [[NSMutableArray alloc] init];
                if(pharmaArray.count == AUTO_SUGGESTION_LIMIT)
                {
                    [pharmaArray removeObjectAtIndex:0];
                }
                [pharmaArray addObject:dataDict];
            }
        }
        else
        {
            pharmaArray = [[NSMutableArray alloc] init];
            if(pharmaArray.count == AUTO_SUGGESTION_LIMIT)
            {
                [pharmaArray removeObjectAtIndex:0];
            }
            [pharmaArray addObject:dataDict];
        }
    }
    else
    {
        if(dict.count)
        {
            if(nonPharmaArray.count)
            {
                if([nonPharmaArray containsObject:dataDict])
                {
                    [nonPharmaArray removeObject:dataDict];
                }
                if(nonPharmaArray.count == AUTO_SUGGESTION_LIMIT)
                {
                    [nonPharmaArray removeObjectAtIndex:0];
                }
                [nonPharmaArray addObject:dataDict];
            }
            else
            {
                nonPharmaArray = [[NSMutableArray alloc] init];
                if(nonPharmaArray.count == AUTO_SUGGESTION_LIMIT)
                {
                    [nonPharmaArray removeObjectAtIndex:0];
                }
                [nonPharmaArray addObject:dataDict];
            }
        }
        else
        {
            if(!pharmaArray.count)
            {
                pharmaArray = [[NSMutableArray alloc] init];
            }
            nonPharmaArray = [[NSMutableArray alloc] init];
            if(nonPharmaArray.count == AUTO_SUGGESTION_LIMIT)
            {
                [nonPharmaArray removeObjectAtIndex:0];
            }
            [nonPharmaArray addObject:dataDict];
        }
    }
    
    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjectsAndKeys:pharmaArray,@"pharma",nonPharmaArray,@"nonPharma", nil];
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
    }
}

- (NSDictionary *)retriveDataFromPlist
{
    NSString *plistPath = [self filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"RecentlySearched" ofType:@"plist"];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return dict;
}

- (void)clearCache
{
    NSString *plistPath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"RecentlySearched.plist"];
    return plistPath;
}


-(NSString*)cartCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Cart.plist"];
    return plistPath;

}

-(void)saveCartItems:(NSArray*)items
{
    [items writeToFile:[self cartCachePath] atomically:YES];
}


-(NSMutableArray*)getCartItems
{
    return [NSMutableArray  arrayWithContentsOfFile:[self cartCachePath]];
}


-(void)clearCartItems
{
    NSString *plistPath = [self cartCachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }

}

@end
