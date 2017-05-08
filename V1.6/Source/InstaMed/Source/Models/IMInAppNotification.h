//
//  IMInAppNotification.h
//  InstaMed
//
//  Created by Yusuf Ansar on 24/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMInAppNotification : IMBaseModel

@property (nonatomic, assign) IMNotificationType notificationType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *sentDate;
@property (nonatomic, strong) NSNumber *promotionID;
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, strong) NSNumber *variantID;
@property (nonatomic, strong) NSNumber *prescriptionID;
@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, strong) NSString *couponCode;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *htmlURL;
@property (nonatomic, assign) BOOL isPharma;

@property (nonatomic, assign) BOOL isUnread;

@end
