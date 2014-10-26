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

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setCrowdLevelName:[d objectForKey:@"crowd_level"]];
    [self setComments:[d objectForKey:@"comments"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    NSDate *date = [dateFormatter dateFromString:[d objectForKey:@"created_at"]];
    [self setCreatedAt:date];
}

@end
