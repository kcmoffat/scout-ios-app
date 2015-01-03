//
//  VenueViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/10/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "PlaceViewController.h"
#import "Place.h"
#import "Report.h"
#import "CameraViewController.h"
#import "ImageDownloader.h"
#import "Utils.h"
#import "Constants.h"
#import "Logger.h"
#import "RequestUploader.h"
#import "PlaceDetailsDownloader.h"
#import "RequestViewController.h"

@interface PlaceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RecentReports *recentReports;
@property (strong, nonatomic) NSMutableDictionary *imageDownloadsInProgress;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *addUpdateButton;
@end

@implementation PlaceViewController
@synthesize place;
@synthesize recentReports;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self setTitle:[place name]];
    [self.callButton setEnabled:NO];
    UIColor *borderColor = [[UIColor alloc] initWithWhite:0.8f alpha:1];
    float borderWidth = 0.3f;
    self.requestButton.layer.borderColor = [borderColor CGColor];
    self.requestButton.layer.borderWidth = borderWidth;
    self.callButton.layer.borderColor = [borderColor CGColor];
    self.callButton.layer.borderWidth = borderWidth;
    self.addUpdateButton.layer.borderColor = [borderColor CGColor];
    self.addUpdateButton.layer.borderWidth = borderWidth;
    [self getPlaceDetails];
    [self logSearch];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchRecentReports];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.recentReports reports] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Report *report = [[self.recentReports reports] objectAtIndex:[indexPath row]];
    NSLog(@"report imageURL for cell: %@", report.imageURL);
    // Set labels
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCellTagsImage"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"ReportCellTagsImage"];
    }
    if (![report.imageURL isEqual:[NSNull null]]) {
        NSLog(@"report.imageURL != nil: %d", report.imageURL != nil);
        NSLog(@"![report.imageURL isEqual:[NSNull null]]: %d", ![report.imageURL isEqual:[NSNull null]]);
        if (!report.image) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                NSLog(@"loading table cell with image, starting image download");
                [self startImageDownload:report forIndexPath:indexPath];
            }
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.image = nil;
        } else {
            NSLog(@"Setting cached image");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
                imageView.image = report.image;
            });
            NSLog(@"Done setting cached image");
        }
    }
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
    NSString *dateText = [Utils elapsedTime:report.createdAt];
    NSString *justificationText = [self justificationText:report.tags];
    NSString *cellLabelText = [NSString stringWithFormat:@"%@ %@", dateText, justificationText];
    [timeLabel setText:cellLabelText];
    UILabel *tagsLabel = (UILabel *)[cell viewWithTag:3];
    NSLog(@"tags: %@", report.tags.description);
    [tagsLabel setText:[report.tags componentsJoinedByString:@", "]];
    UITextView *comments = (UITextView *)[cell viewWithTag:4];
    NSLog(@"setting comments to: %@", report.comments);
    if (![report.comments isEqual:[NSNull null]]) {
        comments.text = report.comments;
    } else {
        [comments removeFromSuperview];
    }
    return cell;
}

- (NSString *)justificationText:(NSMutableArray *)tags
{
    if ([tags containsObject:@"I'm here"]) {
        return @"from a scout currently there";
    } else if ([tags containsObject:@"I called"]) {
        return @"from a scout that called in";
    } else if ([tags containsObject:@"I walked by"]) {
        return @"from a scout that walked by";
    } else {
        return @"";
    }
}

- (void)startImageDownload:(Report *)report forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (imageDownloader == nil) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.report = report;
        imageDownloader.completionHandler = ^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"Setting newly downloaded image");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
                imageView.image = report.image;
                //                cell.imageView.image = report.image;
            });
            NSLog(@"Done setting newly downloaded image");
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        };
        (self.imageDownloadsInProgress)[indexPath] = imageDownloader;
        NSLog(@"starting image download");
        [imageDownloader startDownload];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)loadImagesForOnscreenRows
{
    NSLog(@"loading images for onscreen rows");
    if ([self.recentReports.reports count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Report *report = self.recentReports.reports[indexPath.row];
            if (![report.imageURL isEqual:[NSNull null]] && !report.image) {
                NSLog(@"![report.imageURL isEqual:[NSNull null]]: %d", ![report.imageURL isEqual:[NSNull null]]);
                NSLog(@"loading images for onscreen rows, starting image download");
                [self startImageDownload:report forIndexPath:indexPath];
            }
        }
    }
}

- (void) cancelAllDownloads
{
    NSLog(@"Cancelling all downloads");
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)fetchRecentReports
{
    NSString *urlString = [NSString stringWithFormat:@"%@?key=%@&google_places_id=%@", appEngineReportURLPrefix, appEngineAPIKey, self.place.googlePlacesId];
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

- (IBAction)tapCallButton:(UIButton *)sender
{
    [self.callButton setEnabled:NO];
    NSURL *phoneNumber = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.place.phone]];
    NSLog(@"Calling phone number: %@", self.place.phone);
    if ([[UIApplication sharedApplication] canOpenURL:phoneNumber]) {
        if (self.place.phone != nil && ![self.place.phone isEqual:[NSNull null]]) {
            [[UIApplication sharedApplication] openURL:phoneNumber];
            [self.callButton setEnabled:YES];
            [self logCall];
        }
    }
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)logSearch
{
    Logger *searchLogger = [[Logger alloc] init];
    searchLogger.place = self.place;
    [searchLogger startSearchLoggerUpload];
}

- (void)logCall
{
    NSLog(@"logging call");
    Logger *callLogger = [[Logger alloc] init];
    callLogger.place = self.place;
    [callLogger startCallLoggerUpload];
}

- (void)getPlaceDetails
{
    PlaceDetailsDownloader *placeDetailsDownloader = [[PlaceDetailsDownloader alloc] init];
    placeDetailsDownloader.place = self.place;
    placeDetailsDownloader.completionHandler = ^{
        if (self.place.phone != nil && ![self.place.phone isEqual:[NSNull null]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reenabling call button");
                [self.callButton setEnabled:YES];
            });
        }
    };
    [placeDetailsDownloader startDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self cancelAllDownloads];
    [ImageDownloader clearImageCache];
}

-(void)dealloc
{
    NSLog(@"dealloc'ing PlaceViewController");
    [self cancelAllDownloads];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"called prepareForSegue");
    if ([segue.identifier isEqualToString:@"ShowCamera"]) {
        NSLog(@"segue is ShowCamera");
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            NSLog(@"preparing to show camera");
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            CameraViewController *cvc = (CameraViewController *)navigationController.topViewController;
            cvc.place = self.place;
            NSLog(@"cvc.place: %@", cvc.place);
            NSLog(@"self.place: %@", self.place);
        }
    } else if ([segue.identifier isEqualToString:@"RequestUpdate"]) {
        NSLog(@"segue is RequestUpdate");
        if ([segue.destinationViewController isKindOfClass:[RequestViewController class]]) {
            RequestViewController *rvc = (RequestViewController *)segue.destinationViewController;
            rvc.place = self.place;
        }
    }
}

@end
