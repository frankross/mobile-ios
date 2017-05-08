//
//  IMFAQ.m
//  InstaMed
//
//  Created by Yusuf Ansar on 04/03/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMFAQ.h"

NSString* const IMQuestionKey = @"question";
NSString* const IMAnswerKey = @"answer";

@implementation IMFAQ

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        self.question = dictionary[IMQuestionKey];
        self.answer = dictionary[IMAnswerKey];
    }
    return self;
}

@end
