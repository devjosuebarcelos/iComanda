//
//  VenueDetailViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "iComandaAppDelegate.h"
#import "Foursquare2.h"

@implementation VenueDetailViewController

@synthesize venue;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
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
    [venue release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Check-in"];
    
    //set the name of the current venue
    [venueNameLabel setText:[venue objectForKey:@"name"]];
    //set the address of the current venue
    NSString *address = [[venue objectForKey:@"location"] objectForKey:@"address"];
    NSString *city = [[venue objectForKey:@"location"] objectForKey:@"city"];
    NSString *completeAddress = [NSString stringWithFormat:@"%@ %@ %@", (address != nil)?address:@"",(address != nil && city != nil)?@"-":@"", (city != nil)?city:@"" ];
    [venueAddressLabel setText:completeAddress];
    //set the phone of the current venue
    NSString *phoneDescription;
    if([[venue objectForKey:@"contact"] objectForKey:@"phone"]){
        phoneDescription = [NSString stringWithFormat:@"Fone: %@", [[venue objectForKey:@"contact"] objectForKey:@"phone"]]; 
    }else{
        phoneDescription = @"";
    }
    [venuePhoneLabel setText: phoneDescription];
    //set the hereNow property of the current venue
    NSString *hereNow = [NSString stringWithFormat:@"%@ pessoas aqui", [[venue objectForKey:@"hereNow"] objectForKey:@"count"]];
    [peopleCountLabel setText:hereNow];
    
    [[self view] setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [venueNameLabel release];
    venueNameLabel = nil;
    
    [venueAddressLabel release];
    venueAddressLabel = nil;
    
    [venuePhoneLabel release];
    venuePhoneLabel = nil;
    
    [peopleCountLabel release];
    peopleCountLabel = nil;
    
    [checkInButton release];
    checkInButton = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Action methods

- (void)checkInSucceeded:(NSDictionary *)response{
    
    if([switchAddAsTab isOn]){
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
        [appDel setSelectedTabObject:nil];
        
        NSString *label = [venue objectForKey:@"name"];
        NSDecimalNumber *limitValue = (NSDecimalNumber*)[NSDecimalNumber numberWithInt:0];
        NSString *lastCheckedInVenueId = [venue objectForKey:@"id"];
        BOOL tipCharged = NO;
        
        NSManagedObjectContext *moc = [appDel managedObjectContext];
        
        NSManagedObject *tab = [NSEntityDescription insertNewObjectForEntityForName:TAB_ENTITY inManagedObjectContext:moc];
        [tab setValue:[NSDate date] forKey:DATE_ATT];
        
        [tab setValue:label forKey:TAB_LABEL];
        [tab setValue:limitValue forKey:LIMIT_ATT];
        
        [tab setValue:lastCheckedInVenueId forKey:VENUEID_ATT];
        [tab setValue:[NSNumber numberWithBool:tipCharged ] forKey:TIPCHARGED_ATT];
        
        [appDel saveContext];
    }
    //end the method stopping the activityIndicator
    [activityIndicator stopAnimating];
    [[self tabBarController] setSelectedIndex:0];    
    [[self navigationController] popViewControllerAnimated:YES];

}

- (IBAction)checkInHere:(id)sender{
    
    [activityIndicator startAnimating];
    [sender setEnabled:NO];
    //create check-in for this venue
    [Foursquare2 createCheckinAtVenue:[venue objectForKey:@"id"] 
                                venue:[venue objectForKey:@"name"] 
                                shout:nil 
                            broadcast:broadcastPublic
                             latitude:[[venue objectForKey:@"location"] objectForKey:@"lat"] 
                            longitude:[[venue objectForKey:@"location"] objectForKey:@"lng"] 
                           accuracyLL:@"1" 
                             altitude:@"0" 
                          accuracyAlt:@"1" 
                             callback:^(BOOL success, id result){
                                 if (success) {
                                     [self checkInSucceeded:result];
                                 }   
                             }];
    
}

@end
