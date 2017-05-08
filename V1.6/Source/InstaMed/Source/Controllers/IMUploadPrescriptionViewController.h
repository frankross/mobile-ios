//
//  IMUploadPrescriptionViewController.h
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing prescription upload initial screen.

typedef enum
{
    IMFromOrder,
    IMFromOthers
}
IMPrescriptionType;

#import "IMBaseViewController.h"

@class IMCart;

@interface IMUploadPrescriptionViewController : IMBaseViewController
@property (nonatomic, assign) IMPrescriptionType prescriptionType;
@property(nonatomic,strong) IMCart* cart;
@end
