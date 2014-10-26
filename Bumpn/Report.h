//
//  Report.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface Report : NSObject <JSONSerializable>

@property (strong, nonatomic) NSString *crowdLevelName;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *deviceId;

- (void)readFromJSONDictionary:(NSDictionary *)d;

@end
