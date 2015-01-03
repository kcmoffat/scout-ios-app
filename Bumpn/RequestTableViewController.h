//
//  RequestTableViewController.h
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewController : UITableViewController <UITextViewDelegate>
-(BOOL)hasSelectedQuestion;
-(BOOL)hasEnteredQuestion;
-(NSMutableArray *)selectedQuestions;
-(NSString *)enteredQuestions;
@end
