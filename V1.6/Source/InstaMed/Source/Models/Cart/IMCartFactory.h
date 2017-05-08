//
//  IMCartFactory.h
//  InstaMed
//
//  Created by Kavitha on 25/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import "IMCart.h"

@interface IMCartFactory : NSObject

+(IMCart*) cartForOperationtype:(IMCartOperationType) type details: (NSDictionary*) details;

@end
