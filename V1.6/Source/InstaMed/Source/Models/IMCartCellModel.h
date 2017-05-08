//
//  IMCartCell.h
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "IMBaseModel.h"

@interface IMCartCellModel : IMBaseModel

@property (strong, nonatomic) NSNumber * varientId;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * brand;
@property (nonatomic) CGFloat price;
@property (strong, nonatomic) NSString * unit;
@property (strong, nonatomic) NSString * innerPackingUnit;
@property (assign, nonatomic) BOOL isPrescriptionRequired;
@property ( nonatomic) NSInteger quantity;
@property (nonatomic,strong) NSNumber* maxOrderQuanitity;

@property ( nonatomic) NSInteger innerPackingQuantity;

@property (strong, nonatomic) NSString * mrp;
@property (strong, nonatomic) NSString * salesPrice;
@property (strong, nonatomic) NSString * totalPrice;
@property (strong, nonatomic) NSString * discountMrp;





-(NSDictionary*)dictionaryForAddToCart;






@end
