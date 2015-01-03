//
//  Utils.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/14/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)elapsedTime:(NSDate *)date
{
    NSTimeInterval secondsBetweenDates = -[date timeIntervalSinceNow];
    if (secondsBetweenDates < 60) {
        return @"<1 min ago";
    } else if (secondsBetweenDates < 3600) {
        int minutesAgo = secondsBetweenDates / 60;
        if (minutesAgo < 2) return @"1 min ago";
        return [NSString stringWithFormat:@"%d mins ago", minutesAgo];
    } else if (secondsBetweenDates < 86400) {
        int hoursAgo = secondsBetweenDates / 3600;
        if (hoursAgo < 2) return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", hoursAgo];
    } else if (secondsBetweenDates < 31536000) {
        int daysAgo = secondsBetweenDates / 86400;
        if (daysAgo < 2) return @"1 day ago";
        return [NSString stringWithFormat:@"%d days ago", daysAgo];
    } else {
        int yearsAgo = secondsBetweenDates / 31536000;
        if (yearsAgo < 2) return @"1 year ago";
        return [NSString stringWithFormat:@"%d years ago", yearsAgo];
    }
}

@end
