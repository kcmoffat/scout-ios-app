//
//  CameraViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/7/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) Place *place;
+ (UIImagePickerController *)sharedImagePickerController;
@end
