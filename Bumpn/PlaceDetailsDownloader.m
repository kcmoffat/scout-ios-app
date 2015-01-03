//
//  PlaceDetailsDownloader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/18/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "PlaceDetailsDownloader.h"
#import "Constants.h"

@implementation PlaceDetailsDownloader


- (void)startDownload
{
    NSString *urlString = [NSString stringWithFormat:@"%@?placeid=%@&key=%@", googlePlaceDetailsAPIURLPrefix, self.place.googlePlacesId, googlePlacesAPIKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         if (!error) {
                                             NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                             [self.place readPlaceDetailsFromJSONDictionary:d];
                                             if (self.completionHandler) {
                                                 self.completionHandler();
                                             }
                                         } else {
                                             NSLog(@"error: %@", error.description);
                                         }
                                     }];
    [sessionTask resume];
}
@end
