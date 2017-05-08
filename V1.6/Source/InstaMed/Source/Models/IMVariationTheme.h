//
//  IMVariationTheme.h
//  InstaMed
//
//  Created by Kavitha on 31/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>

@interface IMVariationTheme : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSMutableArray *supportedValues;

@end
