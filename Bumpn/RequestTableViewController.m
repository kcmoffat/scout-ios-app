//
//  RequestTableViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "RequestTableViewController.h"

@interface RequestTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation RequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.questionTextView setDelegate:self];
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.text = @"e.g. Is there a cover today?\nWhat's the wait for a party of 2?";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
    [header.textLabel setTextAlignment:NSTextAlignmentCenter];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
    self.questionTextView.text=@"";
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([self.questionTextView.text isEqualToString:@""]) {
            self.placeholderLabel.hidden = NO;
        }
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)tapQuestionButton:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
}

-(BOOL)hasSelectedQuestion
{
    if ([self.selectedQuestions count] > 0) {
        return YES;
    }
    return NO;
}
-(BOOL)hasEnteredQuestion {
    if ([self.questionTextView.text length] > 0) {
        return YES;
    }
    return NO;
}
-(NSMutableArray *)selectedQuestions
{
    NSInteger totalTags = 5;
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < totalTags+1; i++) {
        UIView *view = [self.tableView viewWithTag:i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.selected) {
                [questions addObject:button.titleLabel.text];
            }
        }
    }
    NSLog(@"Questions: %@", questions.description);
    return questions;
}

-(NSString *)enteredQuestions
{
    return self.questionTextView.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
