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
#import "Constants.h"
#import "CameraViewController.h"
#import "RecentSearchesDownloader.h"


@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) Place *selectedPlace;
@property (strong, nonatomic) SearchResults *results;
@property (strong, nonatomic) SearchResults *nearbyResults;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation SearchViewController
@synthesize searchResultsTableView;
@synthesize selectedPlace;
@synthesize results;
@synthesize nearbyResults;
@synthesize locationManager;
@synthesize currentLocation;
@synthesize searchBar;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:([locations count]-1)];
    if (currentLocation.horizontalAccuracy < 100) {
        [self.locationManager stopUpdatingLocation];
        NSLog(@"accuracy achieved, fetching nearby places");
        [self fetchNearbyPlaceResults:self.currentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"search bar editing began");
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self checkLocationServicesStatus];
    [self fetchRecentSearches];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.searchBar setText:nil];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self fetchAutocompleteSearchResults:searchText];
}

- (IBAction)editedTextField:(UITextField *)sender
{
    NSLog(@"text field changed to: %@", sender.text);
    if ([sender.text isEqualToString:@""]) {
        [self fetchRecentSearches];
        [self.locationManager startUpdatingLocation];
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
    Place *place = (Place *)[NSNull null];
    if ([self.searchTextField.text length] == 0) {
        if ([indexPath section] == 0) {
            NSLog(@"setting row: %ld section %ld", (long)[indexPath row], (long)[indexPath section]);
            place = [[results results] objectAtIndex:[indexPath row]];
        } else {
            NSLog(@"setting cell to nearby place result");
            place = [[nearbyResults results] objectAtIndex:[indexPath row]];
        }
    } else {
        place = [[results results] objectAtIndex:[indexPath row]];
    }
    if (![place.name isEqual:[NSNull null]]) {
        NSLog(@"setting cell name to: %@", [place name]);
        [[cell textLabel] setText:[place name]];
        NSLog(@"set cell name to: %@", [place name]);
        [[cell detailTextLabel] setText:[place vicinity]];
        [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
        [[cell detailTextLabel] setTextColor:[UIColor lightGrayColor]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchTextField.text length] == 0) {
        if (section == 0) {
            return [[results results] count];
        } else {
            NSLog(@"number of rows in section %ld: %lu", (long)section, (unsigned long)[[nearbyResults results] count]);
            return [[nearbyResults results] count];
        }
    } else {
        return [[results results] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView starting");
    NSLog(@"self.searchTextField.text: %@", self.searchTextField.text);
    if ([self.searchTextField.text length] == 0) {
        return 2;
    } else {
        NSLog(@"1 sections in table");
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.searchTextField.text length] == 0) {
        if ([indexPath section] == 0) {
            selectedPlace = [[results results] objectAtIndex:[indexPath row]];
            [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
        } else {
            selectedPlace = [[nearbyResults results] objectAtIndex:[indexPath row]];
            [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
        }
    } else {
        selectedPlace = [[results results] objectAtIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"ShowVenueDetail" sender:self];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.searchTextField.text length] == 0) {
        if (section == 0) {
            return @"RECENT SEARCHES";
        } else {
            return @"NEARBY PLACES";
        }
    } else {
        return nil;
    }
}


- (void) fetchRecentSearches
{
    RecentSearchesDownloader *recentSearchesDownloader = [[RecentSearchesDownloader alloc] init];
    __weak RecentSearchesDownloader *weakRecentSearchesDownloader = recentSearchesDownloader;
    [recentSearchesDownloader setCompletionHandler:^{
        self.results = [weakRecentSearchesDownloader searchResults];
        [self updateUI];
    }];
    [recentSearchesDownloader startDownload];
}

- (void) fetchAutocompleteSearchResults:(NSString *)autocompleteSearchString
{
    NSLog(@"fetching autocomplete places for %@", autocompleteSearchString);
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyDyX-ApPDP50jvugAXPB6wi6_HFLg7VJUo", autocompleteSearchString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (!error) {
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            SearchResults *searchResults = [[SearchResults alloc] init];
            [searchResults readAutocompleteResultsFromJSONDictionary:d];
            self.results = searchResults;
            [self updateUI];
        } else {
            NSLog(@"error: %@", error.description);
        }
    }];
    [sessionTask resume];
}

- (void) fetchNearbyPlaceResults:(CLLocation *)location
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
            NSLog(@"nearby search results: %@", [d description]);
            SearchResults *searchResults = [[SearchResults alloc] init];
            [searchResults readNearbySearchResultsFromJSONDictionary:d];
            self.nearbyResults = searchResults;
            NSLog(@"updating table");
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

- (void)checkLocationServicesStatus
{
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"location services are enabled on device, checking app permissions");
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"app is allowed to use location services while in use");
            [self.locationManager startUpdatingLocation];
        } else {
            NSLog(@"requesting authorization to use location services");
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                NSLog(@"iOS 8.x or later");
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                // iOS 7.x and earlier
                NSLog(@"iOS 7.x or earlier");
                [self.locationManager startUpdatingLocation];
            }
        }
    } else {
        NSLog(@"location services not enabled, prompting to change settings");
        [self promptToChangeLocationSettings];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"location manager authorization changed");
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS 8.x or later.  Do nothing, we don't have permisssion
        } else {
            // iOS 7.x and earlier
            [self.locationManager startUpdatingLocation];
        }
    }
}

-(void)promptToChangeLocationSettings
{
    if (&UIApplicationOpenSettingsURLString != NULL) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services disabled" message:@"Scout uses your location to find nearby places.  You can turn on location services in Settings->Privacy->Location Services." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services disabled" message:@"Scout uses your location to find nearby places.  You can turn on location services in Settings->Privacy->Location Services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad was called");
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:17/255.0 green:159/255.0 blue:246/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"AppleGothic" size:17.0]};
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.searchTextField.layer.borderWidth = 0.5f;
    [CameraViewController sharedImagePickerController];
    self.searchBar = [[UISearchBar alloc] init];
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.navigationItem.titleView = self.searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"Search...";
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    [self fetchRecentSearches];
    [self checkLocationServicesStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
