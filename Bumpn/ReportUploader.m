//
//  ReportUploader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "ReportUploader.h"
#import "ImageUploader.h"
#import "Constants.h"

@interface ReportUploader()
@property (copy, nonatomic) NSString *imageURL;
@end

@implementation ReportUploader

- (void)startUpload
{
    if (self.image) {
        ImageUploader *imageUploader = [[ImageUploader alloc] init];
        imageUploader.image = self.image;
        imageUploader.imageName = self.imageName;
        __weak ImageUploader *weakImageUploader = imageUploader;
        imageUploader.completionHandler = ^void(void){
            self.imageURL = [weakImageUploader imageURL];
            [self uploadReport];
        };
        imageUploader.progressHandler = ^void(float progress){
            self.progressHandler(progress);
        };
        [imageUploader startUpload];
    } else {
        [self uploadReport];
    }
}

- (void)uploadReport
{
    NSLog(@"uploading report now");
    NSString *reportUploadURL = [[NSString stringWithFormat:@"%@?key=%@", appEngineReportURLPrefix, appEngineAPIKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:reportUploadURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              self.tags, @"tags",
                              self.googlePlacesId, @"google_places_id",
                              [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                              nil];
    if ([self.imageURL length] > 0) {
        [d setValue:self.imageURL forKey:@"photo_url"];
    }
    if ([self.comments length] > 0) {
        [d setValue:self.comments forKey:@"comments"];
    }
    NSLog(@"report: %@", d.description);
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                               NSLog(@"response: %@", response.description);
                                               if (!error) {
                                                   self.completionHandler();
                                               } else {
                                                   //raise error
                                               }
                                           }];
    [sessionTask resume];
}

@end
