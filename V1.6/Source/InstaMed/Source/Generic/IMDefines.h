//
//  IMDefines.h
//  InstaMed
//
//  Created by Suhail K on 21/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#ifndef InstaMed_IMDefines_h
#define InstaMed_IMDefines_h

#define APP_DELEGATE (IMAppDelegate*)  [[UIApplication sharedApplication] delegate]

//#define APP_THEME_COLOR ([UIColor colorWithRed:125.0/255.0 green:185.0/255.0 blue:83.0/255.0 alpha:1])

//#define APP_THEME_COLOR ([UIColor colorWithRed:137.0/255.0 green:206.0/255.0 blue:86.0/255.0 alpha:1])// Light green
#define APP_THEME_COLOR ([UIColor colorWithRed:20.0/255.0 green:144.0/255.0 blue:111.0/255.0 alpha:1])// dark green

//#define APP_THEME_COLOR ([UIColor colorWithRed:79.0/255.0 green:235.0/255.0 blue:193.0/255.0 alpha:1])

//#define APP_THEME_COLOR_WITH_ALPHA ([UIColor colorWithRed:137.0/255.0 green:206.0/255.0 blue:86.0/255.0 alpha:0.6]) // light green

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

#define APP_THEME_COLOR_WITH_ALPHA ([UIColor colorWithRed:20.0/255.0 green:144.0/255.0 blue:111.0/255.0 alpha:0.6])// dark green
#define CART_BADGE_COLOR ([UIColor whiteColor])
#define CART_CELL_BACKGROUND_COLOR_DISABLED ([UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1])
#define CART_CELL_BACKGROUND_COLOR_ENABLED ([UIColor whiteColor])

#define SEARCH_BACKGROUND_COLOR ([UIColor colorWithRed:161.0/255.0 green:211.0/255.0 blue:197.0/255.0 alpha:1])
#define COUPON_LABEL_BACKGROUND_COLOR ([UIColor colorWithRed:206.0/255.0 green:231.0/255.0 blue:225.0/255.0 alpha:1])// light green
#define COUPON_LABEL_BACKGROUND_COLOR_FOR_EXPIRED_STATE ([UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2])// light red
#define COUPON_LABEL_TEXT_COLOR_FOR_APPLIED_STATE ([UIColor colorWithRed:10.0/255.0 green:144.0/255.0 blue:111.0/255.0 alpha:1])// light green

#define PRODUCT_LIST_HEADER_HEIGHT 60

#define SET_CELL_BORDER_AND_SHADOW(_VIEW_)\
_VIEW_.layer.borderWidth      = 1.0f;\
_VIEW_.layer.borderColor      = [UIColor colorWithRed:239.0/255.0 green:240.0/255.0 blue:226.0/255.0 alpha:1].CGColor;\
_VIEW_.layer.masksToBounds    = NO;\
_VIEW_.layer.shadowColor      = UIColorFromRGB(0xDDDDDD).CGColor;\
_VIEW_.layer.shadowOpacity    = 1.0;\
_VIEW_.layer.shadowOffset     = CGSizeMake(2.0f, 2.0f);

#define SET_CELL_CORER(_VIEW_,_RADIUS_)\
_VIEW_.layer.cornerRadius      = _RADIUS_;\
_VIEW_.layer.masksToBounds    = YES;


#define SET_FOR_YOU_CELL_BORDER(_VIEW_,_COLOR_,_RADIUS_)\
_VIEW_.layer.borderWidth      = 1.0f;\
_VIEW_.layer.borderColor      = _COLOR_.CGColor;\
_VIEW_.layer.cornerRadius      = _RADIUS_;\
_VIEW_.layer.masksToBounds    = YES;



#define ADD_SHADOW_IMAGE(_VIEW_)\
CGRect rect = _VIEW_.frame;\
UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, rect.size.height, rect.size.width, 2.0f)];\
shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;\
shadowView.backgroundColor = [UIColor colorWithPatternImage:[HLNResourceManager sharedManager].shadowImage];\
[_VIEW_ addSubview:shadowView];

#define IS_IPAD ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1 : 0)


#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
#define IS_IOS10_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))


#define HomeTabIndex 0
#define CategoriesTabIndex 1
#define MYAccountTabIndex 2
#define SupportTabIndex 3
#define MoreTabIndex 4


#define DIGITIZATION_FAILD @"1"
#define CART_PREPARED_FOR_YOU @"2"
#define ORDER_REVISION @"3"
#define ORDER_STATUS_UPDATION @"4"
#define GENERAL_FOR_USER @"5"
#define GENERAL_FOR_COMMON @"6"

#define PRESCRIPTION_DETAIL @"7"
#define NOTIFICATION_TYPE_TEN @"10"
#define NOTIFICATION_TYPE_ELEVEN @"11"
#define NOTIFICAION_TYPE_TWELVE @"12"
#define NOTIFICATION_TYPE_THIRTEEN @"13"
#define NOTIFICATION_TYPE_FOURTEEN @"14"
#define NOTIFICATION_TYPE_FIFTEEN @"15"
#define NOTIFICATION_TYPE_SIXTEEn @"16"
#define NOTIFICATION_TYPE_SEVENTEEN @"17"
#define NOTIFICATION_TYPE_EIGHTEEN @"18"

#define PHARMA_DETAIL @"100"
#define NON_PHARMA_DETAIL @"101"


#endif
