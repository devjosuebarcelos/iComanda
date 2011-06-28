//
//  VenueListViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VenueListViewController.h"
#import "VenueDetailViewController.h"
#import "Foursquare2.h"

#define REFRESH_HEADER_HEIGHT 52.0f
static NSString *FOURSQUARE_RESULTS_LIMIT = @"50";

@implementation VenueListViewController

@synthesize venueList, filteredVenueList, searchIsActive,textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil){
        [self setTitle:NSLocalizedString(@"Places", @"VenueListViewController:Title:Places")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"world"]];
        [[self tabBarItem] setEnabled:![Foursquare2 isNeedToAuthorize]];
        
        venueList = [[NSMutableDictionary alloc] init];
        filteredVenueList = [[NSMutableDictionary alloc] init];
        
        textPull = NSLocalizedString(@"Pull down to refresh...", @"VenueListViewController:Pull down to refresh...");
        textRelease = NSLocalizedString(@"Release to refresh...", @"VenueListViewController:Release to refresh...");
        textLoading = NSLocalizedString(@"Loading...", @"VenueListViewController:Loading...");
    }
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    [locationManager release];
    [venueList release];
    
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    
    [super dealloc];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self.searchDisplayController searchBar] addSubview:activityIndicator];
    
    [self addPullToRefreshHeader];
    
    [self verifyLocationStatus];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [venueTableView release];
    venueTableView = nil;
    
    [activityIndicator release];
    activityIndicator = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [venueTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
    [locationManager setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - table view datasource and delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"VenueCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = [indexPath section];
    
    if(tableView != [self.searchDisplayController searchResultsTableView]){
        section--;
        NSDictionary *item = [[[[venueList objectForKey:@"groups"] objectAtIndex:(section)] objectForKey:@"items"] objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[item objectForKey:@"name"]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"%@ meters", @"VenueListViewController:Formatted:meters"), [[item objectForKey:@"location"] objectForKey:@"distance"] ]];
    }else{
        NSDictionary *itemFiltered = [[[[filteredVenueList objectForKey:@"groups"] objectAtIndex:(section)] objectForKey:@"items"] objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[itemFiltered objectForKey:@"name"]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"%@ meters", @"VenueListViewController:Formatted:meters"), [[itemFiltered objectForKey:@"location"] objectForKey:@"distance"] ]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView != self.searchDisplayController.searchResultsTableView){
        NSArray *groups = [venueList objectForKey:@"groups"];
        if(section > 0){
            return [[[groups objectAtIndex:(section-1)] objectForKey:@"items"] count];
        }else{
            return 0;
        }
    }else{
        NSArray *groups = [filteredVenueList objectForKey:@"groups"];
        return [[[groups objectAtIndex:(section)] objectForKey:@"items"] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView != self.searchDisplayController.searchResultsTableView){
        return [[venueList objectForKey:@"groups"] count]+1;
    }else{
        return [[filteredVenueList objectForKey:@"groups"] count];
    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView != self.searchDisplayController.searchResultsTableView && section == 0){
        return self.searchDisplayController.searchBar.bounds.size.height;
    }else{
        return 22;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView != self.searchDisplayController.searchResultsTableView){
        if(section > 0){
            return [[[venueList objectForKey:@"groups"] objectAtIndex:(section-1)] objectForKey:@"name"];
        }else{
            return nil;
        }
    }else{
        return [[[filteredVenueList objectForKey:@"groups"] objectAtIndex:(section)] objectForKey:@"name"];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VenueDetailViewController *venueDetailVC = [[VenueDetailViewController alloc] init];
    if (tableView != self.searchDisplayController.searchResultsTableView){
        NSDictionary *item = [[[[venueList objectForKey:@"groups"] objectAtIndex:([indexPath section] -1)] objectForKey:@"items"] objectAtIndex:[indexPath row]];
        [venueDetailVC setVenue: item];
    }else{
        NSDictionary *filteredItem = [[[[filteredVenueList objectForKey:@"groups"] objectAtIndex:([indexPath section])] objectForKey:@"items"] objectAtIndex:[indexPath row]];
        [venueDetailVC setVenue: filteredItem];
    }
    
    [[self navigationController] pushViewController:venueDetailVC animated:YES];
    [venueDetailVC release];
}


#pragma mark - search bar protocol
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    // set searcIsActive to YES
    [self setSearchIsActive:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
    [self setSearchIsActive:NO];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString{
    
    if(![activityIndicator isAnimating]){
        [self callSearchVenueWithQuery:searchString intent:@"match"];
    }
    return YES;
}


#pragma mark - location manager protocol
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSString *latitude = [NSString stringWithFormat:@"%.10f", [newLocation coordinate].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.10f", [newLocation coordinate].longitude];
    
    if(![Foursquare2 isNeedToAuthorize]){
        [Foursquare2 searchVenuesNearByLatitude:latitude longitude:longitude accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:@"50" intent:@"checkin" callback:^(BOOL success, id result){
            if (success) {
                [self setVenueList:[result objectForKey:@"response"]];
                [venueTableView reloadData];
                [self stopLoading];
            }   
        }];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"Alerts:Error:Title:Error!") 
                                                         message:NSLocalizedString(@"In order to use this resource you should connect this application with your foursquare user!", @"VenueListViewController:Alerts:Error:Messages:Should connecto to foursquare")  
                                                        delegate:self 
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", @"Alerts:Buttons:Cancel") 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        [self stopLoading];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"Alerts:Error:Title:Error!") 
                                                     message:NSLocalizedString(@"Couldn't determine your current location!", @"VenueListViewController:Alerts:Error:Messages:Couldnt determine user location")
                                                    delegate:self 
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"Alerts:Buttons:Cancel") 
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

#pragma mark - actions

- (void)refreshList:(id)sender{
    [self verifyLocationStatus];
    
}

- (void)callSearchVenueWithQuery:(NSString *)query intent:(NSString *)intent{
    NSString *latitude = [NSString stringWithFormat:@"%.10f", [locationManager.location coordinate].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.10f", [locationManager.location coordinate].longitude];
    [Foursquare2 searchVenuesNearByLatitude:latitude longitude:longitude accuracyLL:nil altitude:nil accuracyAlt:nil query:query limit:FOURSQUARE_RESULTS_LIMIT intent:intent callback:^(BOOL success, id result){
        if (success) {
            if([intent isEqualToString:@"match"]){
                [self setFilteredVenueList:[result objectForKey:@"response"]];
                if(searchIsActive){
                    NSLog(@"filteredVenueList... reloading searchDisplayController table");
                    [[self.searchDisplayController searchResultsTableView] reloadData];
                }
            }else{
                [self setVenueList:[result objectForKey:@"response"]];
                [venueTableView reloadData];
            }
            [self stopLoading];
        }   
    }];
    
}

- (void)initLocationManager{
    if(!locationManager){
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDistanceFilter:10];
    }
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
}

- (void)verifyLocationStatus{
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorized:{
            [self initLocationManager];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"Alerts:Error:Title:Error!") 
                                                             message:NSLocalizedString(@"In order to use this resource you need to authorize this app to use location services!", @"VenueListViewController:Alerts:Error:Messages:Needs authorization for location")
                                                            delegate:self 
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"Alerts:Buttons:OK")
                                                   otherButtonTitles:nil] autorelease];
            [self stopLoading];
            [alert show];
            break;
        }
        default:{
            [self initLocationManager];
            break;
        }
            
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //button assigned for setting
        //must launch settings app

    }else{
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}


#pragma mark - PullRefresh methods

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 48) / 2,
                                    (REFRESH_HEADER_HEIGHT - 48) / 2,
                                    48, 48);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [venueTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            venueTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            venueTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    venueTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    venueTableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    [activityIndicator stopAnimating];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh{
     [self performSelector:@selector(refreshList:) withObject:nil afterDelay:.5];
}



@end
