//
//  IMSortType.h
//  InstaMed
//
//  Created by Arjuna on 08/07/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

typedef enum : NSUInteger {
   
    IMSalesPriceLowToHigh = 1,
    IMSalesPriceHighToLow

} IMSortOptions;

@interface IMSortType : IMBaseModel

@property(nonatomic,strong) NSString* name;
@property(nonatomic) IMSortOptions option;

@end
