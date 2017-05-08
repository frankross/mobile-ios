//
//  IMFAQ.h
//  InstaMed
//
//  Created by Yusuf Ansar on 04/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMFAQ : IMBaseModel

@property(nonatomic,strong) NSString* question;
@property(nonatomic,strong) NSString* answer;

@property (nonatomic) BOOL showingAnswer;
@end
