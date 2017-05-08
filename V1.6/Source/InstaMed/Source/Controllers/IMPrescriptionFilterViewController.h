//
//  IMPrescriptionFilterViewController.h
//  InstaMed
//
//  Created by Suhail K on 02/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseViewController.h"

@interface IMPrescriptionFilterViewController : IMBaseViewController

@property(nonatomic,copy) void(^completionBlock)(NSMutableArray* patients,NSMutableArray *doctors);
@property(nonatomic,strong) NSMutableArray* selectedPatients;
@property(nonatomic,strong) NSMutableArray* selectedDoctors;
@property (strong, nonatomic) NSMutableArray *patientList;
@property (strong, nonatomic) NSMutableArray *doctorList;

@end
