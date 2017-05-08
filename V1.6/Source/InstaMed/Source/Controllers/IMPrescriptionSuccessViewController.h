//
//  IMPrescriptionSuccessViewController.h
//  InstaMed
//
//  Created by Suhail K on 16/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing prescription submission completion and upload another prescription.

#import "IMBaseViewController.h"

@class IMCart;

@interface IMPrescriptionSuccessViewController : IMBaseViewController

@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) IMCart *cart;

@end
