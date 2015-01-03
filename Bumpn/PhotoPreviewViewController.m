//
//  PhotoPreviewViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "ReportViewController.h"

@interface PhotoPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoPreviewViewController
@synthesize imageView;

- (IBAction)pressNextButton:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"EnterComments" sender:self];
}

- (IBAction)pressBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = self.image;
    NSLog(@"Loaded image preview with place: %@", self.place);
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EnterComments"]) {
        if ([segue.destinationViewController isKindOfClass:[ReportViewController class]]) {
            NSLog(@"Preparing for segue to FormViewController");
            ReportViewController *sfvc = (ReportViewController *)segue.destinationViewController;
            sfvc.image = self.image;
            sfvc.place = self.place;
            self.image = nil;
        }
    }
}


@end
