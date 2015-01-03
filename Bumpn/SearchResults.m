//
//  Results.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/9/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "SearchResults.h"
#import "Place.h"

@implementation SearchResults
@synthesize results;

- (id)init
{
    self = [super init];
    if (self) {
        results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readAutocompleteResultsFromJSONDictionary:(NSDictionary *)d
{
    NSLog(@"reading prediction JSON");
    NSDictionary *searchResults = [d objectForKey:@"predictions"];
    for (NSDictionary *searchResult in searchResults) {
        Place *p = [[Place alloc] init];
        [p readAutocompletePlacesFromJSONDictionary:searchResult];
        [results addObject:p];
    }
}

- (void)readRecentSearchResultsFromJSONDictionary:(NSDictionary *)d
{
    NSLog(@"reading nearby JSON");
    NSDictionary *searchResults = [d objectForKey:@"searches"];
    for (NSDictionary *searchResult in searchResults) {
        Place *p = [[Place alloc] init];
        [p readRecentSearchesFromJSONDictionary:searchResult];
        [results addObject:p];
    }
}

- (void)readNearbySearchResultsFromJSONDictionary:(NSDictionary *)d
{
    NSLog(@"reading nearby JSON");
    NSDictionary *searchResults = [d objectForKey:@"results"];
    for (NSDictionary *searchResult in searchResults) {
        Place *p = [[Place alloc] init];
        [p readNearbyPlacesFromJSONDictionary:searchResult];
        [results addObject:p];
    }
}


@end
