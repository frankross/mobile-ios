//
//  IMDatatypes.h
//  InstaMed
//
//  Created by Yusuf Ansar on 24/10/16.
//  Copyright (c) 2016, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#ifndef IMDatatypes_h
#define IMDatatypes_h


typedef NS_ENUM(NSInteger, IMNotificationType)
{
    IMDigitizationFailedNotification = 1,
    IMCartPreparedForYouNotification = 2,
    IMOrderRevisionNotification = 3,
    IMOrderStatusUpdationNotification = 4,
    IMGeneralForUserNotification = 5,
    IMGeneralForCommonNotification = 6,
    IMPrescriptionDetailNotification = 7,
    IMHomeNotification = 10,
    IMCategoryPageNotification = 11,
    IMPromotionDetailNotification = 12,
    IMHomePromotionNotification = 13,
    IMCategoryPromotionNotification = 14,
    IMPromotionWebPageNotification = 15,
    IMReferAFriendNotification = 16,
    IMProductDetailNotification = 17,
    IMHealthArticlesNotification = 18
    
};

#endif /* IMDatatypes_h */
