//
//  ViewController.m
//  Bumpn
//
//  Created by KASEY MOFFAT on 10/8/14.
//  Copyright (c) 2014 KASEY MOFFAT. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResults.h"
#import "Place.h"
#import "PlaceViewController.h"


@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) Place *selectedPlace;
@property (strong, nonatomic) SearchResults *results;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation SearchViewController
@synthesize searchResultsTableView;
@synthesize selectedPlace;
@synthesize results;
@synthesize locationManager;
@synthesize currentLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:([locations count]-1)];
    [locationManager stopUpdatingLocation];
    [self featchNearbyPlaceResults:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (IBAction)editedTextField:(UITextField *)sender
{
    NSLog(@"text field changed to: %@", sender.text);
    if ([sender.text isEqualToString:@""]) {
        [locationManager startUpdatingLocation];
    } else {
        [self fetchAutocompleteSearchResults:sender.text];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"UITableViewCell"];
    }
    Place *place = [[results results] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[place name]];
    [[cell detailTextLabel] setText:[place vicinity]];
    [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    [[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[results results] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedPlace = [[results results] objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowVenueDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceViewController class]]) {
            PlaceViewController *vvc = (PlaceViewController *)segue.destinationViewController;
            vvc.place = self.selectedPlace;
        }
    }
}

- (void) fetchAutocompleteSearchResults:(NSString *)autocompleteSearchString
{
    NSLog(@"fetching autocomplete places for %@", autocompleteSearchString);
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&key=AIzaSyDyX-ApPDP50jvugAXPB6wi6_HFLg7VJUo", autocompleteSearchString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (!error) {
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            SearchResults *searchResults = [[SearchResults alloc] init];
            [searchResults readFromJSONDictionary:d];
            self.results = searchResults;
            [self updateUI];
        } else {
            NSLog(@"error: %@", error.description);
        }
    }];
    [sessionTask resume];
}

- (void) featchNearbyPlaceResults:(CLLocation *)location
{
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&types=establishment&sensor=true&key=AIzaSyDyX-ApPDP50jvugAXPB6wi6_HFLg7VJUo", latitude, longitude];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (!error) {
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            SearchResults *searchResults = [[SearchResults alloc] init];
            [searchResults readFromJSONDictionary:d];
            self.results = searchResults;
            [self updateUI];
        } else {
            NSLog(@"error: %@", error.description);
        }
    }];
    [sessionTask resume];
}
- (IBAction)doneEditing:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultsTableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // TODO: move this code to AppDelegate to start updating location earlier.
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:17/255.0 green:159/255.0 blue:246/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont fontWithName:@"AppleGothic" size:17.0]};
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchTextField.layer.borderWidth = 0.5f;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
