//
//  IMSupportUtility.h
//  InstaMed
//
//  Created by Kavitha on 04/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface IMSupportUtility : NSObject

/*
 Returns location from latitude and longitude strings
 */
+ (CLLocation*) locationFromLatitude:(NSString*) latitude
                           longitude:(NSString*) longitude;
/*
 First checks for Google Map app, if present then show direction from source to destination in Google Map.
 Otherwise loads Google Map in browser
 */

+ (void) loadDirectionsMap:(CLLocation *)srcLocation destination:(CLLocation*)dstLocation;
+ (void) loadDirectionsMap;
/*
 Opens Phone app with the input phone number dialled in.
 Returns a boolean value indicating whether the Phone app could be opened or not
 */
+(BOOL) callNumber:(NSString*) phoneNumber;

@end
