//
//  CameraViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 11/7/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "CameraViewController.h"
#import "PhotoPreviewViewController.h"
#import "ReportViewController.h"

@interface CameraViewController ()
@property (assign, nonatomic) BOOL shouldPresentCamera;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shouldPresentCamera = YES;
}

+ (UIImagePickerController *)sharedImagePickerController
{
    static UIImagePickerController *imagePickerController = nil;
    if (imagePickerController == nil) {
        imagePickerController = [[UIImagePickerController alloc] init];
    }
    return imagePickerController;
}
- (IBAction)takePhoto:(UIButton *)sender
{
    [self setButtonsEnabledStatus:NO];
    [[CameraViewController sharedImagePickerController] takePicture];
    self.view.backgroundColor = [UIColor blackColor];
}

- (IBAction)cancelPhoto:(id)sender
{
    [self setButtonsEnabledStatus:NO];
    [self dismissViewControllerAnimated:NO completion:^{
        self.view.backgroundColor = [UIColor blackColor];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (IBAction)skipToComments:(UIBarButtonItem *)sender
{
    [self setButtonsEnabledStatus:NO];
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"SkipToComments" sender:self];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Took Picture");
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"PreviewPhoto" sender:self];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldPresentCamera) {
        [self setButtonsEnabledStatus:YES];
        UIImagePickerController *imagePickerController = [CameraViewController sharedImagePickerController];
        imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSString *desired = (NSString *)kUTTypeImage;
            if ([[UIImagePickerController availableMediaTypesForSourceType:imagePickerController.sourceType] containsObject:desired]) {
                NSLog(@"desired media type is available");
                imagePickerController.mediaTypes = @[desired];
                imagePickerController.showsCameraControls = NO;
                self.view.frame = imagePickerController.cameraOverlayView.frame;
                imagePickerController.cameraOverlayView = self.view;
                [self presentViewController:imagePickerController animated:NO completion:nil];
                self.view.backgroundColor = [UIColor clearColor];
                self.shouldPresentCamera = NO;
                NSLog(@"CameraViewController appeared. googlePlacesId: %@", self.place.googlePlacesId);
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera Required" message:@"A camera with camera access is required to use this feature" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)setButtonsEnabledStatus:(BOOL)enabled
{
    self.skipButton.enabled = enabled;
    self.cancelButton.enabled = enabled;
    self.cameraButton.enabled = enabled;
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
    if ([segue.identifier isEqualToString:@"PreviewPhoto"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoPreviewViewController class]]) {
            NSLog(@"Preparing for photo preview segue");
            PhotoPreviewViewController *ppvc = (PhotoPreviewViewController *)segue.destinationViewController;
            ppvc.image = self.image;
            ppvc.place = self.place;
            NSLog(@"ppvc.place: %@", ppvc.place);
            self.image = nil;
            self.shouldPresentCamera = YES;
        }
    } else if ([segue.identifier isEqualToString:@"SkipToComments"]) {
        if ([segue.destinationViewController isKindOfClass:[ReportViewController class]]) {
            NSLog(@"Preparing for skip to comments segue");
            ReportViewController *fcvc = (ReportViewController *)segue.destinationViewController;
            fcvc.place = self.place;
            self.shouldPresentCamera = YES;
            self.image = nil;
            self.view.backgroundColor = [UIColor blackColor];
        }
    }
}

@end
