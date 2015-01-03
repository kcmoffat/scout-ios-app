//
//  PhotoPreviewViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PhotoPreviewViewController : UIViewController
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) Place *place;
@end
