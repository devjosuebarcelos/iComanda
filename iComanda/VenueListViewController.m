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

@implementation VenueListViewController

@synthesize venueList, filteredVenueList, searchIsActive;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    [self setTitle:@"Lugares"];
    [[self tabBarItem] setImage:[UIImage imageNamed:@"world"]];
    [[self tabBarItem] setEnabled:![Foursquare2 isNeedToAuthorize]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
    
    [[self navigationItem] setLeftBarButtonItem:item];
    [item release];    
    
    venueList = [[NSMutableDictionary alloc] init];
    filteredVenueList = [[NSMutableDictionary alloc] init];
    
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
    [locationManager setDelegate:nil];
    [venueList release];
    
    [super dealloc];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self.searchDisplayController searchBar] addSubview:activityIndicator];
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
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ metros", [[item objectForKey:@"location"] objectForKey:@"distance"] ]];
    }else{
        NSDictionary *itemFiltered = [[[[filteredVenueList objectForKey:@"groups"] objectAtIndex:(section)] objectForKey:@"items"] objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[itemFiltered objectForKey:@"name"]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ metros", [[itemFiltered objectForKey:@"location"] objectForKey:@"distance"] ]];
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
    
    [self callSearchVenueWithQuery:searchString intent:@"match"];
    
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
                [activityIndicator stopAnimating];
            }   
        }];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Para utilizar esse recurso, você deve conectar a aplicação ao foursquare!"  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:nil] autorelease];
        [alert show];
        [activityIndicator stopAnimating];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Não foi possível determinar sua localização!"  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:nil] autorelease];
    [alert show];
}

#pragma mark - actions

- (void)refreshList:(id)sender{
    [self verifyLocationStatus];
}

- (void)callSearchVenueWithQuery:(NSString *)query intent:(NSString *)intent{
    NSString *latitude = [NSString stringWithFormat:@"%.10f", [locationManager.location coordinate].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.10f", [locationManager.location coordinate].longitude];
    [Foursquare2 searchVenuesNearByLatitude:latitude longitude:longitude accuracyLL:nil altitude:nil accuracyAlt:nil query:query limit:@"50" intent:intent callback:^(BOOL success, id result){
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
            
            [activityIndicator stopAnimating];
        }   
    }];
    
}

- (void)initLocationManager{
    if(!locationManager){
        locationManager = [[CLLocationManager alloc] init];
    }
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager setDistanceFilter:10];
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
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Você precisa autorizar o uso de sua localização para esta aplicação"  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Ajustes", nil] autorelease];
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


@end
