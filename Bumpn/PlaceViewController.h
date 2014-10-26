//
//  VenueViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "RecentReports.h"

@interface PlaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) Place *place;
@property (strong, nonatomic) RecentReports *recentReports;
@end
