//
//  RequestViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/21/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestTableViewController.h"
#import "RequestUploader.h"

@interface RequestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) RequestTableViewController *requestTableViewController;
@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"registering push notification");
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapCancelButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapSubmitButton:(UIButton *)sender
{
    NSLog(@"tapped submit button");
    [self.submitButton setEnabled:NO];
    BOOL hasSelectedQuestion = [self.requestTableViewController hasSelectedQuestion];
    BOOL hasEnteredQuestion = [self.requestTableViewController hasEnteredQuestion];
    if (hasSelectedQuestion || hasEnteredQuestion) {
        RequestUploader *requestUploader = [[RequestUploader alloc] init];
        requestUploader.place = self.place;
        if (hasSelectedQuestion) {
            requestUploader.questions = [self.requestTableViewController selectedQuestions];
        }
        if (hasEnteredQuestion) {
            requestUploader.moreQuestions = [self.requestTableViewController enteredQuestions];
        }
        requestUploader.completionHandler = ^{
            NSLog(@"finished request upload");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Request Sent!" message:@"Thanks for sending your request.  We'll try to get you an update soon, usually in less than 30 minutes.  Check the place page again soon for your update." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });
        };
        NSLog(@"starting request upload");
        [requestUploader startUpload];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Question required!" message:@"Please either select or enter a question." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
            [self.submitButton setEnabled:YES];
        });
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EmbedRequestForm"]) {
        if ([segue.destinationViewController isKindOfClass:[RequestTableViewController class]]) {
            self.requestTableViewController = (RequestTableViewController *)segue.destinationViewController;
        }
    }
}


@end
