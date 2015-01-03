//
//  SearchLogger.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/15/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logger.h"
#import "Constants.h"

@implementation Logger

-(void)startSearchLoggerUpload
{
    NSString *urlString = [NSString stringWithFormat:@"%@?key=%@", appEngineSearchURLPrefix, appEngineAPIKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              [self.place googlePlacesId], @"google_places_id",
                              [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                              nil];
    [d setObject:[self.place name] forKey:@"name"];
    [d setObject:[self.place vicinity] forKey:@"vicinity"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                               if (self.completionHandler) {
                                                   self.completionHandler();                                                   
                                               }
                                               self.place = nil;
                                           }];
    [sessionTask resume];
}

-(void)startCallLoggerUpload
{
    NSString *urlString = [NSString stringWithFormat:@"%@?key=%@", appEngineCallURLPrefix, appEngineAPIKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              [self.place googlePlacesId], @"google_places_id",
                              [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                              nil];
    [d setObject:[self.place name] forKey:@"name"];
    [d setObject:[self.place vicinity] forKey:@"vicinity"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                               NSLog(@"finished logging call");
                                               if (self.completionHandler) {
                                                   self.completionHandler();
                                               }
                                               self.place = nil;
                                           }];
    [sessionTask resume];
}
@end
