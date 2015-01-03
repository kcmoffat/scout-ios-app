//
//  RequestUploader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/18/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUploader.h"
#import "Constants.h"

@implementation RequestUploader

-(void)startUpload
{
    NSString *urlString = [NSString stringWithFormat:@"%@?key=%@", appEngineRequestURLPrefix, appEngineAPIKey];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              [self.place googlePlacesId], @"google_places_id",
                              [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                              nil];
    [d setObject:[self.place name] forKey:@"name"];
    [d setObject:[self.place vicinity] forKey:@"vicinity"];
    if ([self.questions count] > 0) {
        [d setObject:self.questions forKey:@"questions"];
    }
    if ([self.moreQuestions length] > 0) {
        [d setObject:self.moreQuestions forKey:@"more_questions"];
    }
    NSLog(@"request: %@", d.description);
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

@end
