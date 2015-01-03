//
//  SearchLogger.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/15/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"

@interface Logger : NSObject
@property (strong, nonatomic) Place *place;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startSearchLoggerUpload;
- (void)startCallLoggerUpload;
@end
