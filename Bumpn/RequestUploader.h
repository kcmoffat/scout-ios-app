//
//  RequestUploader.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/18/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"

@interface RequestUploader : NSObject
@property (strong, nonatomic) Place *place;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (strong, nonatomic) NSMutableArray *questions;
@property (copy, nonatomic) NSString *moreQuestions;

- (void)startUpload;
@end
