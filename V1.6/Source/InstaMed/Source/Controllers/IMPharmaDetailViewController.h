//
//  IMPharmaDetailViewController.h
//  InstaMed
//
//  Created by Arjuna on 09/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing pharma product detail.

#import <UIKit/UIKit.h>
#import "IMProduct.h"
#import "IMBaseViewController.h"

typedef enum
{
    IMProductDetail       = 0,
    IMAttrbutes      = 1,
    IMBasicInfo   = 2,
    IMMoreInfo   =  3
}
IMPharmaDetailType;


@interface IMPharmaDetailViewController : IMBaseViewController

@property(nonatomic,strong)IMProduct* product;
@property(nonatomic) IMPharmaDetailType detailType;


@end
