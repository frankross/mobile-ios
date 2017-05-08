//
//  IMCartUtility.m
//  InstaMed
//
//  Created by Kavitha on 25/08/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMCartUtility.h"
#import "IMCartFactory.h"

@implementation IMCartUtility

+(IMCart*)getCartFromOrder:(IMOrder*)order forType:(IMCartOperationType)type
{
    IMCart *cart = [IMCartFactory cartForOperationtype:type details:nil];
    cart.lineItems = order.orderedItems;
    cart.deliveryAddress = order.deliveryAddress;
    cart.deliverySlot = order.deliverySlot;
    cart.orderId = order.identifier;
    cart.discountTotal = [NSNumber numberWithFloat:order.discountsTotal.floatValue];
    cart.shippingsTotal = [NSNumber numberWithFloat:order.shippingCharges.floatValue];
    cart.cartTotal = [NSNumber numberWithFloat:order.totalAmount.floatValue];
    cart.netPayableAmount = [NSNumber numberWithFloat:order.totalAmount.floatValue];
    cart.lineItemsTotal = [NSNumber numberWithFloat:order.lineItemsTotal.floatValue];
    cart.shippingDescription = order.shippingDescription;
    cart.prescriptionDetails = order.prescriptionDetails;
    cart.patientName = order.patientName;
    cart.doctorName = order.doctorName;
    cart.patientDetailRequired = order.patientDetailRequired;
    cart.promotionDiscountTotal = [NSNumber numberWithFloat:order.promotionDiscountTotal.floatValue];
    cart.atTheTimeOfDeliveryAllowed = order.atTheTimeOfDeliveryAllowed;

    return cart;
}//

+ (NSAttributedString*) bold:(NSString*) boldString inText:(NSString*) fullString
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    
    NSRange boldedRange = [fullString rangeOfString:boldString];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:font
                       range:boldedRange];
    
    [attrString endEditing];
    return attrString;
}

+ (NSAttributedString*) bulletedParagraphString:(NSString*) paragraph
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:paragraph];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:3];
    [paragraphStyle setParagraphSpacingBefore:3];
    [paragraphStyle setFirstLineHeadIndent:0.0f];  // First line is the one with bullet point
    [paragraphStyle setHeadIndent:10.5f];    // Set the indent for given bullet character and size font
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                             range:NSMakeRange(0, [paragraph length])];
    
    return attributedString;
}

+ (NSAttributedString*) strikeThroughText:(NSString*) textToStrikeThrough
{
    NSNumber *strikeSize = [NSNumber numberWithInt:2];
    NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:strikeSize
                                                                       forKey:NSStrikethroughStyleAttributeName];
    NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:textToStrikeThrough attributes:strikeThroughAttribute];
    return strikeThroughText;
}
@end
