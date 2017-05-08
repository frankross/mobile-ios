//
//  IMLocationManager.m
//  InstaMed
//
//  Created by Arjuna on 20/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "IMServerManager.h"

static NSString* const IMCurrentLocationKey = @"currentLocation";

@interface IMLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) LocationHandler handler;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,copy) void(^completionBlock)(NSArray* deliveryLocations,IMCity* currentCity, NSError* error);

@end

@implementation IMLocationManager


+(IMLocationManager*)sharedManager
{
    static IMLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)setCurrentLocation:(IMCity*)city
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:city] forKey:IMCurrentLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IMCity*)currentLocation
{
    NSData* storedData = [[NSUserDefaults standardUserDefaults] objectForKey:IMCurrentLocationKey];
    
    if(storedData)
        return [NSKeyedUnarchiver unarchiveObjectWithData:storedData] ;
    
    return nil;
}

- (CLLocationManager*)locationManager
{
    if(_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
        }
        else{
            [_locationManager startUpdatingLocation];
        }
    }
    return _locationManager;
}

-(void)fetchDeliverySupportedLocationsAndCurrentLocationWithCompletion:(void(^)(NSArray* deliveryLocations,IMCity* currentCity, NSError* error))completion
{
    // Not using
    //    self.locationManager = [[CLLocationManager alloc] init];
    //    self.locationManager.delegate = self;
    //    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    //    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    //    {
    //        [self.locationManager requestWhenInUseAuthorization];
    //    }
    //    self.completionBlock = completion;
    //    [self.locationManager startUpdatingLocation];
}


-(void)fetchDeliverySupportedLocationsWithCompletion:(void(^)(NSArray* deliveryLocations,IMCity* currentCity,NSError* error))completion
{
    [self fetchDeliverySupportedLocationsWithCurrentLocation:nil withCompletion:^(NSArray *deliveryLocations, IMCity *currentCity, NSError *error)
     {
         
         if (!error)
         {
             NSNumber* currentLocationId = [self currentLocation].identifier;
             __block IMCity* currentLocation = nil;
             
             [deliveryLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 
                 if([((IMCity*)obj).identifier isEqual:currentLocationId])
                 {
                     currentLocation = (IMCity*)obj;
                     *stop = YES;
                     
                 }
                 
             }];
             
             if(!currentLocation)
             {
                 currentLocation = currentCity;
             }
             
             completion(deliveryLocations,currentLocation,error);
         }
         else
         {
             completion(nil,nil,error);
             
         }
         
         
     }];
}

-(void)fetchDeliverySupportedLocationsWithCurrentLocation:(CLLocation*)currentLocation withCompletion:(void(^)(NSArray* deliveryLocations,IMCity* currentCity, NSError* error))completion
{
    
    //IMServerManager
    
    NSDictionary* coordinateDictionary = nil;
    if(currentLocation)
    {
        coordinateDictionary = @{@"lat":@(currentLocation.coordinate.latitude),@"long":@(currentLocation.coordinate.longitude)};
    }
    
    [[IMServerManager sharedManager] fetchDeliverySupportedLocationsWithParameters:coordinateDictionary withCompletion:^(NSDictionary *locationDictionary, NSError *error) {
        NSMutableArray* cities = [NSMutableArray array];
        
        for(NSDictionary* cityDictionary in locationDictionary[@"cities"])
        {
            IMCity* city  = [[IMCity alloc] initWithDictionary:cityDictionary];
            [cities addObject:city];
        }
        
        IMCity* currentCity = nil;
        if(cities.count) // Selecting 1st city by default
        {
            currentCity = cities[0];
        }
        completion(cities, currentCity,error);
    }];
    
}

- (void)fetchGeoLocationWithHandler:(LocationHandler)handler
{
    _handler = handler;
    
    if([CLLocationManager locationServicesEnabled])
    {
        if(([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)&&
           ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted))
        {
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
        else
        {
            NSError *error = [[NSError alloc]initWithDomain:@"com.frankross.InstaMed.ErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: IMGPSError}];
            handler(nil, error);
        }
    }
    else {
        NSError *error = [[NSError alloc]initWithDomain:@"com.frankross.InstaMed.ErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: IMGPSError}];
        handler(nil, error);
    }
}

#pragma mark - Location Manager Delegate Methods -
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *location = [manager location];
    
    if (_handler != nil) {
        _handler(location, nil);
    }
    //TODO: for testing use Kolkatta location coords. remove in the final production code
//    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:22.572645 longitude:88.363892];
//    if (_handler != nil) {
//        _handler(testLocation, nil);
//    }
    //    if([locations lastObject])
    //    {
    //        [self.locationManager stopUpdatingLocation];
    //        self.locationManager.delegate = nil;
    //        self.locationManager = nil;
    //        [self fetchDeliverySupportedLocationsWithCurrentLocation:[locations lastObject] withCompletion:^(NSArray *deliveryLocations, IMCity *currentCity, NSError *error) {
    //            self.completionBlock(deliveryLocations,currentCity,error);
    //        }];
    //    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    self.locationManager = nil;
    
    if (_handler != nil) {
        NSError *newerror = [[NSError alloc]initWithDomain:@"com.frankross.InstaMed.ErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: IMGPSError}];
        _handler(nil, newerror);
    }
    
    
    //    [self fetchDeliverySupportedLocationsWithCurrentLocation:nil withCompletion:^(NSArray *deliveryLocations, IMCity *currentCity, NSError *error) {
    //        self.completionBlock(deliveryLocations,currentCity,error);
    //    }];
}

-(void)fetchCityDetailsWithCompletion:(void(^)(IMCity* currentCity,NSError* error))completion
{
    [[IMServerManager sharedManager] getCurrentCityDetailsWithCompletion:^(NSMutableDictionary *cityDictioary, NSError *error) {
        
        if(!error)
        {
            IMCity *city = [[IMCity alloc] initWithDictionary:cityDictioary];
            completion(city,nil);
        }
        else
        {
            completion(nil,error);
        }
    }];
}



@end
