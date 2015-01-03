//
//  FormViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/12/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Place.h"

@interface ReportViewController : UIViewController
@property (strong, nonatomic) Place *place;
@property (strong, nonatomic) UIImage *image;
@end
