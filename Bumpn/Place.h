//
//  Place.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, copy) NSString *googlePlacesId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *vicinity;
@property (nonatomic, copy) NSString *phone;

- (void)readNearbyPlacesFromJSONDictionary:(NSDictionary *)d;
- (void)readAutocompletePlacesFromJSONDictionary:(NSDictionary *)d;
- (void)readRecentSearchesFromJSONDictionary:(NSDictionary *)d;
- (void)readPlaceDetailsFromJSONDictionary:(NSDictionary *)d;
@end
