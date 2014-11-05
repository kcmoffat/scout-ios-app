//
//  Report.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "Report.h"

@implementation Report
@synthesize crowdLevelName;
@synthesize comments;
@synthesize createdAt;
@synthesize deviceId;
@synthesize imageURL;
@synthesize image;


- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setCrowdLevelName:[d objectForKey:@"crowd_level"]];
    [self setComments:[d objectForKey:@"comments"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"created_at"]];
    [self setCreatedAt:date];
    [self setImageURL:[d objectForKey:@"photo_url"]];
}

- (void)downloadImageWithCompletionBlock:(void (^)(void))completionBlock
{
    if (![self.imageURL isEqual:[NSNull null]]) {
        NSLog(@"invoking image download selector");
        NSLog(@"urlString: %@", self.imageURL);
        NSURL *url = [NSURL URLWithString:self.imageURL];
        NSLog(@"created url");
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             if (!error) {
                                                 NSLog(@"finished fetching image");
                                                 self.image = [UIImage imageWithData:data];
                                             } else {
                                                 NSLog(@"error: %@", error.description);
                                             }
                                         }];
        [sessionTask resume];
        completionBlock();
    }
}

@end
