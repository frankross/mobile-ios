//
//  IMRewardPointTransaction.h
//  InstaMed
//
//  Created by Yusuf Ansar on 12/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMRewardPointTransaction : IMBaseModel

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *amount;


@end
