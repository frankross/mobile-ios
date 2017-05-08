//
//  IMPrescription.m
//  InstaMed
//
//  Created by Suhail K on 27/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMPrescription.h"
#import "IMProductDosage.h"

@implementation IMPrescription

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        self.referenceNumber = dictionary[@"refNo"];
        self.date = dictionary[@"date"];
        self.expiryDate = dictionary[@"expiryDate"];
        self.isExpired = [dictionary[@"isExpired"] isEqualToString:@"1"];
        self.moreCount = dictionary[@"moreCount"];
     
        if(dictionary[@"patientName"])
        {
           self.patient = [[IMPatient alloc] init];
           self.patient.name = dictionary[@"patientName"];
        }
        else
        {
            self.patient = [[IMPatient alloc] initWithDictionary:dictionary[@"patient"]];
        }
        
        
        if(dictionary[@"doctorName"])
        {
            self.doctor = [[IMDoctor alloc] init];
            self.doctor.name = dictionary[@"doctorName"];
        }
        else
        {
            self.doctor = [[IMDoctor alloc] initWithDictionary:dictionary[@"doctor"]];
        }
        
        if( dictionary[@"dosage"])
        {
          self.dosageList = dictionary[@"dosage"];
        }
        
        else if(dictionary[@"line_items"])
        {
        
            NSMutableArray* productDosageArray = dictionary[@"line_items"];
            
           self.dosageList = [NSMutableArray array];
            
            for(NSDictionary* productDosageDict in productDosageArray)
            {
                IMProductDosage* productDosage = [[IMProductDosage alloc] initWithDictionary:productDosageDict];
                [self.dosageList addObject:productDosage];
            }
        }
        
        self.symptoms = dictionary[@"symptoms"];
        self.diagnosis = dictionary[@"diagnosis"];
        self.testsPrescribed = dictionary[@"testsPrescribed"];
        self.notesAndDirections = dictionary[@"notesAndDirections"];
        self.remarks = dictionary[@"remarks"];
        
    }
    return self;
}

@end
