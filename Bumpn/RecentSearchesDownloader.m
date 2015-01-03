//
//  RecentSearchesDownloader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/15/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentSearchesDownloader.h"
#import "Constants.h"

@interface RecentSearchesDownloader()
@property (strong, nonatomic) SearchResults *results;
@end

@implementation RecentSearchesDownloader

- (void)startDownload
{
    NSString *urlString = [NSString stringWithFormat:@"%@?key=%@&ios_device_id=%@", appEngineSearchURLPrefix, appEngineAPIKey, [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         if (!error) {
                                             NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                             NSLog(@"Recent searches: %@", d.description);
                                             self.results = [[SearchResults alloc] init];
                                             [self.results readRecentSearchResultsFromJSONDictionary:d];
                                             self.completionHandler();
                                         } else {
                                             NSLog(@"error: %@", error.description);
                                         }
                                     }];
    [sessionTask resume];
}

- (SearchResults *)searchResults
{
    return self.results;
}
@end
