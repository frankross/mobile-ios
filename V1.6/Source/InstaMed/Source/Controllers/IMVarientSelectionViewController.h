//
//  IMVarientSelectionViewController.h
//  InstaMed
//
//  Created by Suhail K on 21/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"
#import "IMVarient.h"
#import "IMVarientSelction.h"
#import "IMProduct.h"
#import "IMVarientValue.h"

@protocol IMVarientSelectionDelegate <NSObject>

- (void)didSelectVarient:(IMVarientSelction *)varient;

@end

@interface IMVarientSelectionViewController : IMBaseViewController

@property (nonatomic) BOOL isPrimary;
//@property (nonatomic, strong) NSString* selectedPrimary;
@property (nonatomic, strong) NSString* lastSelectedValue;
@property (nonatomic, strong) IMProduct *product;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, strong) IMVarientSelction *varientSelctionModel;
@property (nonatomic, strong) NSString *selectedString;
@property(nonatomic, weak) id<IMVarientSelectionDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedVariants;

@end
