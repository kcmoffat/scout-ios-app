//
//  Results.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/9/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SearchResults : NSObject <JSONSerializable>

@property (nonatomic, readonly, strong) NSMutableArray *results;

- (void)readFromJSONDictionary:(NSDictionary *)d;

@end
