//
//  IMProductDosage.h
//  InstaMed
//
//  Created by Suhail K on 29/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMProductDosage : IMBaseModel

@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *quantity;
@property(nonatomic, strong) NSString *productUnit;
@property(nonatomic, strong) NSString *foodInstruction;
@property(nonatomic, strong) NSString *duration;
@property(nonatomic, strong) NSString *specificTimings;
@property(nonatomic,strong) NSString* frequency;
@property(nonatomic) BOOL timeMorning;
@property(nonatomic) BOOL timeNight;
@property(nonatomic) BOOL timeAfternoon;
@property (nonatomic) BOOL timeEvening;
@property (nonatomic) BOOL sos;
@property(nonatomic, strong) NSString *remarks;

@end
