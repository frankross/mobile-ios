//
//  IMPrescription.h
//  InstaMed
//
//  Created by Suhail K on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"
#import "IMPatient.h"
#import "IMDoctor.h"
#import "IMProductDosage.h"


@interface IMPrescription : IMBaseModel

@property (strong, nonatomic) NSString *referenceNumber;
@property (strong, nonatomic) IMPatient *patient;
@property (strong, nonatomic) IMDoctor *doctor;
@property (strong, nonatomic) NSMutableArray  *dosageList;
@property (strong,nonatomic) NSMutableDictionary* dosageScheduleDictionary;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *expiryDate;
@property (assign, nonatomic)BOOL isExpired;

@property (nonatomic,strong) NSString* symptoms;
@property (nonatomic,strong) NSString* diagnosis;
@property (nonatomic,strong) NSString* testsPrescribed;
@property (nonatomic,strong) NSString* notesAndDirections;
@property(nonatomic,strong) NSString* remarks;
@property (nonatomic,strong) NSNumber* moreCount;

@end
