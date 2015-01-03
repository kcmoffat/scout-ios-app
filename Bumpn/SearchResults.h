//
//  Results.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/9/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResults : NSObject

@property (nonatomic, readonly, strong) NSMutableArray *results;

- (void)readAutocompleteResultsFromJSONDictionary:(NSDictionary *)d;
- (void)readRecentSearchResultsFromJSONDictionary:(NSDictionary *)d;
- (void)readNearbySearchResultsFromJSONDictionary:(NSDictionary *)d;

@end
