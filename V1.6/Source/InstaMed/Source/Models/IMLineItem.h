//
//  IMCartCell.h
//  InstaMed
//
//  Created by Suhail K on 22/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMLineItem : IMBaseModel

@property (strong, nonatomic) NSNumber * varientId;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * brand;
@property(strong,nonatomic) NSString* imageURL;

@property (strong, nonatomic) NSString * innerPackingUnit;
@property (assign, nonatomic) BOOL isPrescriptionRequired;
@property (assign,nonatomic) BOOL isPrescriptionAvailable;
@property ( nonatomic) NSInteger quantity;
@property (nonatomic,strong) NSNumber* maxOrderQuanitity;

@property ( nonatomic) NSString* innerPackingQuantity;
@property (nonatomic, assign, getter=isCashBackAvailable) BOOL cashback;
@property (nonatomic, strong) NSString *cashbackDescription;

@property (strong, nonatomic) NSNumber * mrp;
@property (strong, nonatomic) NSNumber * salesPrice;
@property (strong, nonatomic) NSNumber * promotionalPrice;
@property (strong, nonatomic) NSNumber * discountPercentage;

@property (strong, nonatomic) NSNumber * totalPrice;
@property (strong, nonatomic) NSNumber * discountMrp;

@property (nonatomic,strong) NSString* unitOfSales;
@property(nonatomic,assign) BOOL isAvailable;
@property(nonatomic,assign) BOOL isActive; 
@property(nonatomic) BOOL isPharma;
@property(nonatomic,strong) NSNumber* offerPrice;
@property (nonatomic, strong) NSString *prescriptionMessage;


-(NSDictionary*)dictionaryForAddToCart;






@end
