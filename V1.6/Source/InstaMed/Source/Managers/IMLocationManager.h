//
//  IMLocationManager.h
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "IMCity.h"

typedef void (^LocationHandler)(CLLocation *location, NSError *error);

//To manage location based things.
@interface IMLocationManager : NSObject

@property (nonatomic,strong)NSString* currentLocationId;

@property (nonatomic,strong) IMCity* currentLocation;

+(IMLocationManager*)sharedManager;

- (void)fetchGeoLocationWithHandler:(LocationHandler)handler;

-(void)fetchDeliverySupportedLocationsAndCurrentLocationWithCompletion:(void(^)(NSArray* deliveryLocations,IMCity* currentCity, NSError* error))completion;

-(void)fetchDeliverySupportedLocationsWithCompletion:(void(^)(NSArray* deliveryLocations,IMCity* currentCity,NSError* error))completion;

-(void)fetchCityDetailsWithCompletion:(void(^)(IMCity* currentCity,NSError* error))completion;
@end
