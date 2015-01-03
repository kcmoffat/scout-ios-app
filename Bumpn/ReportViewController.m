//
//  FormViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/12/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewController.h"
#import "ReportUploader.h"
#import "ImageUploader.h"


@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) ReportTableViewController *formViewController;
@end

@implementation ReportViewController

- (IBAction)pressBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressSubmitButton:(UIButton *)sender
{
    [self.submitButton setEnabled:NO];
    if ([self.formViewController didSelectOneTag] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tag Required!" message:@"Please select at least one tag to describe the crowd." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
            [self.submitButton setEnabled:YES];
        });
    } else if ([self.formViewController didJustifyReport] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Justification Required!" message:@"Please tell us how you know this information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
            [self.submitButton setEnabled:YES];
        });
    } else {
        NSMutableArray *tags = [self.formViewController tags];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
        [self.progressView setHidden:NO];
        ReportUploader *reportUploader = [[ReportUploader alloc] init];
        reportUploader.googlePlacesId = self.place.googlePlacesId;
        reportUploader.tags = tags;
        if ([self.formViewController comments]) {
            NSLog(@"setting comments: %@", [self.formViewController comments]);
            reportUploader.comments = [self.formViewController comments];
        }
        if (self.image) {
            reportUploader.image = self.image;
            NSString *imageName = [NSString stringWithFormat:@"%@/%@", self.place.googlePlacesId, [[[[[NSDate date]description] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@"+" withString:@"_" ] stringByReplacingOccurrencesOfString:@"+" withString:@""]];
            NSLog(@"setting imageName: %@", imageName);
            reportUploader.imageName = imageName;
        }
        reportUploader.completionHandler = ^void(void){
            NSLog(@"report successfully uploaded");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"successfully uploaded report");
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        };
        reportUploader.progressHandler = ^void(float progress){
            NSLog(@"we made %f progress", progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self progressView] setProgress:progress];
            });
        };
        NSLog(@"starting report upload");
        [reportUploader startUpload];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"FormContainerViewController loaded with place: %@", self.place);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EmbedForm"]) {
        if ([segue.destinationViewController isKindOfClass:[ReportTableViewController class]]) {
            self.formViewController = (ReportTableViewController *)segue.destinationViewController;
        }
    }
}


@end
