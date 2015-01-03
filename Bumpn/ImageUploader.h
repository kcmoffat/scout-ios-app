//
//  ImageUploader.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUploader : NSObject <NSURLSessionTaskDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageName;
@property (nonatomic, copy) void (^progressHandler)(float);
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startUpload;
- (NSString *)imageURL;

@end
