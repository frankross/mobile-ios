//
//  IMSupportUtility.m
//  InstaMed
//
//  Created by Kavitha on 04/11/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

//#import <MapKit/MapKit.h>
#import "IMSupportUtility.h"

NSString* const kIMGoogleMapAppUrlScheme = @"comgooglemaps://";
NSString* const kIMGoogleMapUrl = @"https://maps.google.com/maps";
NSString* const kIMDirectionsModeParameter = @"directionsmode=driving";
NSString* const kIMPhoneUrlScheme = @"telprompt:";

/*
 Utility class to handle support related functionlities
 */
@implementation IMSupportUtility

+ (CLLocationCoordinate2D) locationCoordinateFor:(double) latitude
                                             longitude:(double) longitude
{
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+ (CLLocation*) locationFromLatitude:(NSString*) latitude
                                       longitude:(NSString*) longitude
{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
    return location;
}

+ (void) loadDirectionsMap:(CLLocation *)srcLocation destination:(CLLocation*)dstLocation
{
    // open google map.
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kIMGoogleMapAppUrlScheme]]) {
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapAppUrlScheme,srcLocation.coordinate.latitude,srcLocation.coordinate.longitude,dstLocation.coordinate.latitude,dstLocation.coordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    // open Google map in browser
   else{
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapUrl,srcLocation.coordinate.latitude,srcLocation.coordinate.longitude,dstLocation.coordinate.latitude,dstLocation.coordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    /*else{
        //Open apple map
        //http://stackoverflow.com/questions/12504294/programmatically-open-maps-app-in-ios-6
        CLLocationCoordinate2D srcCoordinate = [self locationCoordinateFor:srcLocation.coordinate.latitude longitude:srcLocation.coordinate.longitude];
        CLLocationCoordinate2D dstCoordinate = [self locationCoordinateFor:dstLocation.coordinate.latitude longitude:dstLocation.coordinate.longitude];
        
        //        MKMapItem *srcItem = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *srcPlaceMark = [[MKPlacemark alloc] initWithCoordinate:srcCoordinate addressDictionary:nil];
        MKMapItem *srcItem = [[MKMapItem alloc] initWithPlacemark:srcPlaceMark];
        srcItem.name = @"Kolkatta";
        
        MKPlacemark *dstPlaceMark = [[MKPlacemark alloc] initWithCoordinate:dstCoordinate addressDictionary:nil];
        MKMapItem *dstItem = [[MKMapItem alloc] initWithPlacemark:dstPlaceMark];
        dstItem.name = @"Test";
        
        NSArray *mapItems = @[srcItem, dstItem];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
        
        [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    }*/
}
/*
+ (void) loadDirectionsMap:(CLLocation)srcCoordinate destination:(CLLocationCoordinate2D)dstCoordinate destinationName:(NSString*)dstName
{
    // open google map.
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kIMGoogleMapUrlScheme]]) {
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapUrlScheme,srcCoordinate.latitude,srcCoordinate.longitude,dstCoordinate.latitude,dstCoordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    else{
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapUrl,srcCoordinate.latitude,srcCoordinate.longitude,dstCoordinate.latitude,dstCoordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    else{
     //Open apple map
     //http://stackoverflow.com/questions/12504294/programmatically-open-maps-app-in-ios-6
     
     MKMapItem *srcItem = [MKMapItem mapItemForCurrentLocation];
     
     MKPlacemark *dstPlaceMark = [[MKPlacemark alloc] initWithCoordinate:dstCoordinate addressDictionary:nil];
     MKMapItem *dstItem = [[MKMapItem alloc] initWithPlacemark:dstPlaceMark];
     dstItem.name = dstName;
     
     NSArray *mapItems = @[srcItem, dstItem];
     NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
     
     [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
     }
}*/

//TODO: For testing
+ (void) loadDirectionsMap

{
    CLLocationCoordinate2D srcCoordinate = [self locationCoordinateFor:13.3346700 longitude:74.7461700];
    CLLocationCoordinate2D dstCoordinate = [self locationCoordinateFor:13.378747 longitude:74.7429729];
    // open google map.
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kIMGoogleMapAppUrlScheme]]) {
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapAppUrlScheme,srcCoordinate.latitude,srcCoordinate.longitude,dstCoordinate.latitude,dstCoordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    else{
        NSString *urlString = [NSString stringWithFormat:@"%@?saddr=%f,%f&daddr=%f,%f&%@",kIMGoogleMapUrl,srcCoordinate.latitude,srcCoordinate.longitude,dstCoordinate.latitude,dstCoordinate.longitude,kIMDirectionsModeParameter];
        NSURL *googleMapurl = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:googleMapurl];
    }
    /*else{
        //Open apple map
        //http://stackoverflow.com/questions/12504294/programmatically-open-maps-app-in-ios-6
        
        MKPlacemark *srcPlaceMark = [[MKPlacemark alloc] initWithCoordinate:srcCoordinate addressDictionary:nil];
//        MKMapItem *srcItem = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *srcItem = [[MKMapItem alloc] initWithPlacemark:srcPlaceMark];
        srcItem.name = srcName;

        MKPlacemark *dstPlaceMark = [[MKPlacemark alloc] initWithCoordinate:dstCoordinate addressDictionary:nil];
        MKMapItem *dstItem = [[MKMapItem alloc] initWithPlacemark:dstPlaceMark];
        dstItem.name = dstName;
        
        NSArray *mapItems = @[srcItem, dstItem];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
        
        [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    }*/
}

+(BOOL) callNumber:(NSString*) phoneNumber
{
    if (phoneNumber == nil || [phoneNumber isEqualToString:@""]) {
        return false;
    }
    
    BOOL canCall = true;
    NSString *trimmedPhoneNumber = [NSString stringWithString:phoneNumber];
    trimmedPhoneNumber = [trimmedPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    trimmedPhoneNumber = [trimmedPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    trimmedPhoneNumber = [trimmedPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    trimmedPhoneNumber = [trimmedPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSString *phoneUrlStr = [NSString stringWithFormat:@"%@%@",kIMPhoneUrlScheme,trimmedPhoneNumber];
    NSURL *phoneUrl = [NSURL URLWithString:phoneUrlStr];
    // open Phone app.
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneUrlStr]]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else{
        canCall = false;
    }
    
    return canCall;
    
}


@end
