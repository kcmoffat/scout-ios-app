//
//  RecentReports.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentReports : NSObject
@property (nonatomic, readonly, strong) NSMutableArray *reports;
- (void)readFromJSONDictionary:(NSDictionary *)d;
@end
