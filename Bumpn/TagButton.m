//
//  TagButton.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/11/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "TagButton.h"

@implementation TagButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
    if (self.selected) {
        [[[UIColor alloc] initWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1] setFill];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    } else {
        [[[UIColor alloc] initWithRed:17/255.0 green:159/255.0 blue:246/255.0 alpha:1] setFill];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [roundedRect fill];
}
@end
