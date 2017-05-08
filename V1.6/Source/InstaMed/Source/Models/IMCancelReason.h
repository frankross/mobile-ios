//
//  IMCancelReason.h
//  InstaMed
//
//  Created by Arjuna on 24/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMCancelReason : IMBaseModel

@property (nonatomic,strong) NSString* reason;
@property (nonatomic,strong) NSString* remarks;

-(NSDictionary*)dictionaryForCancelling;

@end
