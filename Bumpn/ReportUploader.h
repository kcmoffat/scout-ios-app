//
//  ReportUploader.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReportUploader : NSObject

@property (copy, nonatomic) NSString *googlePlacesId;
@property (strong, nonatomic) NSMutableArray *tags;
@property (copy, nonatomic) NSString *comments;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *imageName;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, copy) void (^progressHandler)(float);

- (void)startUpload;

@end

