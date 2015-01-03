//
//  RecentSearchesDownloader.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/15/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResults.h"

@interface RecentSearchesDownloader : NSObject
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (SearchResults *)searchResults;
@end
