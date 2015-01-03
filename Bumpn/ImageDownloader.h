//
//  ImageDownloader.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/13/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Report.h"

@interface ImageDownloader : NSObject

@property (strong, nonatomic) Report *report;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;
+ (void)clearImageCache;
@end
