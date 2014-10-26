//
//  Place.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSNumber *googlePlacesId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *vicinity;

- (void)readNearbyPlacesFromJSONDictionary:(NSDictionary *)d;
- (void)readAutocompletePlacesFromJSONDictionary:(NSDictionary *)d;
@end
