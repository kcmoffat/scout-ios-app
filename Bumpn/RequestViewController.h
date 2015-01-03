//
//  RequestViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface RequestViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) Place *place;
@end
