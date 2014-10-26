//
//  JSONSerializable.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable <NSObject>

- (void)readFromJSONDictionary:(NSDictionary *)d;
@end
