//
//  VenueViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "PlaceViewController.h"
#import "Place.h"
#import "Report.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PlaceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *submitActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *crowdLevelButton;
@property (weak, nonatomic) IBOutlet UIImageView *crowdLevelImage;
@property (weak, nonatomic) IBOutlet UIView *reportContainerView;
@property (copy, nonatomic) NSString *selectedCrowdLevelName;
@property (copy, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *reportPhotoURL;
@property (weak, nonatomic) IBOutlet UIProgressView *imageUploadProgressView;
@end

@implementation PlaceViewController
@synthesize place;
@synthesize submitButton;
@synthesize submitActivityIndicator;
@synthesize checkMark;
@synthesize crowdLevelButton;
@synthesize crowdLevelImage;
@synthesize selectedCrowdLevelName;
@synthesize comments;
@synthesize recentReports;
@synthesize reportPhotoURL;
@synthesize imageUploadProgressView;

- (IBAction)addPhotoButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    NSString *desired = (NSString *)kUTTypeImage;
    if ([[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType] containsObject:desired]) {
        picker.mediaTypes = @[desired];
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *imageName = [[[NSString stringWithFormat:@"%@/%@", [place googlePlacesId], [[[NSDate date] description] stringByReplacingOccurrencesOfString:@"+" withString:@"_"]] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"imageName: %@", imageName);
    self.reportPhotoURL = [NSString stringWithFormat:@"http://storage.googleapis.com/bumpn-backend-images/%@", imageName];
    NSString *imageLength = [NSString stringWithFormat:@"%lu",(unsigned long)[imageData length]];
    NSString *urlString = [[NSString stringWithFormat:@"http://bumpn-backend.appspot.com/api/v1/images/?name=%@&length=%@&key=%@", imageName, imageLength, @"y3hrlX2A53I1ov5cZokp9Sw9qx00D5AA"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
                                               if (!error) {
                                                   NSLog(@"response: %@", [response description]);
                                                   NSLog(@"data: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
                                                   NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                   NSLog(@"dictionary: %@", [d description]);
                                                   NSString *uploadURLString = [d objectForKey:@"location"];
                                                   NSURL *url = [[NSURL alloc] initWithString:uploadURLString];
                                                   [self uploadImageToGoogleCloudStorage:url withImageData:imageData];
                                               } else {
                                                   // raise error alert
                                                   NSLog(@"error: %@", [error description]);
                                               }
                                           }];
    [sessionTask resume];
}

- (void)uploadImageToGoogleCloudStorage:(NSURL *)url withImageData:(NSData *)imageData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:imageData];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                               if (!error) {
                                                   NSLog(@"successful upload");
                                               } else {
                                                   // raise error alert
                                                   NSLog(@"error: %@", [error description]);
                                               }
                                           }];
    [sessionTask resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self imageUploadProgressView] setProgress:(float)totalBytesSent/(float)totalBytesExpectedToSend];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength < 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Report *report = [[self.recentReports reports] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"ReportCell"];
    }
    UIImageView *crowdLevelImageView = (UIImageView *)[cell viewWithTag:1];
    NSString *crowdLevelName = [report crowdLevelName];
    if ([crowdLevelName isEqualToString:@"empty"]) {
        crowdLevelImageView.image = [UIImage imageNamed:@"empty-circles"];
    } else if ([crowdLevelName isEqualToString:@"comfy"]) {
        crowdLevelImageView.image = [UIImage imageNamed:@"comfy-circles"];
    } else {
        crowdLevelImageView.image = [UIImage imageNamed:@"bumpn-circles"];
    }
    UILabel *commentLabel = (UILabel *)[cell viewWithTag:2];
    if ([report.comments isEqual:[NSNull null]]) {
        [commentLabel setText:@""];
    } else {
        [commentLabel setText:[report comments]];
    }
    UILabel *elapsedTimeLabel = (UILabel *)[cell viewWithTag:3];
    [elapsedTimeLabel setText:[self elapsedTime:[report createdAt]]];
    NSLog(@"called cellForRowAtIndexPath");
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:4];
    NSLog(@"report.image: %@", report.image.description);
    if (!report.image) {
        NSLog(@"downloading image");
        [report downloadImageWithCompletionBlock:^{
            photoImageView.image = report.image;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            });
        }];
    } else {
        NSLog(@"loading image from memory");
        photoImageView.image = report.image;
    }
    return cell;
}

- (NSString *)elapsedTime:(NSDate *)date
{
    NSTimeInterval secondsBetweenDates = -[date timeIntervalSinceNow];
    if (secondsBetweenDates < 60) {
        return @"<1 min ago";
    } else if (secondsBetweenDates < 3600) {
        int minutesAgo = secondsBetweenDates / 60;
        if (minutesAgo < 2) return @"1 min ago";
        return [NSString stringWithFormat:@"%d mins ago", minutesAgo];
    } else if (secondsBetweenDates < 86400) {
        int hoursAgo = secondsBetweenDates / 3600;
        if (hoursAgo < 2) return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", hoursAgo];
    } else if (secondsBetweenDates < 31536000) {
        int daysAgo = secondsBetweenDates / 86400;
        if (daysAgo < 2) return @"1 day ago";
        return [NSString stringWithFormat:@"%d days ago", daysAgo];
    } else {
        int yearsAgo = secondsBetweenDates / 31536000;
        if (yearsAgo < 2) return @"1 year ago";
        return [NSString stringWithFormat:@"%d years ago", yearsAgo];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.recentReports reports] count];
}

- (IBAction)crowdLevelButtonPress:(UIButton *)sender
{
    [self.crowdLevelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self updateCrowdLevelSelection];
}

- (void) updateCrowdLevelSelection
{
    if (!self.selectedCrowdLevelName) {
        self.selectedCrowdLevelName = @"bumpn";
    }
    if ([self.selectedCrowdLevelName isEqualToString:@"empty"]) {
        [self.crowdLevelButton setTitle:@"comfy" forState:UIControlStateNormal];
        [self.crowdLevelImage setImage:[UIImage imageNamed:@"comfy-circles"]];
        self.selectedCrowdLevelName = @"comfy";
    } else if ([self.selectedCrowdLevelName isEqualToString:@"comfy"]) {
        [self.crowdLevelButton setTitle:@"bumpn" forState:UIControlStateNormal];
        [self.crowdLevelImage setImage:[UIImage imageNamed:@"bumpn-circles"]];
        self.selectedCrowdLevelName = @"bumpn";
    } else {
        [self.crowdLevelButton setTitle:@"empty" forState:UIControlStateNormal];
        [self.crowdLevelImage setImage:[UIImage imageNamed:@"empty-circles"]];
        self.selectedCrowdLevelName = @"empty";
    }
}

- (IBAction)submitReportButton:(UIButton *)sender
{
    if (!selectedCrowdLevelName) {
        NSLog(@"crowd level not set");
        [self.crowdLevelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // raise alert
    } else {
        [self.submitButton setEnabled:NO];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
        [submitActivityIndicator startAnimating];
        if ([self.commentTextField isFirstResponder]) {
            self.comments = self.commentTextField.text;
            [self.commentTextField resignFirstResponder];
        }
        NSString *urlString = @"http://bumpn-backend.appspot.com/api/v1/reports/?key=y3hrlX2A53I1ov5cZokp9Sw9qx00D5AA";
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           self.selectedCrowdLevelName, @"crowd_level",
                            [self.place googlePlacesId], @"google_places_id",
                            [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                            nil];
        if ([self.comments length] > 0) {
            [d setObject:self.comments forKey:@"comments"];
        }
        if ([self.reportPhotoURL length] > 0) {
            [d setObject:self.reportPhotoURL forKey:@"photo_url"];
        }
        NSLog(@"photo url: %@", self.reportPhotoURL);
        NSLog(@"device id: %@", [[UIDevice currentDevice] identifierForVendor]);
        NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
        [request setHTTPBody:data];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.submitActivityIndicator stopAnimating];
                    [self.checkMark setHidden:NO];
                    [self.commentTextField setEnabled:NO];
                    [self.crowdLevelButton setEnabled:NO];
                    [self fetchRecentReports];
                });
            } else {
                [self.submitButton setEnabled:YES];
                [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
                [submitActivityIndicator stopAnimating];
                // raise error alert
            }
        }];
        [sessionTask resume];
    }
}
- (IBAction)editingEnded:(UITextField *)sender
{
    self.comments = sender.text;
    [sender resignFirstResponder];
    NSLog(@"text: %@", sender.text);
    NSLog(@"set comments to: %@", self.comments);
}

- (void)fetchRecentReports
{
    NSString *urlString = [NSString stringWithFormat:@"http://bumpn-backend.appspot.com/api/v1/reports/?key=y3hrlX2A53I1ov5cZokp9Sw9qx00D5AA&google_places_id=%@", self.place.googlePlacesId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
         {
             if (!error) {
                 NSLog(@"finished fetching recent reports");
                 NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 NSLog(@"recent report dict: %@", d.description);
                 RecentReports *reports = [[RecentReports alloc] init];
                 [reports readFromJSONDictionary:d];
                 self.recentReports = reports;
                 [self updateUI];
             } else {
                 NSLog(@"error: %@", error.description);
             }
         }];
    [sessionTask resume];
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:[place name]];
    self.reportContainerView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.reportContainerView.layer.borderWidth = 0.5f;
    self.reportContainerView.layer.cornerRadius = 10.0f;
    self.crowdLevelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.crowdLevelButton.layer.borderWidth = 0.5f;
    self.submitButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.submitButton.layer.borderWidth = 0.5f;
    [self fetchRecentReports];
    [self logSearch];
}

- (void)logSearch
{
    NSString *urlString = @"http://bumpn-backend.appspot.com/api/v1/searches/?key=y3hrlX2A53I1ov5cZokp9Sw9qx00D5AA";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              [self.place googlePlacesId], @"google_places_id",
                              [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"ios_device_id",
                              nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *sessionTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                           {
                                           }];
    [sessionTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
