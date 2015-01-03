//
//  Place.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize googlePlacesId;
@synthesize name;
@synthesize vicinity;

- (void)readNearbyPlacesFromJSONDictionary:(NSDictionary *)d
{
    [self setGooglePlacesId:[d objectForKey:@"place_id"]];
    [self setName:[d objectForKey:@"name"]];
    [self setVicinity:[d objectForKey:@"vicinity"]];
}

- (void)readAutocompletePlacesFromJSONDictionary:(NSDictionary *)d
{
    [self setGooglePlacesId:[d objectForKey:@"place_id"]];
    NSMutableArray *terms = [[d objectForKey:@"terms"] mutableCopy];
    NSString *firstTerm = [[terms objectAtIndex:0] objectForKey:@"value"];
    [terms removeObjectAtIndex:0];
    NSString *address = [[terms valueForKey:@"value"] componentsJoinedByString:@", "];
    [self setName:firstTerm];
    [self setVicinity:address];
}

- (void)readRecentSearchesFromJSONDictionary:(NSDictionary *)d
{
    [self setGooglePlacesId:[d objectForKey:@"google_places_id"]];
    [self setName:[d objectForKey:@"name"]];
    [self setVicinity:[d objectForKey:@"vicinity"]];
    NSLog(@"google_places_id: %@", self.googlePlacesId);
    NSLog(@"name: %@", self.name);
    NSLog(@"vicinity: %@", self.vicinity);
}

- (void)readPlaceDetailsFromJSONDictionary:(NSDictionary *)d
{
    NSString *phone = [[d objectForKey:@"result"] objectForKey:@"international_phone_number"];
    NSLog(@"raw phone number: %@", phone);
    if (![phone isEqual:[NSNull null]]) {
        phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"cleaned phone number: %@", phone);
        [self setPhone:phone];
    }
}
@end
