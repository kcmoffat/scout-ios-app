//
//  FormTableViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/12/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "ReportTableViewController.h"
#import "TagButton.h"

@interface ReportTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end

@implementation ReportTableViewController
- (IBAction)tapTagButton:(UIButton *)sender
{
    NSInteger buttonsPerRow = 3;
    UIButton * button = sender;
    NSInteger offset = (button.tag-1) / buttonsPerRow;
    NSInteger index1 = (button.tag + 0) % buttonsPerRow + offset*buttonsPerRow + 1;
    NSInteger index2 = (button.tag + 1) % buttonsPerRow + offset*buttonsPerRow + 1;
    UIButton *relatedButton1 = (UIButton *)[self.tableView viewWithTag:index1];
    UIButton *relatedButton2 = (UIButton *)[self.tableView viewWithTag:index2];
    [button setSelected:!button.selected];
    if ([relatedButton1 isKindOfClass:[UIButton class]] && relatedButton1.selected) [relatedButton1 setSelected:NO];
    if ([relatedButton2 isKindOfClass:[UIButton class]] && relatedButton2.selected) [relatedButton2 setSelected:NO];
    [button setNeedsDisplay];
}

- (NSString *)comments
{
    return self.commentTextView.text;
}

- (NSMutableArray *)tags
{
    NSInteger totalTags = 18;
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < totalTags+1; i++) {
        UIView *view = [self.tableView viewWithTag:i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.selected) {
                [tags addObject:button.titleLabel.text];
            }
        }
    }
    NSLog(@"Tags: %@", tags.description);
    return tags;
}

-(BOOL)didSelectOneTag
{
    return [[self crowdTags] count] > 0;
}

-(BOOL)didJustifyReport
{
    return [[self justificationTags] count] > 0;
}

-(NSMutableArray *)crowdTags
{
    NSInteger totalTags = 15;
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < totalTags+1; i++) {
        UIView *view = [self.tableView viewWithTag:i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.selected) {
                [tags addObject:button.titleLabel.text];
            }
        }
    }
    return tags;
}

-(NSMutableArray *)justificationTags
{
    NSInteger totalTags = 3;
    NSInteger tagStart = 16;
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSInteger i = tagStart; i < tagStart+totalTags+1; i++) {
        UIView *view = [self.tableView viewWithTag:i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.selected) {
                [tags addObject:button.titleLabel.text];
            }
        }
    }
    return tags;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([self.commentTextView.text isEqualToString:@""]) {
            self.placeholderLabel.hidden = NO;
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *borderColor = [[UIColor alloc] initWithWhite:0.8f alpha:1];
    float borderWidth = 0.3f;
    self.commentTextView.layer.borderColor = [borderColor CGColor];
    self.commentTextView.layer.borderWidth = borderWidth;
    [self.commentTextView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
