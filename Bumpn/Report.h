//
//  Report.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Report : NSObject

@property (strong, nonatomic) NSString *crowdLevelName;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;

- (void)readFromJSONDictionary:(NSDictionary *)d;

@end
