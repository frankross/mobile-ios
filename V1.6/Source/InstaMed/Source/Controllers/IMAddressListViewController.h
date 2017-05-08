//
//  IMAddressListViewController.h
//  InstaMed
//
//  Created by Arjuna on 19/06/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//


//Class for managing address listing.

#import "IMBaseViewController.h"
#import "IMAddress.h"


@protocol IMAddressListViewControllerDelegate <NSObject>
@optional

-(void)didLoadWithAddressTableViewHeight:(CGFloat)height;
-(void)didSelectAddress:(IMAddress*)address;

@end


typedef enum
{
    IMMyAccountAddressList,
    IMDeliveryAddressList
}IMAddressListType;

@interface IMAddressListViewController : IMBaseViewController

@property IMAddressListType addressType;

@property(weak,nonatomic) id<IMAddressListViewControllerDelegate> delegate;

@end
