//
//  IMNotification.h
//  InstaMed
//
//  Created by Yusuf Ansar on 04/04/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"


@interface IMNotification : IMBaseModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *notificationType;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *couponCode;
@property (nonatomic, strong) NSString *htmlURL;
@property (nonatomic, assign) BOOL isPharma;

@end
