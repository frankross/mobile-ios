//
//  IMPDPTextDetailViewController.h
//  InstaMed
//
//  Created by Suhail K on 10/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Common Class for managing descriptions.

typedef enum
{
    IMActiveIngridients = 0,
    IMOtherInfo = 1
}
IMInfoType;
#import "IMBaseViewController.h"

@interface IMPDPTextDetailViewController : IMBaseViewController

@property(nonatomic,strong) NSString* information;
@property(nonatomic, assign) IMInfoType infoType;

@end
