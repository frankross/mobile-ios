//
//  IMSocialSharingDetails.h
//  InstaMed
//
//  Created by Yusuf Ansar on 13/05/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMBaseModel.h"

@interface IMSocialSharingDetails : IMBaseModel

@property (nonatomic, strong) NSString *emailSubject;
@property (nonatomic, strong) NSString *emailBody;
@property (nonatomic, strong) NSString *promotionalMessage;

@end

