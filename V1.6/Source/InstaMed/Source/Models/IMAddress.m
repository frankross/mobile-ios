//
//  IMAddress.m
//  InstaMed
//
//  Created by Arjuna on 26/05/15.
//  Copyright (c) 2015, Emami FrankRoss Ltd
//  Written under contract by Robosoft Technologies Pvt. Ltd.
//

#import "IMAddress.h"

static NSString* const IMIDKey  = @"id";
static NSString* const IMCityIDKey  = @"full_name";


static NSString* const IMNameKey  = @"full_name";
static NSString* const IMAddressLine1Key = @"address_line_1";
static NSString* const IMAddressLine2Key = @"address_line_2";
static NSString* const IMStateKey = @"KN";
static NSString* const IMPincodeKey = @"pincode";
static NSString* const IMCountryKey = @"country";
static NSString* const IMPhoneNumebrKey = @"phone_number";
static NSString* const IMCityNameKey = @"city";
static NSString* const IMIsDefaultKey = @"default";
static NSString* const IMLandMarkKey = @"landmark";
static NSString* const IMTagKey = @"address_type";
static NSString* const IMAreaIDKey = @"area_id";


static NSString* const IMOrderCityNameKey = @"city_name";

static NSString* const IMActiveKey = @"active";


@implementation IMAddress

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        
        self.name = dictionary[IMNameKey];
        self.addressLine1 = dictionary[IMAddressLine1Key];
        self.addressLine2 = dictionary[IMAddressLine2Key];
        self.pinCode = dictionary[IMPincodeKey];
        if (dictionary[IMCityNameKey] != nil) {
            self.city = [[IMCity alloc] initWithDictionary:dictionary[IMCityNameKey]];
        }
        else if(dictionary[IMOrderCityNameKey] != nil){
            self.city = [[IMCity alloc] initWithDictionary:@{@"name": dictionary[IMOrderCityNameKey]}];
        }
        self.isDefault = [dictionary[IMIsDefaultKey] boolValue];
        self.phoneNumber = dictionary[IMPhoneNumebrKey];
        self.landmark = dictionary[IMLandMarkKey];
        self.tag = dictionary[IMTagKey];
        if (dictionary[@"area"] != nil) {
            self.areaID = dictionary[@"area"][IMIdentifierKey];
            self.isActive = [dictionary[@"area"][IMActiveKey] boolValue];
        }
        else if(dictionary[IMAreaIDKey] != nil){
            self.areaID = dictionary[IMAreaIDKey];
        }
        self.cityName = dictionary[IMOrderCityNameKey];
    }
    return self;
}

- (NSDictionary *)dictinaryRepresentation
{
    NSMutableDictionary *dict = [super dictinaryRepresentation];
    if (self.identifier) {
        dict[IMIdentifierKey] = self.identifier;
    }
    dict[IMNameKey] = self.name;
    dict[IMAddressLine1Key] = self.addressLine1;
    if (self.addressLine2)
    {
        dict[IMAddressLine2Key] = self.addressLine2;
    }
    if(self.landmark)
    {
        dict[IMLandMarkKey] = self.landmark;
    }
    if(self.phoneNumber)
    {
        dict[IMPhoneNumebrKey] = self.phoneNumber;
    }
    dict[IMAreaIDKey] = self.areaID;
    dict[IMPincodeKey] = self.pinCode;
    if(self.tag)
    {
        dict[IMTagKey] = self.tag;
    }
    return [[NSDictionary alloc] initWithObjectsAndKeys:dict,@"address", nil];
    
    //address: {
//full_name:      "suhail",
//address_line_1: "ho: no 123",
//address_line_2: "street abc",
//area_id:        "Area id corresponding to pincode",
//phone_number:   "9876543210",
//address_type:   "office",
//default:        false,
//optional_details: "other details",
//landmark:         "some hotel"
//}
    
}


-(NSDictionary*)dictionaryForDefaultAddress
{
    return @{@"address":@{IMIdentifierKey:self.identifier, IMIsDefaultKey:[NSNumber numberWithBool:YES]}};
}

@end
