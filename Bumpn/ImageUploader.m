//
//  ImageUploader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "ImageUploader.h"
#import "Constants.h"

@interface ImageUploader()
@end

@implementation ImageUploader

- (void)startUpload
{
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.25);
    NSString *imageLength = [NSString stringWithFormat:@"%lu",(unsigned long)[imageData length]];
    NSLog(@"imageLength: %@", imageLength);
    NSString *urlString = [[NSString stringWithFormat:@"%@?name=%@&length=%@&key=%@", appEngineImageURLPrefix, self.imageName, imageLength, appEngineAPIKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         if (!error) {
                                             NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                             NSLog(@"image upload response: %@", d.description);
                                             NSString *uploadURLString = [d objectForKey:@"location"];
                                             NSURL *imageUploadURL = [[NSURL alloc] initWithString:uploadURLString];
                                             [self uploadImageToGoogleCloudStorage:imageUploadURL withImageData:imageData];
                                         } else {
                                             // raise error alert
                                             NSLog(@"error: %@", [error description]);
                                         }
                                     }];
    [sessionTask resume];
}

- (void)uploadImageToGoogleCloudStorage:(NSURL *)url withImageData:(NSData *)imageData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:imageData];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                               if (!error) {
                                                   NSLog(@"successful upload");
                                                   self.completionHandler();
                                               } else {
                                                   // raise error alert
                                                   NSLog(@"error: %@", [error description]);
                                               }
                                           }];
    [sessionTask resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    self.progressHandler((float)totalBytesSent/(float)totalBytesExpectedToSend);
}

- (NSString *)imageURL
{
    return [[NSString stringWithFormat:@"%@%@", cloudStorageImageURLPrefix, self.imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
