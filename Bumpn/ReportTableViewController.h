//
//  FormTableViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/12/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewController : UITableViewController <UITextViewDelegate>

-(NSString *)comments;
-(NSMutableArray *)tags;
-(BOOL)didSelectOneTag;
-(BOOL)didJustifyReport;
@end
