//
//  IMCategory.h
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMCategory : IMBaseModel

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *imageURL;
@property(strong,nonatomic) NSMutableArray* subCategories;
@property (nonatomic) BOOL isPharmaProduct;
@property(strong, nonatomic) NSString *homeIconImageURL;

@end
