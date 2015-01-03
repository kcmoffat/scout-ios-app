//
//  ImageDownloader.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/13/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "ImageDownloader.h"

#define kAppIconSize 500

@interface ImageDownloader()
@property (weak, nonatomic) NSURLSessionTask *sessionTask;
@end

@implementation ImageDownloader
- (void)startDownload
{
//    UIImage *cachedImage = (UIImage *)[[ImageDownloader sharedImageCache] objectForKey:self.report.imageURL];
//    if (cachedImage) {
//        NSLog(@"found image in cache: %@", cachedImage);
//        self.completionHandler();
//    } else {
        NSLog(@"downloading image from url: %@", self.report.imageURL);
        NSURL *url = [NSURL URLWithString:self.report.imageURL];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             if (!error) {
                                                 UIImage *image = [UIImage imageWithData:data];
//                                                 if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
//                                                 {
//                                                     CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
//                                                     UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0.0f);
//                                                     CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//                                                     [image drawInRect:imageRect];
//                                                     self.report.image = UIGraphicsGetImageFromCurrentImageContext();
//                                                     UIGraphicsEndImageContext();
//                                                 } else {
//                                                     self.report.image = image;
//                                                 }
                                                 self.report.image = image;
//                                                 NSLog(@"adding image with url %@ to image cache", self.report.imageURL);
//                                                 NSLog(@"image: %@", self.report.image);
//                                                 [[ImageDownloader sharedImageCache]  setObject:self.report.image forKey:self.report.imageURL];
//                                                 NSLog(@"added UIImage to cache.  New cache state: %@", [ImageDownloader sharedImageCache]);
                                                 self.sessionTask = nil;
                                                 self.completionHandler();
                                             } else {
                                                 NSLog(@"error: %@", error.description);
                                             }
                                         }];
        self.sessionTask = sessionTask;
        [sessionTask resume];
//    }
}

- (void)cancelDownload
{
    [self.sessionTask cancel];
}

+ (NSMutableDictionary *)sharedImageCache
{
    static NSMutableDictionary *imageCache = nil;
    if (imageCache == nil) {
        imageCache = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"cache state: %@", imageCache.description);
    return imageCache;
}

+ (void)clearImageCache
{
    [[ImageDownloader sharedImageCache] removeAllObjects];
}

@end
