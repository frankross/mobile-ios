//
//  IMCart.h
//  InstaMed
//
//  Created by Arjuna on 25/07/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "IMBaseModel.h"
#import "IMLineItem.h"
#import "IMDeliverySlot.h"
#import "IMAddress.h"

typedef enum : NSUInteger {
    IMUserCartCheckout,
    IMReoder,
    IMBuyNow,
    IMDigitizationFail,
    IMInvalidDeliverySlot,
    IMInsufficientInventory
} IMCartOperationType;





@interface IMCart : IMBaseModel

@property(nonatomic,strong) NSNumber* orderId;
@property(nonatomic,strong) NSNumber* shippingsTotal;
@property(nonatomic,strong) NSNumber* lineItemsTotal;
@property(nonatomic,strong) NSNumber* discountTotal;
@property(nonatomic,strong) NSNumber* cartTotal;
@property(nonatomic,strong) NSMutableArray* lineItems;
@property(nonatomic,strong) IMAddress* deliverAddress;
@property(nonatomic,strong) IMDeliverySlot* deliverySlot;
@property(nonatomic,strong) NSString* prescriptionUploadId;
@property(nonatomic)IMCartOperationType cartOperationType;



-(NSDictionary*)dictionaryForOrderComplete;


@end
