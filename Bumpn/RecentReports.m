//
//  RecentReports.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "RecentReports.h"
#import "Report.h"

@implementation RecentReports
@synthesize reports;

- (id)init
{
    self = [super init];
    if (self) {
        reports = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    NSDictionary *recentReports = [d objectForKey:@"reports"];
    for (NSDictionary *recentReport in recentReports) {
        Report *r = [[Report alloc] init];
        [r readFromJSONDictionary:recentReport];
        [self.reports addObject:r];
    }
}

@end
