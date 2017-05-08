//
//  IMSubmitPrescriptionViewController.h
//  InstaMed
//
//  Created by Suhail K on 11/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing prescription submission.

#import "IMBaseViewController.h"
#import "IMUploadPrescriptionViewController.h"

typedef enum
{
    IMCamera = 0,
    IMGallery
}IMPicMode;

@class IMCart;

@protocol IMSubmitPrescriptionViewControllerDelegate <NSObject>

- (void)retakePressedWithPicMode:(IMPicMode)picMode;

@end

@interface IMSubmitPrescriptionViewController : IMBaseViewController

@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, assign) IMPicMode selectedPicMode;
@property(nonatomic, strong) IMCart* cart;
@property (nonatomic, assign) IMPrescriptionType prescriptionType;

@property (weak, nonatomic) id delegate;

@end
