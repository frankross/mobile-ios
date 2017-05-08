//
//  IMBaseModel.h
//  InstaMed
//
//  Created by Suhail K on 14/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>



@interface IMBaseModel : NSObject<NSCoding>

@property (nonatomic,strong) NSNumber* identifier;

-(id)initWithDictionary:(NSDictionary*)dictionary;
-(NSMutableDictionary*)dictinaryRepresentation;

@end
